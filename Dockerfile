# Use the official PHP image with Apache
FROM php:7.4-apache

# Install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y language-pack-en-base && \
    apt-get install -y software-properties-common && \
    export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y unzip && \
    apt-get install -y php7.4 && \
    apt-get install -y php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl && \
    apt-get install -y wget && \
    service apache2 restart

# Clone Rapidleech repository
RUN cd /var/www && \
    rm -rf html && \
    git clone https://github.com/PBhadoo/Rapidleech html && \
    cd /var/www/html && \
    mkdir files && \
    chmod 777 files && \
    chmod 777 configs && \
    chmod 777 configs/files.lst && \
    rm -rf rar && \
    wget https://rarlab.com/rar/rarlinux-x64-612.tar.gz && \
    tar -xvf rarlinux-x64-612.tar.gz && \
    rm -f rarlinux-x64-612.tar.gz && \
    chmod -R 777 rar && chmod -R 777 rar/*

# Install and configure Certbot
RUN apt-get install -y snapd && \
    snap install core && snap refresh core && \
    snap install --classic certbot && \
    ln -s /snap/bin/certbot /usr/bin/certbot && \
    certbot --apache

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
