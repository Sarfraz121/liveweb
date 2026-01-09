# ⚡ Configuración Rápida de SSL/HTTPS

## 🎯 Situación Actual

- ✅ `http://liveweb.website:3001/` → Aplicación funciona (pero HTTP)
- ❌ `http://liveweb.website/` → Muestra página por defecto de nginx

**Problema:** Nginx en el host (puerto 80) no está configurado para tu dominio.

---

## 🚀 Solución Rápida (2 Pasos)

### Paso 1: Configurar Nginx Proxy (HTTP)

SSH al servidor y ejecuta:

```bash
ssh root@93.93.116.136

# Ejecutar script de proxy
cd /opt/liveweb
sudo ./infrastructure/scripts/setup-nginx-proxy.sh liveweb.website
```

Esto configurará nginx para que:
- `http://liveweb.website/` → Proxy al contenedor Docker (puerto 3001)
- Elimine la página por defecto de nginx

**Verificar:**
```bash
# Debería mostrar tu aplicación ahora
curl -I http://liveweb.website/
```

---

### Paso 2: Configurar SSL/HTTPS

Una vez que `http://liveweb.website/` funcione, configura SSL:

```bash
# Ejecutar script de SSL
sudo ./infrastructure/scripts/setup-ssl-domain.sh liveweb.website
```

Esto:
- Obtendrá certificado SSL de Let's Encrypt
- Configurará HTTPS
- Redirigirá HTTP → HTTPS

**Verificar:**
```bash
# Debería redirigir a HTTPS
curl -I http://liveweb.website/

# Debería funcionar con SSL
curl -I https://liveweb.website/
```

---

## 🎯 Resultado Final

Después de estos 2 pasos:

- ✅ `http://liveweb.website/` → Redirige a HTTPS
- ✅ `https://liveweb.website/` → Aplicación con SSL
- ✅ `https://www.liveweb.website/` → También funciona
- ✅ Micrófono habilitado (requiere HTTPS)

---

## 🔄 Alternativa: Usar GitHub Secrets

Si prefieres que el workflow lo haga automáticamente:

1. **Agrega GitHub Secret:**
   - Ve a: https://github.com/brandonqr/liveweb/settings/secrets/actions
   - Agrega: `DOMAIN` = `liveweb.website`

2. **Ejecuta el workflow:**
   - Ve a: https://github.com/brandonqr/liveweb/actions/workflows/deploy-docker.yml
   - Click en "Run workflow"
   - El workflow configurará todo automáticamente

---

## 🐛 Si Algo Falla

### Nginx sigue mostrando página por defecto

```bash
# Verificar configuración
sudo nginx -t

# Ver qué sitios están habilitados
ls -la /etc/nginx/sites-enabled/

# Debería haber un enlace a 'liveweb', no 'default'
# Si hay 'default', elimínalo:
sudo rm /etc/nginx/sites-enabled/default
sudo systemctl reload nginx
```

### Certbot falla

```bash
# Verificar que DNS está propagado
dig liveweb.website +short
# Debería mostrar: 93.93.116.136

# Si DNS está bien, ejecutar certbot manualmente
sudo certbot --nginx -d liveweb.website -d www.liveweb.website
```

---

## 📝 Comandos de Verificación

```bash
# Verificar que nginx está funcionando
sudo systemctl status nginx

# Ver logs de nginx
sudo tail -f /var/log/nginx/error.log

# Verificar configuración
sudo nginx -t

# Verificar que el proxy funciona
curl -I http://liveweb.website/

# Verificar SSL
curl -I https://liveweb.website/
```

---

**Última actualización:** $(date)
