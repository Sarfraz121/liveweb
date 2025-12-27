# 🚀 Setup Inicial del Servidor - Crear Directorio LiveWeb

## ⚠️ Problema Detectado

El directorio `/opt/liveweb` no existe en el servidor. Esto significa que el deployment aún no se ha ejecutado.

## 🔧 Solución: Crear el Directorio Manualmente

### Opción 1: Desde la Terminal SSH (Recomendado)

Conéctate al servidor y ejecuta:

```bash
# Crear el directorio principal
sudo mkdir -p /opt/liveweb

# Crear subdirectorios necesarios
sudo mkdir -p /opt/liveweb/{server,frontend/dist,infrastructure,logs}

# Dar permisos correctos
sudo chown -R root:root /opt/liveweb
sudo chmod -R 755 /opt/liveweb

# Verificar
ls -la /opt/liveweb
```

### Opción 2: Ejecutar el Workflow de Deployment

1. Ve a: https://github.com/brandonqr/liveweb/actions/workflows/deploy-simple.yml
2. Click en **"Run workflow"**
3. Selecciona branch: `main`
4. Click en **"Run workflow"**

El workflow creará automáticamente los directorios.

## 📋 Verificación

Después de crear los directorios, verifica:

```bash
cd /opt/liveweb
ls -la
```

Deberías ver:
```
drwxr-xr-x  root root  server/
drwxr-xr-x  root root  frontend/
drwxr-xr-x  root root  infrastructure/
drwxr-xr-x  root root  logs/
```

## 🎯 Próximos Pasos

Una vez creado el directorio:

1. **Ejecutar el workflow de deployment** desde GitHub Actions
2. **O copiar archivos manualmente** (ver sección siguiente)

## 📦 Copia Manual de Archivos (Si el workflow falla)

Si necesitas copiar archivos manualmente:

```bash
# Desde tu máquina local
cd /Users/brandonqr/Desktop/DEV/liveweb

# Copiar archivos al servidor
scp -r server package.json package-lock.json server.js root@93.93.116.136:/opt/liveweb/

# Copiar frontend (después de build)
cd frontend
npm run build
cd ..
scp -r frontend/dist/* root@93.93.116.136:/opt/liveweb/frontend/dist/

# Copiar infrastructure
scp -r infrastructure root@93.93.116.136:/opt/liveweb/
```

## ✅ Checklist

- [ ] Directorio `/opt/liveweb` creado
- [ ] Subdirectorios creados (server, frontend/dist, infrastructure, logs)
- [ ] Permisos configurados
- [ ] Workflow de deployment ejecutado
- [ ] Archivos copiados al servidor
- [ ] `.env` creado con las variables necesarias
- [ ] Aplicación iniciada con PM2
