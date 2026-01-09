# 🌐 Guía: Configurar Dominio en Namecheap

## 📋 Pasos para Configurar DNS en Namecheap

### Paso 1: Acceder a Namecheap

1. Ve a: **https://www.namecheap.com**
2. Inicia sesión en tu cuenta
3. Ve a **"Domain List"** (Lista de Dominios)

### Paso 2: Seleccionar tu Dominio

1. Encuentra tu dominio en la lista
2. Click en **"Manage"** (Gestionar) al lado del dominio

### Paso 3: Configurar DNS Records

Tienes dos opciones:

---

## 🔧 Opción A: Advanced DNS (Recomendado)

### 1. Ir a Advanced DNS

- En la página de gestión del dominio, busca la sección **"Advanced DNS"**
- O ve directamente a: **"Domain" → "Advanced DNS"**

### 2. Agregar Registros A

Necesitas agregar **2 registros A**:

#### Registro 1: Dominio principal
- **Type:** `A Record`
- **Host:** `@` (o deja en blanco, o `yourdomain.com`)
- **Value:** `93.93.116.136`
- **TTL:** `Automatic` (o `600` segundos)
- Click en **"Add Record"** o el checkmark ✅

#### Registro 2: Subdominio www
- **Type:** `A Record`
- **Host:** `www`
- **Value:** `93.93.116.136`
- **TTL:** `Automatic` (o `600` segundos)
- Click en **"Add Record"** o el checkmark ✅

### 3. Eliminar Registros Existentes (si los hay)

Si ya existen registros A para `@` o `www` que apuntan a otras IPs:
- Elimínalos o edítalos para que apunten a `93.93.116.136`

### 4. Guardar Cambios

- Click en el botón **"Save All Changes"** o **"Save"**
- Los cambios pueden tardar unos minutos en aplicarse

---

## 🔧 Opción B: Namecheap BasicDNS (Si no ves Advanced DNS)

Si tu dominio usa Namecheap BasicDNS:

1. Ve a **"Domain" → "Nameservers"**
2. Cambia a **"Namecheap BasicDNS"** (si no está ya seleccionado)
3. Luego ve a **"Advanced DNS"** y sigue los pasos de la Opción A

---

## ✅ Verificación

### Verificar que DNS está configurado correctamente:

```bash
# Verificar registro A principal
dig tu-dominio.com +short
# Debería mostrar: 93.93.116.136

# Verificar registro A www
dig www.tu-dominio.com +short
# Debería mostrar: 93.93.116.136
```

O usa herramientas online:
- **https://dnschecker.org** - Ingresa tu dominio y verifica que apunte a `93.93.116.136`
- **https://www.whatsmydns.net** - Verifica propagación DNS global

---

## ⏱️ Tiempo de Propagación

- **Tiempo típico:** 15 minutos a 2 horas
- **Máximo:** Hasta 24 horas (raro)
- **Namecheap suele ser rápido:** Generalmente menos de 1 hora

---

## 📝 Ejemplo Visual de Configuración

En Namecheap Advanced DNS deberías ver algo así:

```
Type    Host    Value           TTL
A       @       93.93.116.136   Automatic
A       www     93.93.116.136   Automatic
```

---

## 🚀 Después de Configurar DNS

Una vez que el DNS esté propagado:

### Opción 1: Automático (Workflow)

1. Agrega el secret `DOMAIN` en GitHub con tu dominio
2. Ejecuta el workflow `deploy-docker.yml`
3. El workflow configurará SSL automáticamente

### Opción 2: Manual

```bash
# SSH al servidor
ssh root@93.93.116.136

# Ejecutar script de SSL
cd /opt/liveweb
sudo ./infrastructure/scripts/setup-ssl-domain.sh tu-dominio.com
```

---

## 🐛 Troubleshooting

### DNS no se propaga después de varias horas

**Solución:**
1. Verifica que los registros estén correctos en Namecheap
2. Verifica que no haya otros registros A conflictivos
3. Espera un poco más (puede tardar hasta 24 horas)
4. Contacta soporte de Namecheap si persiste

### Error: "DNS not pointing to server"

**Solución:**
```bash
# Verificar desde tu máquina
dig tu-dominio.com +short

# Si no muestra 93.93.116.136, el DNS aún no está propagado
# Espera y verifica de nuevo
```

### Certbot falla porque DNS no está listo

**Solución:**
1. Espera a que DNS se propague (verifica con `dig`)
2. Una vez que `dig tu-dominio.com +short` muestre `93.93.116.136`
3. Ejecuta el script de SSL de nuevo

---

## 📚 Recursos

- **Namecheap DNS Guide:** https://www.namecheap.com/support/knowledgebase/article.aspx/767/10/how-to-change-dns-for-a-domain/
- **Verificar DNS:** https://dnschecker.org
- **Guía SSL:** `.github/SETUP_HTTPS_DOMAIN.md`

---

**Última actualización:** $(date)
