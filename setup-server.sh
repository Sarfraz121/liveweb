#!/bin/bash
# Script para crear el directorio liveweb en el servidor

echo "🚀 Creando directorio /opt/liveweb en el servidor..."
echo ""
echo "Ejecuta estos comandos en el servidor (SSH):"
echo ""
echo "sudo mkdir -p /opt/liveweb/{server,frontend/dist,infrastructure,logs}"
echo "sudo chown -R root:root /opt/liveweb"
echo "sudo chmod -R 755 /opt/liveweb"
echo "ls -la /opt/liveweb"
echo ""
echo "O ejecuta el workflow de deployment desde GitHub Actions:"
echo "https://github.com/brandonqr/liveweb/actions/workflows/deploy-simple.yml"
