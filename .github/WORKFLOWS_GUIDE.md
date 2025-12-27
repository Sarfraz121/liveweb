# 🔄 GitHub Actions Workflows Guide

## Available Workflows

### 1. CI Workflow (`ci.yml`)
**Trigger:** Automatic on push/PR to main/master  
**Purpose:** Build and test the application  
**Status:** ✅ Working

**What it does:**
- Installs dependencies
- Runs linter (optional)
- Runs tests (optional)
- Builds frontend

### 2. Deploy to Production (`deploy-simple.yml`)
**Trigger:** Manual (workflow_dispatch)  
**Purpose:** Deploy to production server  
**Status:** ✅ Ready to use

**What it does:**
- Builds frontend
- Copies files to server via SSH
- Installs dependencies
- Starts application with PM2
- Performs health check

### 3. Deploy LiveWeb to Production (`deploy.yml`)
**Trigger:** Automatic on push to main/master  
**Purpose:** Full CI/CD pipeline  
**Status:** ⚠️ Needs secrets configuration

**What it does:**
- Runs full build and test
- Deploys to server automatically
- Comprehensive error handling

## 🚀 How to Use

### Manual Deployment (Recommended for First Deploy)

1. **Configure GitHub Secrets first** (see `.github/SECRETS_SETUP.md`)
   - `SERVER_IP`
   - `SERVER_USER`
   - `SERVER_PASSWORD`
   - `GEMINI_API_KEY`

2. **Trigger deployment:**
   - Go to: https://github.com/brandonqr/liveweb/actions
   - Select "Deploy to Production"
   - Click "Run workflow"
   - Select branch: `main`
   - Click "Run workflow"

3. **Monitor deployment:**
   - Watch the workflow execution
   - Check logs for any errors
   - Verify health check passes

### Automatic Deployment

Once secrets are configured, the `deploy.yml` workflow will:
- Trigger automatically on push to `main`
- Run CI tests first
- Deploy if tests pass

## 📋 Required GitHub Secrets

| Secret | Description | Required |
|--------|-------------|----------|
| `SERVER_IP` | Server IP address | ✅ Yes |
| `SERVER_USER` | SSH username | ⚠️ Default: root |
| `SERVER_PASSWORD` | SSH password | ✅ Yes |
| `GEMINI_API_KEY` | Gemini API key | ✅ Yes |
| `API_BASE_URL` | API URL | ❌ Optional |
| `APP_PORT` | Backend port | ❌ Default: 3001 |
| `DOMAIN` | Custom domain | ❌ Optional |

## 🔧 Troubleshooting

### Workflow Not Appearing

If you don't see "Deploy to Production" in Actions:
1. Ensure the workflow file is in `main` branch
2. Refresh the Actions page
3. Check workflow syntax is valid

### SSH Connection Failed

1. Verify `SERVER_IP` is correct
2. Verify `SERVER_USER` and `SERVER_PASSWORD` are correct
3. Check server firewall allows SSH (port 22)
4. Verify server is accessible from internet

### Deployment Failed

1. Check workflow logs in GitHub Actions
2. Verify all secrets are configured
3. Check server has Node.js 22+ installed
4. Verify port 3001 is available on server

## 📝 Next Steps

1. ✅ Configure GitHub Secrets
2. ✅ Run "Deploy to Production" workflow manually
3. ✅ Verify application is running
4. ✅ Test the deployed application
5. ✅ Configure automatic deployments (optional)

## 🔗 Quick Links

- [Configure Secrets](https://github.com/brandonqr/liveweb/settings/secrets/actions)
- [Run Workflows](https://github.com/brandonqr/liveweb/actions)
- [View Workflow Runs](https://github.com/brandonqr/liveweb/actions/workflows/deploy-simple.yml)
