FROM php:8.0-fpm-buster
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]

# timezone environment
ENV TZ=UTC \
  # locale
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US:en \
  LC_ALL=en_US.UTF-8 \
  # composer environment
  COMPOSER_ALLOW_SUPERUSER=1 \
  COMPOSER_HOME=/composer

# composer
COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer

# basic library
RUN apt-get update \
  && apt-get -y install \
    git \
    g++ \
    libicu-dev \
    libonig-dev \
    libzip-dev \
    libmcrypt4 \
    libfreetype6-dev \
    libpng-dev \
    zlib1g-dev \
    unzip \
    locales \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen en_US.UTF-8 \
  && localedef -f UTF-8 -i en_US en_US.UTF-8 \
  && mkdir /var/run/php-fpm \
  && docker-php-ext-install \
    intl \
    pdo_mysql \
    zip \
    bcmath \
    mysqli \
  && composer config -g process-timeout 3600 \
  && composer config -g repos.packagist composer https://packagist.org

COPY ./docker/php/php-fpm.d/zzz-www.conf /usr/local/etc/php-fpm.d/zzz-www.conf
COPY ./docker/php/php.ini /usr/local/etc/php/php.ini

# xdebug

# phalcon
ARG PSR_VERSION=1.1.0
ARG PHALCON_VERSION=5.0.0alpha6
ARG PHALCON_EXT_PATH=phalcon

RUN set -xe \
  # PSR
  && curl -LO https://github.com/jbboehr/php-psr/archive/v${PSR_VERSION}.tar.gz \
  && tar xzf ${PWD}/v${PSR_VERSION}.tar.gz \
  # Phalcon
  && curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz \
  && tar xzf ${PWD}/v${PHALCON_VERSION}.tar.gz \
  && docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) \
    ${PWD}/php-psr-${PSR_VERSION} \
    ${PWD}/cphalcon-${PHALCON_VERSION}/build/${PHALCON_EXT_PATH} \
  # Delete temporary files
  && rm -r \
    ${PWD}/v${PSR_VERSION}.tar.gz \
    ${PWD}/php-psr-${PSR_VERSION} \
    ${PWD}/v${PHALCON_VERSION}.tar.gz \
    ${PWD}/cphalcon-${PHALCON_VERSION} \
  && php -m

WORKDIR /work/src
