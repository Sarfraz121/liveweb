# 🔍 Verificar Estado de Workflows

## 📋 Situación Actual

Tienes dos ejecuciones del workflow "Deploy LiveWeb with Docker":
- ✅ Una se completó exitosamente
- ❌ Una falló

---

## 🎯 Cómo Verificar en GitHub

1. **Ve a GitHub Actions:**
   - https://github.com/brandonqr/liveweb/actions

2. **Busca el workflow "Deploy LiveWeb with Docker"**

3. **Revisa las ejecuciones:**
   - Click en cada ejecución para ver detalles
   - El que falló mostrará un ❌ rojo
   - El que funcionó mostrará un ✅ verde

4. **Revisa los logs del que falló:**
   - Click en el job que falló (probablemente "Deploy to Server")
   - Click en el step que falló
   - Revisa los logs para ver el error específico

---

## 🔍 Errores Comunes y Soluciones

### Error 1: Certbot falló (SSL setup)

**Síntomas:**
```
⚠️  SSL setup may need manual intervention
```

**Causa:** DNS no propagado o puerto 80 bloqueado

**Solución:**
```bash
# Verificar DNS
dig liveweb.website +short

# Si DNS está bien, ejecutar manualmente:
ssh root@93.93.116.136
cd /opt/liveweb
sudo ./infrastructure/scripts/setup-ssl-domain.sh liveweb.website
```

---

### Error 2: Nginx proxy setup falló

**Síntomas:**
```
⚠️  Nginx proxy setup failed
```

**Causa:** Nginx no se instaló correctamente o configuración inválida

**Solución:**
```bash
ssh root@93.93.116.136
cd /opt/liveweb
sudo ./infrastructure/scripts/setup-nginx-proxy.sh liveweb.website
```

---

### Error 3: Docker compose falló

**Síntomas:**
```
Error: docker compose up failed
```

**Causa:** Contenedores no se iniciaron correctamente

**Solución:**
```bash
ssh root@93.93.116.136
cd /opt/liveweb
docker compose ps
docker compose logs
```

---

### Error 4: SSH connection failed

**Síntomas:**
```
Error: Connection refused
```

**Causa:** Credenciales incorrectas o servidor inaccesible

**Solución:**
- Verificar GitHub Secrets: `SERVER_IP`, `SERVER_USER`, `SERVER_PASSWORD`
- Verificar que el servidor esté accesible desde internet

---

## ✅ Verificar Estado Actual del Servidor

Ejecuta estos comandos para verificar qué está funcionando:

```bash
ssh root@93.93.116.136

# Verificar contenedores
cd /opt/liveweb
docker compose ps

# Verificar nginx
sudo systemctl status nginx
sudo nginx -t

# Verificar SSL
sudo certbot certificates

# Verificar que la aplicación funciona
curl -I http://liveweb.website/
curl -I https://liveweb.website/
```

---

## 🎯 Qué Verificar Ahora

1. **¿El workflow exitoso configuró nginx?**
   ```bash
   curl -I http://liveweb.website/
   # Si muestra tu aplicación (no nginx por defecto) → ✅
   ```

2. **¿El workflow exitoso configuró SSL?**
   ```bash
   curl -I https://liveweb.website/
   # Si funciona con HTTPS → ✅
   ```

3. **¿Qué error específico tuvo el workflow que falló?**
   - Revisa los logs en GitHub Actions
   - Busca líneas que digan "Error", "Failed", "❌"

---

## 📝 Reporte de Estado

Después de verificar, puedes reportar:

- [ ] ¿Qué workflow falló? (número de ejecución o commit SHA)
- [ ] ¿En qué step falló? (Build, Deploy, Nginx, SSL)
- [ ] ¿Cuál fue el mensaje de error exacto?
- [ ] ¿El workflow exitoso configuró todo correctamente?

---

## 🚀 Próximos Pasos

Si el workflow exitoso configuró todo:
- ✅ No necesitas hacer nada más
- ✅ Verifica que `https://liveweb.website/` funcione

Si el workflow exitoso NO configuró SSL:
- Ejecuta manualmente: `sudo ./infrastructure/scripts/setup-ssl-domain.sh liveweb.website`

Si ambos workflows fallaron:
- Revisa los logs específicos
- Ejecuta los scripts manualmente en el servidor

---

**Última actualización:** $(date)
