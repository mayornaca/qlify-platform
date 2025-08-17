#!/bin/bash
# Script para remover secretos hardcodeados del c\u00f3digo

echo "🔒 Limpiando secretos del c\u00f3digo..."

# Reemplazar claves privadas SSH por placeholders
find . -type f -name "*.php" -exec sed -i 's/-----BEGIN.*PRIVATE KEY-----.*-----END.*PRIVATE KEY-----/PLACEHOLDER_PRIVATE_KEY/g' {} \;

# Reemplazar en archivos específicos
sed -i 's/-----BEGIN OPENSSH PRIVATE KEY-----[^-]*-----END OPENSSH PRIVATE KEY-----/PLACEHOLDER_SSH_KEY/g' \
    app/Livewire/Boarding/Index.php \
    database/seeders/PrivateKeySeeder.php \
    database/seeders/ProductionSeeder.php

# Reemplazar claves en blade templates
find resources/views -name "*.blade.php" -exec sed -i 's/-----BEGIN.*PRIVATE KEY-----.*-----END.*PRIVATE KEY-----/{{ env("DEFAULT_PRIVATE_KEY", "PLACEHOLDER") }}/g' {} \;

echo "✅ Secretos removidos"