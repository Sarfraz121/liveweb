#!/bin/bash

# Setup Nginx on HOST to proxy to Docker container
# This is needed BEFORE SSL setup
# Usage: ./setup-nginx-proxy.sh yourdomain.com

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    echo "Example: $0 liveweb.website"
    exit 1
fi

DOMAIN=$1
APP_DIR="/opt/liveweb"
NGINX_SITES_AVAILABLE="/etc/nginx/sites-available"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled"

echo "🔧 Setting up Nginx proxy for domain: $DOMAIN"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

# Install Nginx if not installed
if ! command -v nginx &> /dev/null; then
    echo "📦 Installing Nginx..."
    apt-get update -qq
    apt-get install -y -qq nginx
fi

# Create temporary HTTP-only config (before SSL)
echo "📝 Creating Nginx configuration (HTTP only, for Let's Encrypt)..."
cat > "$NGINX_SITES_AVAILABLE/liveweb" << NGINXEOF
# LiveWeb - HTTP Configuration (temporary, before SSL)
# This will be updated by certbot to add SSL

upstream liveweb_backend {
    server 127.0.0.1:3001;
    keepalive 32;
}

server {
    listen 80;
    listen [::]:80;
    server_name ${DOMAIN} www.${DOMAIN};
    
    # Let's Encrypt challenge
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
    
    # IMPORTANTE: Permitir uploads de archivos grandes
    client_max_body_size 10M;
    
    # Proxy ALL requests to Docker container
    location / {
        proxy_pass http://liveweb_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        
        # SSE support
        proxy_buffering off;
        proxy_read_timeout 86400;
    }
}
NGINXEOF

# Create symlink
if [ -L "$NGINX_SITES_ENABLED/liveweb" ]; then
    rm "$NGINX_SITES_ENABLED/liveweb"
fi
ln -s "$NGINX_SITES_AVAILABLE/liveweb" "$NGINX_SITES_ENABLED/liveweb"

# Remove default nginx site
if [ -L "$NGINX_SITES_ENABLED/default" ]; then
    rm "$NGINX_SITES_ENABLED/default"
fi

# Create directory for Let's Encrypt
mkdir -p /var/www/certbot

# Test Nginx configuration
echo "🧪 Testing Nginx configuration..."
nginx -t || {
    echo "❌ Nginx configuration test failed!"
    exit 1
}

# Reload Nginx
echo "🔄 Reloading Nginx..."
systemctl reload nginx

echo ""
echo "✅ Nginx proxy configured!"
echo ""
echo "🌐 Your application should now be accessible at:"
echo "   - http://${DOMAIN}"
echo "   - http://www.${DOMAIN}"
echo ""
echo "📝 Next step: Configure SSL/HTTPS"
echo "   Run: sudo /opt/liveweb/infrastructure/scripts/setup-ssl-domain.sh ${DOMAIN}"
