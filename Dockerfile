ARG PHP_VERSION
FROM php:${PHP_VERSION}
MAINTAINER codesign2@icloud.com

ENV PHP_VERSION=${PHP_VERSION}
# Install PHP extensions and PECL modules.
RUN buildDeps=" \
        default-libmysqlclient-dev \
        libbz2-dev \
        libsasl2-dev \
        libcurl4-gnutls-dev \
	libzip-dev \
    " \
    runtimeDeps=" \
        curl \
        git \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
    " \
    && 	pecl update-channels; \
	rm -rf /tmp/pear ~/.pearrc \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    && docker-php-ext-install \
        bcmath \
        bz2 \
        calendar \
        iconv \
        intl \
        mbstring \
        mysqli \
        opcache \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-install exif \
    && pecl install redis \
    && docker-php-ext-enable redis.so \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /var/lib/apt/lists/*

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer
ENV PATH $PATH:/root/composer/vendor/bin
