FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ARG USER_ID
ENV UID=$USER_ID

ARG GROUP_ID
ENV GID=$GROUP_ID

RUN apt update && \
    apt -y upgrade && \
    apt install -y \
    software-properties-common apt-transport-https && \
    add-apt-repository ppa:ondrej/php && \
    apt update && \
    apt install -y \
    xz-utils \
    libxrender1 \
    php7.4-apcu \
    php7.4-common \
    php7.4-cli \
    php7.4-curl \
    php7.4-fpm \
    php7.4-gd \
    php7.4-intl \
    php7.4-json \
    php7.4-mbstring \
    php7.4-pgsql \
    php7.4-opcache \
    php7.4-zip \
    php7.4-bcmath \
    php7.4-xml \
    curl \
    git \
    zip \
    sqlite3 \
    netcat \
    wget

RUN addgroup  --force-badname --gid $GROUP_ID $USER_ID

RUN adduser  --force-badname --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID $USER_ID

RUN usermod -s /bin/bash $USER_ID

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    chmod +x /usr/local/bin/composer

COPY fpm-pool.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY php.ini /etc/php/7.4/fpm/conf.d/custom_php.ini
RUN touch /var/log/php7.4-fpm.log && chown $USER_ID:$GROUP_ID /var/log/php7.4-fpm.log

RUN sed -i "s=/var/log/php7.4-fpm.log=/proc/self/fd/2=g" /etc/php/7.4/fpm/php-fpm.conf
RUN sed -i "s=__USER_ID__=${UID}=gm" /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i "s=__GROUP_ID__=${GID}=gm" /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir -p /run/php/ /var/www/.composer/
RUN chown $USER_ID:$GROUP_ID -R /run/php/ /var/www
RUN rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

USER $USER_ID
