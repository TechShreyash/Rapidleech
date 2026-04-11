FROM php:8.3-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    wget \
    ffmpeg \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    libicu-dev \
    libpng-dev \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install \
    curl \
    mbstring \
    xml \
    zip \
    bcmath \
    intl \
    gd \
    opcache

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Enable AllowOverride for .htaccess
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Configure PHP settings
RUN echo "memory_limit = 1024M" >> /usr/local/etc/php/conf.d/rapidleech.ini && \
    echo "upload_max_filesize = 10240M" >> /usr/local/etc/php/conf.d/rapidleech.ini && \
    echo "post_max_size = 10240M" >> /usr/local/etc/php/conf.d/rapidleech.ini && \
    echo "max_execution_time = 0" >> /usr/local/etc/php/conf.d/rapidleech.ini && \
    echo "max_input_time = 0" >> /usr/local/etc/php/conf.d/rapidleech.ini

# Install yt-dlp
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && \
    chmod a+rx /usr/local/bin/yt-dlp

# Install Deno
RUN curl -fsSL https://deno.land/install.sh | sh && \
    cp /root/.deno/bin/deno /usr/local/bin/deno && \
    chmod a+rx /usr/local/bin/deno && \
    rm -rf /root/.deno

# Create app directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html/

# Install RAR/unrar and place in application rar/ directory as script expects
RUN rm -rf /var/www/html/rar && \
    mkdir -p /var/www/html/rar && \
    cd /tmp && \
    wget -q https://www.rarlab.com/rar/rarlinux-x64-720.tar.gz && \
    tar -xf rarlinux-x64-720.tar.gz && \
    cp -r rar/* /var/www/html/rar/ && \
    chmod -R 777 /var/www/html/rar && \
    chmod +x /var/www/html/rar/rar /var/www/html/rar/unrar && \
    rm -rf /tmp/rar*

# Copy entrypoint script to fix volume permissions on startup
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set correct permissions to allow downloads (for native directories)
RUN mkdir -p /var/www/html/files && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 777 /var/www/html/files /var/www/html/configs

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
