# 🔌 Port Configuration - LiveWeb

## Current Server Port Usage

Based on your Docker containers, these ports are in use:

| Port | Service | Container |
|------|---------|-----------|
| 3000 | Frontend | `latoxicatst-frontend` |
| 4000 | Backend (internal) | `latoxicatst-backend` |
| 8080 | Wrapper API | `infrastructure-wrapper_api-1` |
| 3005 | GitHub Template Deployer | `infrastructure-github_template_deployer-1` |
| 5500 | Unified Content Service | `infrastructure-unified_content_service-1` |
| 6380 | Redis | `infrastructure-redis-1` |
| 6381 | Redis (CMS) | `cms_redis_broker` |
| 5433 | Postgres | `infrastructure-postgres-1` |
| 5434 | Postgres (CMS) | `cms_postgres_db` |
| 27017 | MongoDB (internal) | `latoxicatst-mongo` |

## LiveWeb Port Configuration

**Default Port: 3001**

LiveWeb has been configured to use **port 3001** by default to avoid conflicts with `latoxicatst-frontend` which uses port 3000.

### Configuration Files Updated

All deployment files have been updated to use port 3001:

- ✅ `.github/workflows/deploy.yml` - GitHub Actions workflow
- ✅ `infrastructure/scripts/deploy.sh` - Deployment script
- ✅ `infrastructure/scripts/verify-deployment.sh` - Verification script
- ✅ `infrastructure/nginx/liveweb.conf` - Nginx production config
- ✅ `infrastructure/nginx/default.conf` - Nginx Docker config
- ✅ `docker-compose.yml` - Docker Compose config
- ✅ `Dockerfile` - Docker health check
- ✅ `server/config/index.js` - Server configuration
- ✅ `.env.example` - Environment template

### Changing the Port

If port 3001 is also in use, you can change it:

#### Option 1: GitHub Secret (Recommended)

Add `APP_PORT` secret in GitHub:
- Value: `3002` (or any available port)

#### Option 2: Environment Variable

In `.env` file on server:
```env
PORT=3002
```

#### Option 3: Update All Configs Manually

1. Update `.env` file
2. Update `infrastructure/nginx/liveweb.conf`:
   ```nginx
   upstream liveweb_backend {
       server 127.0.0.1:3002;
   }
   ```
3. Update `docker-compose.yml`:
   ```yaml
   ports:
     - "3002:3002"
   ```
4. Rebuild frontend with correct `VITE_API_BASE_URL`

### Available Ports

Based on your current setup, these ports appear to be available:
- ✅ **3001** (default for LiveWeb)
- ✅ **3002** (backup option)
- ✅ **3003** (backup option)
- ✅ **3004** (backup option)
- ✅ **3006-3009** (backup options)

### Verification

After deployment, verify the port:

```bash
# Check if LiveWeb is running on port 3001
curl http://localhost:3001/health

# Check all listening ports
sudo netstat -tulpn | grep LISTEN

# Check PM2 status
pm2 status liveweb
```

## Summary

- **LiveWeb Port**: 3001 (default)
- **No Conflicts**: Port 3001 is not used by any existing service
- **Configurable**: Can be changed via `APP_PORT` secret or `.env` file
- **All Files Updated**: All deployment configurations use port 3001
