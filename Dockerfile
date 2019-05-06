ARG PHP_VERSION
FROM ubuntu:12.04
MAINTAINER codesign2@icloud.com

ENV PHP_VERSION=${PHP_VERSION}

# Install PHP extensions and PECL modules.
RUN apt-get update \
    && apt-get install -y \
       apt-utils \
       autoconf \
       bc \
       bison \
       build-essential \
       bzip2 \
       ca-certificates \
       file \
       flex \
       g++ \
       gcc \
       git \
       imagemagick \
       libaspell-dev \
       libbz2-dev \
       libc-client2007e-dev \
       libc-dev \
       libcurl4-openssl-dev \
       libfontconfig1-dev \
       libfreetype6-dev \
       libgd2-xpm-dev \
       libgpg-error-dev \
       libjpeg-dev \
       libmagickwand-dev \
       libmcrypt-dev \
       libmcrypt4 \
       libmhash-dev \
       libpng-dev \
       libpq-dev \
       libreadline6-dev \
       librecode0 \
       libsnmp-dev \
       libsqlite3-0 \
       libsqlite3-dev \
       libt1-dev \
       libxml2 \
       make \
       php5-gd \
       libphp-adodb \
       pkg-config \
       re2c \
       uuid-dev \
       vim \
       wget \
       zlib1g-dev \
       elinks \
       --no-install-recommends \
       graphicsmagick spawn-fcgi \
       && ldconfig \
       && apt-get clean \
       && rm -r /var/lib/apt/lists/*

RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html

RUN mkdir -p /tmp/install/ \
    && cd /tmp/install \
    && wget --no-check-certificate https://www.ijg.org/files/jpegsrc.v7.tar.gz \
    && tar xzf jpegsrc.v7.tar.gz \
    && cd jpeg-7 \
    && ./configure --prefix=/usr/local --enable-shared --enable-static \
    && make \
    && make install \
    # \
    && cd /tmp/install \
    && wget --no-check-certificate https://download.savannah.gnu.org/releases/freetype/freetype-2.4.0.tar.gz \
    && tar zxf freetype-2.4.0.tar.gz \
    && cd freetype-2.4.0 \
    && ./configure \
    && make \
    && make install \
    # \
    && cd /tmp/install \
    && wget --no-check-certificate https://curl.haxx.se/download/archeology/curl-7.12.0.tar.gz \
    && tar zxvf curl-7.12.0.tar.gz \
    && cd curl-7.12.0 \
    && ./configure --without-ssl \
    && make \
    && make install \
    && cd \
    && rm -rf /tmp/install

COPY php-4.4.9-fpm-0.5.10.diff /tmp/patch-php-fpm.diff
RUN mkdir -p /tmp/install/ \
    && cd /tmp/install \
    && wget --no-check-certificate https://museum.php.net/php4/php-4.4.9.tar.bz2 \
    && tar xfj php-4.4.9.tar.bz2 \
    && cd php-4.4.9 \
    && cp /usr/lib/x86_64-linux-gnu/libpng* /usr/lib/ \
    && cd /tmp/install/php-4.4.9 \
    && patch -p1 < /tmp/patch-php-fpm.diff \
    && mkdir -p /etc/php4/fpm/conf.d \
    && ./configure \
        --with-tsm-pthreads \
        --enable-maintainer-zts \
        --enable-debug \
        --disable-rpath \
        --enable-bcmath \
        --enable-ctype \
        --enable-exif \
        --enable-fastcgi \
        --enable-ftp \
        --enable-gd-native-ttf \
        --enable-inline-optimization \
        --enable-intl \
        --enable-mbregex \
        --enable-mbstring \
        --enable-pcntl \
        --enable-soap  \
        --enable-sockets \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-zip \
        --enable-fpm \
        --with-fpm-conf=/etc/php4/fpm/php-fpm.conf \
        --with-bz2 \
        --with-config-file-path=/etc/php4 \
        --with-config-file-path=/etc \
        --with-config-file-scan-dir=/etc/php4/conf.d \
        --with-curl \
        --with-gettext \
        --with-iconv \
        --with-libdir=lib/x86_64-linux-gnu \
        --with-libxml-dir=/usr \
        --with-mcrypt \
        --with-mhash \
        --with-mysql \
        --with-mysqli \
        --with-pcre-regex \
        --with-pdo-mysql \
        --with-pgsql \
        --without-snmp \
        --with-t1lib=/usr \
        --with-tidy \
        --with-gd \
        --with-png-dir=/usr \
        --with-jpeg-dir=/usr \
        --with-freetype-dir=shared,/usr \
        --with-zlib \
        --with-zlib-dir=/usr \
        --with-xsl \
    && make \
    && make install \
    && rm -rf /tmp/install \
    && mkdir -p /var/lib/php/session \
    && chown -R www-data:www-data /var/lib/php/ \
    && cp -ar /etc/php5/fpm/pool.d /etc/php4/fpm/pool.d

# Create config directory
RUN mkdir -p /etc/php4/conf.d/ \
    # Set location and timestamp \
    && echo 'date.timezone = "Europe/London"' > /etc/php4/conf.d/10_timezone.ini
    # \

COPY php.ini /etc/php4/php.ini
COPY php.ini /etc/php4/fpm/php.ini
COPY docker-php-ext-* /usr/local/bin/
WORKDIR /var/www/html
