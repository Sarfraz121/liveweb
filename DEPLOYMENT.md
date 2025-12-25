# 🚀 LiveWeb Deployment Guide

This guide explains how to deploy LiveWeb to your production server.

## 📋 Prerequisites

- **Server**: Ubuntu/Debian Linux server with SSH access
- **Node.js**: Version 22+ installed
- **PM2**: Process manager (will be installed automatically)
- **Nginx**: Optional, for custom domain with SSL
- **Port Availability**: Port 3001 (default) - port 3000 is used by latoxicatst-frontend

## ⚠️ Port Configuration

**Important:** Your server already has services running:
- Port 3000: `latoxicatst-frontend` (Docker)
- Port 8080: `infrastructure-wrapper_api-1`
- Port 3005: `infrastructure-github_template_deployer-1`
- Port 5500: `infrastructure-unified_content_service-1`
- And others...

**LiveWeb will use port 3001 by default** to avoid conflicts. You can change this via the `APP_PORT` secret or `.env` file.

## 🔧 GitHub Secrets Configuration

Configure these secrets in your GitHub repository (Settings → Secrets and variables → Actions):

### Required Secrets

| Secret | Description | Example |
|--------|------------|---------|
| `SERVER_IP` | Your server IP address | `123.45.67.89` |
| `SERVER_USER` | SSH user (default: root) | `root` or `ubuntu` |
| `SERVER_SSH_KEY` | SSH private key (preferred) | `-----BEGIN RSA PRIVATE KEY-----...` |
| `SERVER_PASSWORD` | SSH password (alternative) | `your_password` |
| `GEMINI_API_KEY` | Google Gemini API key | `AIza...` |

### Optional Secrets

| Secret | Description | Example |
|--------|------------|---------|
| `API_BASE_URL` | Backend API URL | `https://api.yourdomain.com` |
| `DOMAIN` | Custom domain | `liveweb.yourdomain.com` |
| `APP_PORT` | Backend port (default: 3001) | `3001` or `3002` |

## 🎯 Deployment Methods

### Method 1: Automatic Deployment via GitHub Actions (Recommended)

1. **Push to main/master branch** - Deployment triggers automatically
2. **Or use workflow_dispatch** - Manual trigger from GitHub Actions tab

The workflow will:
- ✅ Build and test the application
- ✅ Build frontend for production
- ✅ Copy files to server
- ✅ Install dependencies
- ✅ Start application with PM2 on port 3001
- ✅ Verify deployment

### Method 2: Manual Deployment

1. **Clone repository on server:**
   ```bash
   cd /opt
   git clone https://github.com/yourusername/liveweb.git
   cd liveweb
   ```

2. **Install dependencies:**
   ```bash
   npm ci
   cd frontend && npm ci && npm run build && cd ..
   ```

3. **Create .env file:**
   ```bash
   cp .env.example .env
   nano .env
   # Add:
   # GEMINI_API_KEY=your_key_here
   # PORT=3001
   ```

4. **Run deployment script:**
   ```bash
   cd infrastructure
   chmod +x scripts/*.sh
   ./scripts/deploy.sh
   ```

## 🌐 Domain Configuration

### Option A: IP Address (Default)

Application will be available at:
- **Backend API**: `http://YOUR_SERVER_IP:3001`
- **Frontend**: Served by backend on port 3001

### Option B: Custom Domain with Nginx

1. **Point DNS to your server:**
   ```
   A record: liveweb.yourdomain.com → YOUR_SERVER_IP
   ```

2. **Setup Nginx:**
   ```bash
   sudo ./infrastructure/scripts/setup-nginx.sh yourdomain.com
   ```

3. **Get SSL certificate:**
   ```bash
   sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
   ```

4. **Application will be available at:**
   - **Frontend**: `https://yourdomain.com`
   - **Backend API**: `https://yourdomain.com/api`

## 🔒 Port Configuration

### Default Ports

- **Backend**: `3001` (changed from 3000 to avoid conflict with latoxicatst-frontend)
- **Frontend (Nginx)**: `80` (HTTP) / `443` (HTTPS)

