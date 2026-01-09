# 🚀 Ejecutar Deployment con SSL Automático

## ✅ Estado Actual

- ✅ GitHub Secret `DOMAIN` configurado
- ✅ Workflow configurado para usar el secret
- ✅ Scripts de nginx y SSL listos

---

## 🎯 Opción 1: Ejecutar Workflow Manualmente (Recomendado)

1. **Ve a GitHub Actions:**
   - https://github.com/brandonqr/liveweb/actions/workflows/deploy-docker.yml

2. **Click en "Run workflow"** (botón en la parte superior derecha)

3. **Selecciona la rama `main`** y click en "Run workflow"

4. **El workflow hará automáticamente:**
   - ✅ Construirá la imagen Docker
   - ✅ La subirá a GitHub Container Registry
   - ✅ Desplegará en el servidor
   - ✅ Configurará nginx proxy (HTTP)
   - ✅ Configurará SSL/HTTPS (si DNS está listo)

---

## 🎯 Opción 2: Hacer Push a Main

Si tienes cambios pendientes, simplemente haz push:

```bash
git add .
git commit -m "trigger deployment"
git push origin main
```

El workflow se ejecutará automáticamente al detectar el push.

---

## ⚠️ Importante: Verificar DNS Antes

**Antes de ejecutar el workflow**, verifica que el DNS esté propagado:

```bash
# Verificar que el dominio apunta al servidor
dig liveweb.website +short
# Debería mostrar: 93.93.116.136

# O desde el navegador:
# http://liveweb.website → Debería mostrar algo (aunque sea nginx por defecto)
```

Si el DNS no está propagado, Certbot fallará al obtener el certificado SSL.

---

## 📋 Qué Hace el Workflow

1. **Build & Push:**
   - Construye la imagen Docker
   - La sube a `ghcr.io/brandonqr/liveweb:latest`

2. **Deploy:**
   - Copia `docker-compose.yml` y `infrastructure/` al servidor
   - Hace pull de la imagen
   - Inicia los contenedores

3. **Nginx Proxy (si DOMAIN está configurado):**
   - Instala nginx en el host (si no está)
   - Ejecuta `setup-nginx-proxy.sh`
   - Configura proxy HTTP al puerto 3001

4. **SSL/HTTPS (si DOMAIN está configurado):**
   - Instala certbot (si no está)
   - Ejecuta `setup-ssl-domain.sh`
   - Obtiene certificado SSL de Let's Encrypt
   - Configura redirección HTTP → HTTPS

---

## 🔍 Verificar Resultado

Después de que el workflow termine:

```bash
# Verificar HTTP (debería redirigir a HTTPS)
curl -I http://liveweb.website/

# Verificar HTTPS
curl -I https://liveweb.website/

# Verificar que la aplicación carga
# Abre en navegador: https://liveweb.website/
```

---

## 🐛 Si Certbot Falla

Si el workflow falla en el paso de SSL, puede ser porque:

1. **DNS no propagado:** Espera 5-10 minutos y vuelve a ejecutar
2. **Puerto 80 bloqueado:** Verifica firewall
3. **Dominio ya configurado:** Ejecuta manualmente en el servidor

**Solución manual:**
```bash
ssh root@93.93.116.136
cd /opt/liveweb
sudo ./infrastructure/scripts/setup-ssl-domain.sh liveweb.website
```

---

## ✅ Checklist Pre-Deployment

- [ ] DNS configurado y propagado (verificar con `dig`)
- [ ] GitHub Secret `DOMAIN` configurado
- [ ] GitHub Secrets `SERVER_IP`, `SERVER_USER`, `SERVER_PASSWORD` configurados
- [ ] GitHub Secret `GEMINI_API_KEY` configurado
- [ ] Puertos 80 y 443 abiertos en el firewall del servidor

---

**Última actualización:** $(date)
