#!/bin/bash
# Script para personalizar Coolify a Qlify Platform

echo "🔄 Personalizando Coolify a Qlify Platform..."

# Función para reemplazar en archivos
replace_in_files() {
    local pattern="$1"
    local replacement="$2"
    local file_pattern="$3"
    
    find . -type f -name "$file_pattern" -not -path "./.git/*" -exec sed -i "s/$pattern/$replacement/g" {} \;
}

# 1. Reemplazar en archivos PHP
echo "📝 Actualizando archivos PHP..."
replace_in_files "Coolify" "Qlify Platform" "*.php"
replace_in_files "coolify\.io" "qlify.craetion.cl" "*.php"

# 2. Reemplazar en archivos Blade
echo "📝 Actualizando archivos Blade..."
replace_in_files "Coolify" "Qlify Platform" "*.blade.php"
replace_in_files "coolify\.io" "qlify.craetion.cl" "*.blade.php"

# 3. Reemplazar en archivos JavaScript/TypeScript
echo "📝 Actualizando archivos JS/TS..."
replace_in_files "Coolify" "Qlify Platform" "*.js"
replace_in_files "Coolify" "Qlify Platform" "*.ts"
replace_in_files "Coolify" "Qlify Platform" "*.jsx"
replace_in_files "Coolify" "Qlify Platform" "*.tsx"
replace_in_files "coolify\.io" "qlify.craetion.cl" "*.js"
replace_in_files "coolify\.io" "qlify.craetion.cl" "*.ts"

# 4. Reemplazar en archivos Vue
echo "📝 Actualizando archivos Vue..."
replace_in_files "Coolify" "Qlify Platform" "*.vue"
replace_in_files "coolify\.io" "qlify.craetion.cl" "*.vue"

# 5. Reemplazar en archivos de configuración
echo "📝 Actualizando archivos de configuración..."
replace_in_files "Coolify" "Qlify Platform" "*.json"
replace_in_files "Coolify" "Qlify Platform" "*.yml"
replace_in_files "Coolify" "Qlify Platform" "*.yaml"
replace_in_files "coolify\.io" "qlify.craetion.cl" "*.json"
replace_in_files "coolify\.io" "qlify.craetion.cl" "*.yml"
replace_in_files "coolify\.io" "qlify.craetion.cl" "*.yaml"

# 6. Actualizar package.json
echo "📝 Actualizando package.json..."
if [ -f "package.json" ]; then
    sed -i 's/"name": "coolify"/"name": "qlify-platform"/g' package.json
    sed -i 's/"description": ".*"/"description": "Multi-cloud orchestration platform"/g' package.json
fi

# 7. Actualizar composer.json
echo "📝 Actualizando composer.json..."
if [ -f "composer.json" ]; then
    sed -i 's/"name": "coollabsio\/coolify"/"name": "craetion\/qlify-platform"/g' composer.json
    sed -i 's/"description": ".*"/"description": "Multi-cloud orchestration platform"/g' composer.json
fi

# 8. Actualizar README
echo "📝 Actualizando README..."
cat > README.md << 'EOF'
# Qlify Platform

Multi-cloud orchestration platform based on Coolify.

## Features

- 🌐 Multi-cloud support (Oracle, AWS, GCP, Azure, DigitalOcean, Contabo)
- 🚀 One-click deployments
- 🔒 Built-in SSL/TLS
- 📊 Real-time monitoring
- 🎯 Auto-scaling capabilities
- 🔄 CI/CD integration
- 🏗️ Infrastructure as Code

## Installation

```bash
curl -fsSL https://qlify.craetion.cl/install.sh | bash
```

## Documentation

Visit [https://qlify.craetion.cl/docs](https://qlify.craetion.cl/docs)

## License

Based on Coolify - Apache License 2.0
EOF

# 9. Actualizar archivos Docker
echo "📝 Actualizando Dockerfiles..."
find . -name "Dockerfile*" -exec sed -i 's/coolify/qlify/g' {} \;
find . -name "docker-compose*.yml" -exec sed -i 's/coolify/qlify/g' {} \;

# 10. Actualizar archivos de entorno de ejemplo
echo "📝 Actualizando archivos .env..."
if [ -f ".env.example" ]; then
    sed -i 's/Coolify/Qlify Platform/g' .env.example
    sed -i 's/coolify\.io/qlify.craetion.cl/g' .env.example
fi

echo "✅ Personalización completada!"
echo "📊 Resumen de cambios:"
echo "  - Coolify → Qlify Platform"
echo "  - coolify.io → qlify.craetion.cl"
echo "  - Actualizado branding en todos los archivos"