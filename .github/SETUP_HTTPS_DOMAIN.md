# 🔒 Guía: Configurar HTTPS con Dominio Personalizado

## 🎯 Objetivo

Configurar HTTPS para que el micrófono funcione en el navegador (los navegadores requieren HTTPS para acceder al micrófono por seguridad).

---

## 📋 Requisitos Previos

1. **Dominio configurado** apuntando al servidor:
   ```
   A record: tu-dominio.com → 93.93.116.136
   A record: www.tu-dominio.com → 93.93.116.136
   ```

2. **Puerto 80 y 443 abiertos** en el firewall del servidor

3. **DNS propagado** (puede tardar hasta 24 horas, pero usualmente es más rápido)

---

## 🚀 Opción 1: Automático (Recomendado)

### Paso 1: Configurar GitHub Secret

1. Ve a: **https://github.com/brandonqr/liveweb/settings/secrets/actions**
2. Agrega o edita el secret: **`DOMAIN`**
3. Valor: `tu-dominio.com` (sin http/https, sin www)
4. Guarda el secret

### Paso 2: Ejecutar Deployment

El workflow ahora detectará el `DOMAIN` y configurará SSL automáticamente:

1. Ve a: **https://github.com/brandonqr/liveweb/actions/workflows/deploy-docker.yml**
2. Click en **"Run workflow"**
3. Selecciona branch: `main`
4. Click en **"Run workflow"**

El workflow:
- ✅ Configurará nginx en el host
- ✅ Intentará obtener certificado SSL con certbot
- ⚠️ Si certbot falla (por DNS no propagado), puedes ejecutarlo manualmente después

---

## 🚀 Opción 2: Manual (Si prefieres control total)

### Paso 1: SSH al Servidor

```bash
ssh root@93.93.116.136
```

### Paso 2: Ejecutar Script de SSL

```bash
cd /opt/liveweb
chmod +x infrastructure/scripts/setup-ssl-domain.sh
sudo ./infrastructure/scripts/setup-ssl-domain.sh tu-dominio.com
```

El script:
1. Instala nginx y certbot si no están instalados
2. Configura nginx para proxy al contenedor Docker
3. Obtiene certificado SSL de Let's Encrypt
4. Configura redirección HTTP → HTTPS

### Paso 3: Verificar

```bash
# Verificar SSL
curl -I https://tu-dominio.com

# Verificar que nginx está funcionando
sudo systemctl status nginx

# Ver logs si hay problemas
sudo tail -f /var/log/nginx/liveweb-error.log
```

---

## 🔍 Verificación Post-Setup

### 1. Verificar DNS

```bash
# Verificar que el dominio apunta al servidor
dig tu-dominio.com +short
# Debería mostrar: 93.93.116.136
```

### 2. Verificar SSL

```bash
# Verificar certificado
curl -I https://tu-dominio.com

# O usar navegador
# Abre: https://tu-dominio.com
# Deberías ver el candado verde 🔒
```

### 3. Verificar Micrófono

1. Abre: **https://tu-dominio.com**
2. Click en el botón de micrófono
3. El navegador debería pedir permiso (no dar error)
4. ✅ El micrófono debería funcionar ahora

---

## 🐛 Troubleshooting

### Error: "DNS not pointing to server"

**Solución:**
1. Verifica que los registros DNS estén correctos
2. Espera a que se propague (puede tardar hasta 24 horas)
3. Verifica con: `dig tu-dominio.com +short`

### Error: "Port 80 not accessible"

**Solución:**
```bash
# Verificar que el puerto 80 esté abierto
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload

# O si usas iptables directamente
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```

### Error: "Certbot failed"

**Solución:**
```bash
# Ejecutar certbot manualmente
sudo certbot --nginx -d tu-dominio.com -d www.tu-dominio.com

# Si sigue fallando, verifica:
# 1. DNS está propagado
# 2. Puerto 80 es accesible desde internet
# 3. No hay otro nginx corriendo en el puerto 80
```

### Nginx en Docker vs Nginx en Host

**Importante:** 
- Nginx en el **host** (puerto 80/443) → SSL/HTTPS
- Nginx en **Docker** (puerto 80 del contenedor) → Solo proxy interno

El setup configura nginx en el **host** para manejar SSL y redirigir al contenedor Docker.

---

## 📝 Configuración Actual

### Arquitectura con SSL:

```
Internet
   ↓
Nginx (Host) - Puerto 80/443 - SSL/HTTPS
   ↓ (proxy)
Docker Container (liveweb-backend) - Puerto 3001
   ├── API: /api/*
   └── Frontend: /* (archivos estáticos)
```

### Archivos Importantes:

- `/etc/nginx/sites-available/liveweb` - Configuración de nginx en host
- `/etc/letsencrypt/live/tu-dominio.com/` - Certificados SSL
- `/opt/liveweb/infrastructure/nginx/liveweb-docker.conf` - Template de configuración

---

## 🔄 Renovación Automática de SSL

Let's Encrypt certificados expiran cada 90 días. Certbot configura renovación automática:

```bash
# Verificar renovación automática
sudo systemctl status certbot.timer

# Renovar manualmente (si es necesario)
sudo certbot renew
```

---

## ✅ Checklist Final

- [ ] DNS apunta al servidor (verificado con `dig`)
- [ ] Puertos 80 y 443 abiertos en firewall
- [ ] Nginx instalado y configurado en el host
- [ ] Certificado SSL obtenido (verificado con `curl -I https://tu-dominio.com`)
- [ ] HTTP redirige a HTTPS
- [ ] Aplicación accesible en `https://tu-dominio.com`
- [ ] Micrófono funciona (sin errores de permisos)

---

## 🎯 Resultado Esperado

Después de configurar SSL:

- ✅ **HTTPS funcionando:** `https://tu-dominio.com`
- ✅ **HTTP redirige a HTTPS:** `http://tu-dominio.com` → `https://tu-dominio.com`
- ✅ **Micrófono funciona:** El navegador permite acceso al micrófono
- ✅ **Certificado válido:** Candado verde en el navegador 🔒

---

**Última actualización:** $(date)