### Changing Ports (If Needed)

If port 3001 is also in use:

1. **Change backend port:**
   ```bash
   # In .env file or GitHub Secret APP_PORT
   PORT=3002
   ```

2. **Update Nginx config:**
   ```nginx
   upstream liveweb_backend {
       server 127.0.0.1:3002;  # Changed port
   }
   ```

3. **Update frontend build:**
   ```bash
   # Set VITE_API_BASE_URL before building
   export VITE_API_BASE_URL=http://yourdomain.com:3002
   cd frontend && npm run build
   ```

## 📊 Monitoring

### PM2 Commands

```bash
# Check status
pm2 status liveweb

# View logs
pm2 logs liveweb

# Restart
pm2 restart liveweb

# Stop
pm2 stop liveweb

# Monitor
pm2 monit
```

### Health Checks

```bash
# Backend health (default port 3001)
curl http://localhost:3001/health

# API health
curl http://localhost:3001/api/health
```

## 🐛 Troubleshooting

### Application Not Starting

1. **Check PM2 logs:**
   ```bash
   pm2 logs liveweb --lines 50
   ```

2. **Check environment variables:**
   ```bash
   cd /opt/liveweb
   cat .env
   ```

3. **Verify Node.js version:**
   ```bash
   node --version  # Should be 22+
   ```

### Port Already in Use

```bash
# Find process using port 3001
sudo lsof -i :3001

# Or check all ports
sudo netstat -tulpn | grep LISTEN

# Kill process (if safe)
sudo kill -9 <PID>

# Or change port in .env
```

### Port Conflict with Other Services

Your server has these ports in use:
- 3000: latoxicatst-frontend
- 8080: infrastructure-wrapper_api-1
- 3005: infrastructure-github_template_deployer-1
- 5500: infrastructure-unified_content_service-1

**Solution:** LiveWeb uses port 3001 by default. If that's also in use, change it:
```bash
# In .env
PORT=3002  # or any other available port
```

### Frontend Not Loading

1. **Check if frontend/dist exists:**
   ```bash
   ls -la /opt/liveweb/frontend/dist
   ```

2. **Rebuild frontend:**
   ```bash
   cd /opt/liveweb/frontend
   npm run build
   ```

3. **Check Nginx configuration:**
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

### API Connection Errors

1. **Verify API_BASE_URL:**
   - Check `.env` file
   - Check frontend build was done with correct `VITE_API_BASE_URL`

2. **Check CORS configuration:**
   - Verify `server/middleware/cors.js` allows your domain

## 🔄 Updating Application

### Automatic (GitHub Actions)

Just push to `main` or `master` branch - deployment happens automatically.

### Manual Update

```bash
cd /opt/liveweb
git pull origin main
cd frontend && npm ci && npm run build && cd ..
cd infrastructure && ./scripts/deploy.sh
```

## 📝 Post-Deployment Checklist

- [ ] Application accessible at configured URL
- [ ] Health check endpoint responding on port 3001
- [ ] API endpoints working
- [ ] Frontend loading correctly
- [ ] Voice recognition working (HTTPS required for Web Speech API)
- [ ] PM2 process running and auto-restarting
- [ ] Logs being written correctly
- [ ] SSL certificate configured (if using custom domain)
- [ ] No port conflicts with existing services

## 🔐 Security Considerations

1. **Firewall**: Configure UFW or iptables to allow only necessary ports
2. **Fail2ban**: Consider enabling for SSH protection
3. **SSL**: Always use HTTPS in production (required for Web Speech API)
4. **Environment Variables**: Never commit `.env` files
5. **API Keys**: Rotate keys regularly
6. **Port Isolation**: LiveWeb runs on separate port (3001) from other services

## 📞 Support

For deployment issues, check:
- PM2 logs: `pm2 logs liveweb`
- Nginx logs: `/var/log/nginx/liveweb-error.log`
- Application logs: `/opt/liveweb/logs/`
- Port conflicts: `sudo netstat -tulpn | grep LISTEN`
