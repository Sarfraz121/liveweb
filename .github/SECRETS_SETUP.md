# 🔐 GitHub Secrets Configuration Guide

This guide explains how to configure GitHub Secrets for automatic deployment.

## 📍 Accessing Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

## 🔑 Required Secrets

### 1. SERVER_IP
**Description:** Your production server IP address  
**Example:** `123.45.67.89`  
**Required:** ✅ Yes

### 2. SERVER_USER
**Description:** SSH username for server access  
**Example:** `root` or `ubuntu`  
**Default:** `root` (if not set)  
**Required:** ⚠️ Recommended

### 3. SERVER_SSH_KEY (Preferred)
**Description:** Private SSH key for authentication  
**Example:** 
```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
-----END RSA PRIVATE KEY-----
```
**Required:** ✅ Yes (if not using password)

**How to generate:**
```bash
ssh-keygen -t rsa -b 4096 -C "github-actions"
# Copy the private key (id_rsa) to GitHub Secrets
# Add the public key (id_rsa.pub) to server: ~/.ssh/authorized_keys
```

### 4. SERVER_PASSWORD (Alternative)
**Description:** SSH password (less secure, use SSH key if possible)  
**Example:** `your_secure_password`  
**Required:** ✅ Yes (if not using SSH key)

### 5. GEMINI_API_KEY
**Description:** Google Gemini API key  
**Get it at:** https://aistudio.google.com  
**Example:** `AIzaSy...`  
**Required:** ✅ Yes

## 🌐 Optional Secrets

### 6. API_BASE_URL
**Description:** Backend API URL (for frontend build)  
**Example:** `https://api.yourdomain.com` or `http://123.45.67.89:3001`  
**Default:** `http://SERVER_IP:3001`  
**Required:** ❌ No

### 7. DOMAIN
**Description:** Custom domain for your application  
**Example:** `liveweb.yourdomain.com`  
**Required:** ❌ No (only if using custom domain)

### 8. APP_PORT
**Description:** Port for LiveWeb backend (default: 3001)  
**Example:** `3001` or `3002`  
**Default:** `3001`  
**Note:** Port 3000 is used by `latoxicatst-frontend`, so LiveWeb uses 3001 by default  
**Required:** ❌ No

## 📋 Quick Setup Checklist

- [ ] `SERVER_IP` configured
- [ ] `SERVER_USER` configured (or using default `root`)
- [ ] `SERVER_SSH_KEY` OR `SERVER_PASSWORD` configured
- [ ] `GEMINI_API_KEY` configured
- [ ] `API_BASE_URL` configured (optional, for custom API URL)
- [ ] `DOMAIN` configured (optional, for custom domain)
- [ ] `APP_PORT` configured (optional, default 3001 to avoid conflict with latoxicatst-frontend)

## 🔒 Security Best Practices

1. **Use SSH Keys** instead of passwords when possible
2. **Rotate keys regularly** (every 90 days recommended)
3. **Limit SSH access** to specific IPs in server firewall
4. **Never commit secrets** to repository
5. **Use different keys** for different projects/environments

## 🧪 Testing Secrets

After configuring secrets, test the deployment:

1. Go to **Actions** tab in GitHub
2. Select **Deploy LiveWeb to Production** workflow
3. Click **Run workflow** → **Run workflow**
4. Monitor the workflow execution
5. Check deployment logs for any errors

## 🐛 Troubleshooting

### "SERVER_IP secret is not set"
- Verify secret name is exactly `SERVER_IP` (case-sensitive)
- Check that secret is in the correct repository

### "SSH connection failed"
- Verify server is accessible from internet
- Check firewall allows SSH (port 22)
- Verify SSH key or password is correct
- Check fail2ban is not blocking connections

### "GEMINI_API_KEY not found"
- Verify secret name is exactly `GEMINI_API_KEY`
- Check API key is valid at https://aistudio.google.com

### Port Conflicts
- **Port 3000** is used by `latoxicatst-frontend` (Docker)
- **LiveWeb** uses **port 3001** by default
- If 3001 is also in use, set `APP_PORT` secret to another port (e.g., 3002)
