# Simple one-container Docker instance of HotCRP
# Uses instructions from https://github.com/kohler/hotcrp/blob/master/README.md

FROM ubuntu:24.04 as base
MAINTAINER Edward Wang <edward.c.wang@compdigitec.com>

RUN apt-get update && apt-get install -y wget curl git vim htop unzip

# Dependencies
RUN apt-get update && apt-get install -y nginx php-fpm php-mysql mariadb-server msmtp-mta

WORKDIR /opt

# Get HotCRP code
RUN wget -q https://github.com/kohler/hotcrp/archive/b09bb2c73e0317f02bc0955e6224309d0da8b775.zip -O hotcrp.zip
RUN unzip hotcrp.zip && rm hotcrp.zip
RUN mv hotcrp-* hotcrp

# Patch HotCRP to dump message content
# Useful for mail/SMTP debugging.
COPY mailpreparation.php.diff /opt/hotcrp/lib
RUN (cd /opt/hotcrp/lib && patch mailpreparation.php mailpreparation.php.diff)

WORKDIR /root

# Allow getenv() to work to set config via env vars.
RUN echo "clear_env = no" >> /etc/php/8.3/fpm/pool.d/www.conf

# As recommended by the HotCRP README
RUN sed -i "s/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 2628000/g" /etc/php/8.3/fpm/php.ini

# Nginx Configuration
RUN rm /etc/nginx/sites-enabled/default
COPY hotcrp.conf /etc/nginx/conf.d/hotcrp.conf

CMD ["sh", "-c", "/etc/init.d/php8.3-fpm restart ; nginx -g 'daemon off;'"]
