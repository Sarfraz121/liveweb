#!/bin/bash

# Script para verificar el estado del servidor después del deployment
# Uso: ./verificar-servidor.sh

echo "🔍 VERIFICACIÓN DEL SERVIDOR"
echo "============================"
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar que estamos en el servidor
if [ ! -d "/opt/liveweb" ]; then
    echo -e "${RED}❌ Este script debe ejecutarse en el servidor${NC}"
    echo "   Ejecuta: ssh root@93.93.116.136"
    exit 1
fi

cd /opt/liveweb

echo "1️⃣ Docker Containers:"
echo "-------------------"
docker compose ps
echo ""

echo "2️⃣ Nginx Status:"
echo "----------------"
if systemctl is-active --quiet nginx; then
    echo -e "${GREEN}✅ Nginx está corriendo${NC}"
else
    echo -e "${RED}❌ Nginx NO está corriendo${NC}"
fi
echo ""

echo "3️⃣ Nginx Configuration:"
echo "----------------------"
if nginx -t 2>&1 | grep -q "successful"; then
    echo -e "${GREEN}✅ Configuración de Nginx válida${NC}"
    nginx -t
else
    echo -e "${RED}❌ Configuración de Nginx inválida${NC}"
    nginx -t
fi
echo ""

echo "4️⃣ Nginx Sites Enabled:"
echo "---------------------"
ls -la /etc/nginx/sites-enabled/ | grep -v "^total"
echo ""

echo "5️⃣ SSL Certificates:"
echo "------------------"
if command -v certbot &> /dev/null; then
    certbot certificates 2>/dev/null || echo -e "${YELLOW}⚠️  No se encontraron certificados SSL${NC}"
else
    echo -e "${YELLOW}⚠️  Certbot no está instalado${NC}"
fi
echo ""

echo "6️⃣ HTTP Test (liveweb.website):"
echo "------------------------------"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://liveweb.website/ 2>/dev/null)
if [ "$HTTP_STATUS" = "200" ] || [ "$HTTP_STATUS" = "301" ] || [ "$HTTP_STATUS" = "302" ]; then
    echo -e "${GREEN}✅ HTTP responde correctamente (Status: $HTTP_STATUS)${NC}"
else
    echo -e "${RED}❌ HTTP no responde correctamente (Status: $HTTP_STATUS)${NC}"
fi
echo ""

echo "7️⃣ HTTPS Test (liveweb.website):"
echo "-------------------------------"
HTTPS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://liveweb.website/ 2>/dev/null)
if [ "$HTTPS_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ HTTPS funciona correctamente (Status: $HTTPS_STATUS)${NC}"
elif [ "$HTTPS_STATUS" = "000" ]; then
    echo -e "${YELLOW}⚠️  HTTPS no está configurado aún${NC}"
else
    echo -e "${RED}❌ HTTPS tiene problemas (Status: $HTTPS_STATUS)${NC}"
fi
echo ""

echo "8️⃣ Application Health Check:"
echo "----------------------------"
HEALTH=$(curl -s http://localhost:3001/health 2>/dev/null)
if [ -n "$HEALTH" ]; then
    echo -e "${GREEN}✅ Backend responde en puerto 3001${NC}"
    echo "   Response: $HEALTH"
else
    echo -e "${RED}❌ Backend NO responde en puerto 3001${NC}"
fi
echo ""

echo "9️⃣ Recent Logs (last 10 lines):"
echo "------------------------------"
if [ -f "logs/app.log" ]; then
    tail -10 logs/app.log
else
    echo -e "${YELLOW}⚠️  No se encontraron logs${NC}"
fi
echo ""

echo "🔟 Summary:"
echo "----------"
echo ""
if systemctl is-active --quiet nginx && [ "$HTTPS_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ TODO ESTÁ FUNCIONANDO CORRECTAMENTE${NC}"
    echo ""
    echo "🌐 Tu aplicación está disponible en:"
    echo "   - https://liveweb.website/"
    echo "   - https://www.liveweb.website/"
elif systemctl is-active --quiet nginx && [ "$HTTP_STATUS" = "200" ] || [ "$HTTP_STATUS" = "301" ]; then
    echo -e "${YELLOW}⚠️  HTTP funciona pero HTTPS no está configurado${NC}"
    echo ""
    echo "📝 Para configurar SSL, ejecuta:"
    echo "   sudo ./infrastructure/scripts/setup-ssl-domain.sh liveweb.website"
else
    echo -e "${RED}❌ HAY PROBLEMAS QUE RESOLVER${NC}"
    echo ""
    echo "📝 Revisa los errores arriba y ejecuta:"
    echo "   sudo ./infrastructure/scripts/setup-nginx-proxy.sh liveweb.website"
fi
echo ""
