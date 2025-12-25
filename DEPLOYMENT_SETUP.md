# 🚀 LiveWeb Deployment Setup - Complete Guide

## ✅ What Has Been Configured

### 1. GitHub Actions Workflows

- **`.github/workflows/ci.yml`**: Continuous Integration
  - Runs on push/PR to main/master
  - Builds and tests the application
  
- **`.github/workflows/deploy.yml`**: Production Deployment
  - Runs on push to main/master
  - Builds frontend
  - Deploys to server via SSH
  - Uses PM2 for process management

### 2. Infrastructure Files

- **`Dockerfile`**: Multi-stage Docker build for backend
- **`docker-compose.yml`**: Docker Compose configuration (optional)
- **`infrastructure/nginx/`**: Nginx configurations
  - `nginx.conf`: Main Nginx config
  - `default.conf`: Docker Compose config
  - `liveweb.conf`: Production domain config

### 3. Deployment Scripts

- **`infrastructure/scripts/deploy.sh`**: Main deployment script
- **`infrastructure/scripts/verify-deployment.sh`**: Verification script
- **`infrastructure/scripts/setup-nginx.sh`**: Nginx setup script

### 4. Server Configuration

- **Backend serves frontend** in production mode
- **CORS configured** for multiple origins
- **API_BASE_URL** configurable via environment variable

## 🎯 Deployment Architecture

```
┌─────────────────────────────────────┐
│      GitHub Actions (CI/CD)          │
│  - Build frontend                    │
│  - Copy files to server              │
│  - Run deployment script             │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│      Production Server                │
│  /opt/liveweb/                       │
│  ├── server/          (Backend)      │
│  ├── frontend/dist/   (Frontend)     │
│  ├── infrastructure/   (Scripts)      │
│  └── .env             (Config)       │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│      PM2 Process Manager             │
│  - Manages Node.js process           │
│  - Auto-restart on failure           │
│  - Logs management                   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│      Application                     │
│  - Backend: Port 3000               │
│  - Frontend: Served by backend       │
│  - Or via Nginx: Port 80/443        │
└─────────────────────────────────────┘
```

## 🔧 Configuration Steps

### Step 1: Configure GitHub Secrets

See [`.github/SECRETS_SETUP.md`](.github/SECRETS_SETUP.md) for detailed instructions.

**Minimum required secrets:**
- `SERVER_IP`
- `SERVER_USER` (or use default `root`)
- `SERVER_SSH_KEY` OR `SERVER_PASSWORD`
- `GEMINI_API_KEY`

### Step 2: Server Preparation

On your server, ensure:
- Node.js 22+ is installed
- PM2 is available (will be installed by script)
- Port 3000 is available (or change in `.env`)
- Firewall allows SSH (port 22) and application port

### Step 3: First Deployment

1. Push code to `main` or `master` branch
2. GitHub Actions will automatically:
   - Build frontend
   - Copy files to server
   - Run deployment script
   - Start application with PM2

### Step 4: Verify Deployment

```bash
# SSH into server
ssh user@your-server-ip

# Check PM2 status
pm2 status liveweb

# Check health
curl http://localhost:3000/health

# View logs
pm2 logs liveweb
```

## 🌐 Domain Configuration (Optional)

### Option A: IP Address Only

Application accessible at:
- `http://YOUR_SERVER_IP:3000`

### Option B: Custom Domain with SSL

1. **Point DNS:**
   ```
   A record: liveweb.yourdomain.com → YOUR_SERVER_IP
   ```

2. **Setup Nginx:**
   ```bash
   sudo ./infrastructure/scripts/setup-nginx.sh yourdomain.com
   ```

3. **Get SSL:**
   ```bash
   sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
   ```

4. **Application accessible at:**
   - `https://yourdomain.com`

## 🔄 Avoiding Port Conflicts

If port 3000 is already in use by another service:

1. **Change backend port:**
   ```env
   # In .env file
   PORT=3001
   ```

2. **Update frontend build:**
   ```bash
   # Set before building
   export VITE_API_BASE_URL=http://yourdomain.com:3001
   cd frontend && npm run build
   ```

3. **Update Nginx (if using):**
   ```nginx
   upstream liveweb_backend {
       server 127.0.0.1:3001;  # New port
   }
   ```

## 📊 Monitoring & Maintenance

### PM2 Commands

```bash
# Status
pm2 status

# Logs
pm2 logs liveweb

# Restart
pm2 restart liveweb

# Stop
pm2 stop liveweb

# Monitor
pm2 monit
```

### Application Logs

- **PM2 logs**: `pm2 logs liveweb`
- **Application logs**: `/opt/liveweb/logs/app.log`
- **Error logs**: `/opt/liveweb/logs/error.log`
- **Deploy logs**: `/opt/liveweb/logs/deploy.log`

## 🔒 Security Checklist

- [ ] SSH keys configured (not passwords)
- [ ] Firewall configured (UFW/iptables)
- [ ] SSL certificate installed (for custom domain)
- [ ] Environment variables secured
- [ ] PM2 startup script configured
- [ ] Regular backups configured
- [ ] Fail2ban configured (optional)

## 🐛 Common Issues

### Port Already in Use

```bash
# Find process
sudo lsof -i :3000

# Kill process (if safe)
sudo kill -9 <PID>

# Or change port in .env
```

### Frontend Not Loading

```bash
# Rebuild frontend
cd /opt/liveweb/frontend
npm run build

# Restart backend
pm2 restart liveweb
```

### API Connection Errors

1. Check `API_BASE_URL` in `.env`
2. Verify frontend was built with correct `VITE_API_BASE_URL`
3. Check CORS configuration in `server/middleware/cors.js`

## 📞 Support

For deployment issues:
- Check PM2 logs: `pm2 logs liveweb`
- Check deployment logs: `/opt/liveweb/logs/deploy.log`
- Check Nginx logs: `/var/log/nginx/liveweb-error.log`
- Review GitHub Actions logs in repository

---

**Next Steps:**
1. Configure GitHub Secrets (see `.github/SECRETS_SETUP.md`)
2. Push to `main` branch
3. Monitor deployment in GitHub Actions
4. Verify application is running
5. Configure custom domain (optional)
