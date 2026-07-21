# ============================================================
#  Dockerfile — ShopNest (PHP 8.2 + Apache)
#
#  HOW TO USE:
#  Build the image:
#    docker build -t shopnest .
#
#  Run the container (app only, no DB):
#    docker run -p 8080:80 --env-file .env shopnest
#
#  Or use docker-compose to start app + DB + phpMyAdmin together:
#    docker compose up -d
# ============================================================

# Use the official PHP 8.2 image that already has Apache built in
FROM php:8.2-apache

# -----------------------------------------------------------
# 1. SYSTEM DEPENDENCIES + PHP EXTENSIONS
#    - Install Linux libraries needed to compile PHP extensions
#    - Then install the PHP extensions themselves
#    - Finally clean up apt cache to keep the image small
# -----------------------------------------------------------
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev \
    zip unzip curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql gd zip opcache mysqli \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------
# 2. APACHE CONFIGURATION
#    - a2enmod rewrite       → enables URL rewriting (.htaccess)
#    - ServerName localhost  → suppresses Apache startup warning
#    - AllowOverride All     → lets .htaccess files work in /var/www/html
# -----------------------------------------------------------
RUN a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && sed -i 's|AllowOverride None|AllowOverride All|g' /etc/apache2/apache2.conf

# -----------------------------------------------------------
# 3. PHP CONFIGURATION
#    Copy our custom php.ini (upload limits, error settings etc.)
#    into the PHP config directory so PHP picks it up automatically
# -----------------------------------------------------------
COPY docker/php.ini /usr/local/etc/php/conf.d/shopnest.ini

# -----------------------------------------------------------
# 4. APPLICATION FILES
#    - WORKDIR sets the working directory inside the container
#    - COPY . . copies all project files into /var/www/html
#    - Then we create uploads/ and logs/ folders and give
#      the web server (www-data) permission to write to them
# -----------------------------------------------------------
WORKDIR /var/www/html
COPY . .
RUN mkdir -p uploads logs \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/uploads /var/www/html/logs

# -----------------------------------------------------------
# 5. EXPOSE PORT
#    Tell Docker this container listens on port 80 (HTTP)
#    The actual host port mapping is done at runtime:
#      docker run -p 8080:80 ...   ← maps your PC's 8080 → container's 80
# -----------------------------------------------------------
EXPOSE 80
