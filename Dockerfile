FROM alpine

ARG VERSION=1.5.4
ARG TZ="\"Europe\/Amsterdam\""

RUN apk -U update && \
    apk -U upgrade && \
    apk -U add \
        wget \
        nginx \
        php7 \
        php7-fpm \
        php7-curl \
        php7-dom \
        php7-gettext \
        php7-mbstring \
        php7-xml \
        php7-zip \
        php7-zlib \
        php7-gd \
        php7-openssl \
        php7-pdo \
        php7-pdo_mysql \
        php7-session \
        php7-simplexml \
        php7-json \
        supervisor \
        sudo

# Download a specific version of spotweb, copy it and set permissions
RUN wget https://github.com/spotweb/spotweb/archive/${VERSION}.zip -P /tmp &&\
    unzip /tmp/${VERSION}.zip -d /var/www &&\
    mv /var/www/spotweb-${VERSION} /var/www/spotweb &&\
    chown -R nobody:nobody /var/www/spotweb && \
    rm /tmp/${VERSION}.zip

# Set the timezone in the php config file
RUN sed -i "s/;date.timezone =/date.timezone = ${TZ}/g" /etc/php7/php.ini

# Copy config files to the filesystem
COPY ./conf/cron/spotweb /etc/periodic/hourly/spotweb
COPY ./conf/supervisord.conf /etc/supervisord.conf
COPY ./conf/nginx /etc/nginx
COPY ./conf/php-fpm/www.conf /etc/php7/php-fpm.d/www.conf
COPY ./conf/php-fpm/php.ini /etc/php7/conf.d/zzz_custom.ini
COPY ./conf/spotweb /var/www/spotweb
COPY ./entrypoint.sh /entrypoint.sh

# Make the cronjob executable
RUN chmod +x /etc/periodic/hourly/spotweb

# Expose volumes
VOLUME ["/config", "/nzb"]

EXPOSE 80

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
