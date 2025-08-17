# Multi-stage build for Qlify Platform
FROM node:20-alpine AS frontend-builder

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci --only=production

# Copy and build frontend assets
COPY . .
RUN npm run build

# PHP Application stage
FROM serversideup/php:8.3-fpm-nginx-alpine AS base

LABEL maintainer="Craetion <support@craetion.cl>"
LABEL org.opencontainers.image.title="Qlify Platform"
LABEL org.opencontainers.image.description="Multi-cloud orchestration platform"
LABEL org.opencontainers.image.vendor="Craetion"
LABEL org.opencontainers.image.source="https://github.com/craetion/qlify-platform"

# Install additional PHP extensions and tools
RUN apk add --no-cache \
    php83-bcmath \
    php83-exif \
    php83-gd \
    php83-intl \
    php83-pdo_pgsql \
    php83-redis \
    php83-zip \
    postgresql-client \
    git \
    openssh-client \
    curl \
    wget \
    nano \
    supervisor

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY --chown=www-data:www-data . .

# Copy built assets from frontend builder
COPY --from=frontend-builder --chown=www-data:www-data /app/public/build ./public/build

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Create necessary directories
RUN mkdir -p storage/app/public \
    storage/framework/cache/data \
    storage/framework/sessions \
    storage/framework/views \
    storage/logs \
    bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Optimize Laravel
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Copy custom configuration
COPY docker/nginx/site.conf /etc/nginx/sites-available/default
COPY docker/php/php.ini /usr/local/etc/php/conf.d/99-qlify.ini
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose port
EXPOSE 80 443

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Set user
USER www-data

# Start command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]