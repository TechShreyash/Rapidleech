# Use a base image with PHP 7.4 and commonly used extensions
FROM php:7.4-apache
COPY ports.conf /etc/apache2/ports.conf
# Install necessary system dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        unzip \
        wget \
        libxml2-dev \
        libcurl4-openssl-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libicu-dev \
        libonig-dev && \
    docker-php-ext-configure gd --with-jpeg --with-freetype && \
    docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mysqli \
        soap \
        intl \
        gd \
        opcache \
        mbstring && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Enable Apache modules and restart Apache
RUN a2enmod rewrite && \
    service apache2 restart

# Download and install Rapidleech
RUN mkdir -p /var/www/html && \
    cd /var/www/html && \
    git clone https://github.com/TechShreyash/Rapidleech-Docker . && \
    mkdir files && \
    chmod 777 files && \
    chmod 777 configs && \
    chmod 777 configs/files.lst

# Download and install RAR
RUN cd /var/www/html && \
    rm -rf rar && \
    wget https://rarlab.com/rar/rarlinux-x64-612.tar.gz && \
    tar -xvf rarlinux-x64-612.tar.gz && \
    rm -f rarlinux-x64-612.tar.gz && \
    chmod -R 777 rar

# Expose Apache port
EXPOSE 80

# Start Apache in foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
