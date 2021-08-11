FROM debian:stretch

LABEL maintainer="Vitalii"

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PERFORMANCE_OPTIM false

RUN apt-get -qq update > /dev/null && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    apt-utils \
    supervisor \
    ca-certificates \
    nginx \
    wget \
    nano \
    vim \
    git \
    curl \
    openssl \
    make \
    unzip \
    apt-transport-https > /dev/null && \
    apt-get clean
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN openssl req \
      -newkey rsa:4096 -nodes -sha256 -keyout server.key \
      -x509 -days 365 -out server.crt \
      -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=example.com"
RUN  mv /server.crt /etc/ssl/private/server.crt
RUN  mv /server.key /etc/ssl/private/server.key

RUN cd ~
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh && \
    chmod +x ./nodesource_setup.sh && \
    sh ./nodesource_setup.sh && \
    apt-get install -y --no-install-recommends nodejs

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list && \
    apt-get update -qq > /dev/null && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    php7.4 \
    php7.4-cli \
    php7.4-intl \
    php7.4-fpm \
    php7.4-xdebug \
    php7.4-xml \
    php7.4-gd \
    php7.4-mysql \
    phpunit \
    php7.4-mbstring \
    php7.4-curl > /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    php -r "readfile('https://getcomposer.org/installer');" | php -- \
        --install-dir=/usr/local/bin \
        --filename=composer && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    mkdir -p /run/php

RUN update-alternatives --set php /usr/bin/php7.4

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');"

RUN mv composer.phar /usr/local/bin/composer

RUN  wget https://get.symfony.com/cli/installer -O - | bash
RUN  mv /root/.symfony/bin/symfony /usr/local/bin/symfony

COPY docker/rootfs /

WORKDIR /var/www

EXPOSE 80

CMD ["/entrypoint.sh"]
