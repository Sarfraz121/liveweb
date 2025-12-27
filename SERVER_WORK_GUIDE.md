# 🖥️ Guía de Trabajo en el Servidor

## 📍 Directorio Principal

**Cuando te conectes por SSH, debes trabajar en:**

```bash
/opt/liveweb
```

## 🚀 Conexión SSH

```bash
ssh root@93.93.116.136
# O si usas otro usuario:
ssh tu_usuario@93.93.116.136
```

## 📂 Estructura de Directorios

Una vez en `/opt/liveweb`, encontrarás:

```
/opt/liveweb/
├── server/              # Código del backend
│   ├── app.js
│   ├── routes/
│   └── ...
├── frontend/
│   └── dist/           # Frontend compilado (no editar directamente)
├── infrastructure/     # Scripts de deployment
│   ├── scripts/
│   └── nginx/
├── logs/               # Logs de la aplicación
├── .env                # Variables de entorno (configuración)
├── package.json        # Dependencias del backend
├── package-lock.json
└── server.js           # Punto de entrada del servidor
```

## 🔧 Comandos Útiles

### Navegar al directorio
```bash
cd /opt/liveweb
```

### Ver estado de la aplicación (PM2)
```bash
pm2 status
pm2 logs liveweb
pm2 monit
```

### Reiniciar la aplicación
```bash
cd /opt/liveweb
pm2 restart liveweb
```

### Ver logs
```bash
# Logs en tiempo real
pm2 logs liveweb

# Logs del archivo
tail -f /opt/liveweb/logs/app.log
tail -f /opt/liveweb/logs/error.log
```

### Editar configuración (.env)
```bash
cd /opt/liveweb
nano .env
# O
vi .env
```

### Verificar que la app está corriendo
```bash
curl http://localhost:3001/health
```

### Ver procesos en el puerto 3001
```bash
lsof -i :3001
# O
netstat -tulpn | grep 3001
```

## 📝 Tareas Comunes

### 1. Verificar el estado actual
```bash
cd /opt/liveweb
pm2 status
ls -la
cat .env
```

### 2. Reiniciar después de cambios
```bash
cd /opt/liveweb
pm2 restart liveweb
pm2 logs liveweb --lines 50
```

### 3. Instalar dependencias manualmente
```bash
cd /opt/liveweb
npm install --production
pm2 restart liveweb
```

### 4. Ejecutar script de deployment manual
```bash
cd /opt/liveweb/infrastructure/scripts
chmod +x deploy.sh
./deploy.sh
```

### 5. Verificar salud de la aplicación
```bash
curl http://localhost:3001/health
curl http://localhost:3001/api/health
```

## ⚠️ Importante

1. **NO edites** archivos en `frontend/dist/` - estos se generan automáticamente
2. **Siempre** trabaja desde `/opt/liveweb` como directorio base
3. **Reinicia** con PM2 después de cambios en `.env` o código
4. **Verifica** los logs si algo no funciona

## 🔍 Verificar Deployment

```bash
# 1. Ir al directorio
cd /opt/liveweb

# 2. Verificar estructura
ls -la

# 3. Verificar PM2
pm2 status

# 4. Verificar salud
curl http://localhost:3001/health

# 5. Ver logs recientes
pm2 logs liveweb --lines 20
```

## 📊 Monitoreo

```bash
# Ver uso de recursos
pm2 monit

# Ver información detallada
pm2 describe liveweb

# Ver estadísticas
pm2 list
```

## 🆘 Troubleshooting

### La app no inicia
```bash
cd /opt/liveweb
pm2 logs liveweb --err
cat logs/error.log
```

### Puerto ocupado
```bash
lsof -i :3001
kill -9 <PID>
pm2 restart liveweb
```

### Verificar variables de entorno
```bash
cd /opt/liveweb
cat .env
pm2 describe liveweb | grep env
```

## 🔗 Referencias Rápidas

- **Directorio de trabajo:** `/opt/liveweb`
- **Puerto:** `3001`
- **Nombre PM2:** `liveweb`
- **Logs:** `/opt/liveweb/logs/`
- **Configuración:** `/opt/liveweb/.env`
