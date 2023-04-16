FROM alpine

ARG VERSION=1.5.4
ARG TZ="\"Europe\/Amsterdam\""

RUN apk -U update && \
    apk -U upgrade && \
    apk -U add \
        wget \
        nginx \
        php81 \
        php81-fpm \
        php81-curl \
        php81-dom \
        php81-gettext \
        php81-mbstring \
        php81-xml \
        php81-zip \
        php81-zlib \
        php81-gd \
        php81-openssl \
        php81-pdo \
        php81-pdo_mysql \
        php81-session \
        php81-simplexml \
        php81-json \
        supervisor \
        sudo

# Download a specific version of spotweb, copy it and set permissions
RUN wget https://github.com/spotweb/spotweb/archive/${VERSION}.zip -P /tmp &&\
    unzip /tmp/${VERSION}.zip -d /var/www &&\
    mv /var/www/spotweb-${VERSION} /var/www/spotweb &&\
    chown -R nobody:nobody /var/www/spotweb && \
    rm /tmp/${VERSION}.zip

# Set the timezone in the php config file
RUN sed -i "s/;date.timezone =/date.timezone = ${TZ}/g" /etc/php81/php.ini

# Copy config files to the filesystem
COPY ./conf/cron/spotweb /etc/periodic/hourly/spotweb
COPY ./conf/supervisord.conf /etc/supervisord.conf
COPY ./conf/nginx /etc/nginx
COPY ./conf/php-fpm/www.conf /etc/php81/php-fpm.d/www.conf
COPY ./conf/php-fpm/php.ini /etc/php81/conf.d/zzz_custom.ini
COPY ./conf/spotweb /var/www/spotweb
COPY ./entrypoint.sh /entrypoint.sh

# Make the cronjob executable
RUN chmod +x /etc/periodic/hourly/spotweb

# Expose volumes
VOLUME ["/config", "/nzb"]

EXPOSE 80

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
