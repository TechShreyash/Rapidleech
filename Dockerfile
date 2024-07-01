# Use a base image with Apache and PHP 7.4
FROM php:7.4-apache

# Install necessary system dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        unzip \
        wget \
        software-properties-common \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set locale to avoid potential issues
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

# Add PHP repository for PHP 7.4 (if needed)
RUN apt-get update && \
    apt-get install -y \
        php7.4-common \
        php7.4-mysql \
        php7.4-xml \
        php7.4-xmlrpc \
        php7.4-curl \
        php7.4-gd \
        php7.4-imagick \
        php7.4-cli \
        php7.4-dev \
        php7.4-imap \
        php7.4-mbstring \
        php7.4-opcache \
        php7.4-soap \
        php7.4-zip \
        php7.4-intl \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Enable Apache modules and restart Apache
RUN a2enmod rewrite && \
    service apache2 restart

# Download and install Rapidleech
RUN mkdir -p /var/www/html && \
    cd /var/www/html && \
    git clone https://github.com/PBhadoo/Rapidleech . && \
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
