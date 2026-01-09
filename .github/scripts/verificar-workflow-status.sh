#!/bin/bash

# Script para verificar el estado del workflow y del servidor
# Uso: ./verificar-workflow-status.sh

echo "🔍 VERIFICACIÓN DEL WORKFLOW Y SERVIDOR"
echo "======================================="
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 PASO 1: Verificar GitHub Actions${NC}"
echo "----------------------------------------"
echo ""
echo "1. Ve a: https://github.com/brandonqr/liveweb/actions"
echo "2. Busca el workflow 'Deploy LiveWeb with Docker'"
echo "3. Revisa la ejecución más reciente:"
echo "   - ✅ Verde = Exitoso"
echo "   - ❌ Rojo = Falló"
echo "   - 🟡 Amarillo = En progreso"
echo ""
echo "Si hay un error, haz click en el job que falló y revisa los logs."
echo ""

read -p "¿El workflow está completo? (s/n): " workflow_ok
if [ "$workflow_ok" != "s" ] && [ "$workflow_ok" != "S" ]; then
    echo -e "${YELLOW}⚠️  Revisa el workflow en GitHub Actions primero${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}📋 PASO 2: Verificar Servidor${NC}"
echo "----------------------------------------"
echo ""
echo "Ejecuta estos comandos en el servidor:"
echo ""
echo "ssh root@93.93.116.136"
echo "cd /opt/liveweb"
echo "./infrastructure/scripts/verificar-servidor.sh"
echo ""
echo "O ejecuta manualmente:"
echo ""

cat << 'EOF'
# Verificar contenedores
docker compose ps

# Verificar nginx
sudo systemctl status nginx
sudo nginx -t

# Verificar SSL
sudo certbot certificates

# Verificar HTTP
curl -I http://liveweb.website/

# Verificar HTTPS
curl -I https://liveweb.website/
EOF

echo ""
echo -e "${BLUE}📋 PASO 3: Verificar desde tu máquina local${NC}"
echo "----------------------------------------"
echo ""
echo "Ejecuta estos comandos:"
echo ""

cat << 'EOF'
# Verificar DNS
dig liveweb.website +short
# Debería mostrar: 93.93.116.136

# Verificar HTTP (debería redirigir a HTTPS)
curl -I http://liveweb.website/

# Verificar HTTPS
curl -I https://liveweb.website/

# Verificar en navegador
# Abre: https://liveweb.website/
EOF

echo ""
echo -e "${BLUE}📋 PASO 4: Checklist Final${NC}"
echo "----------------------------------------"
echo ""
echo "Verifica que:"
echo "  [ ] Workflow completó exitosamente"
echo "  [ ] Contenedores Docker están corriendo"
echo "  [ ] Nginx está corriendo y configurado"
echo "  [ ] SSL certificado está instalado"
echo "  [ ] http://liveweb.website/ redirige a HTTPS"
echo "  [ ] https://liveweb.website/ carga la aplicación"
echo "  [ ] Micrófono funciona (requiere HTTPS)"
echo ""

echo -e "${GREEN}✅ Si todo está marcado, ¡tu aplicación está lista!${NC}"
echo ""
