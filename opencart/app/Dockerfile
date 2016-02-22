FROM payfortstart/lamp

RUN apt-get update && apt-get install -y \
      php5-gd \
      php5-mysql \
      libmcrypt-dev \
      && rm -rf /var/lib/apt/lists/* \
      && docker-php-ext-install -j$(nproc) pdo_mysql zip mcrypt

RUN curl -o opencart.tar.gz -SL https://github.com/opencart/opencart/archive/2.1.0.2.tar.gz \
      && tar -xzf opencart.tar.gz -C /usr/src/ \
      && rm opencart.tar.gz \
      && chown -R www-data:www-data /usr/src/opencart-2.1.0.2

RUN tar cf - --one-file-system -C /usr/src/opencart-2.1.0.2/upload . | tar xf -
RUN cp ./config-dist.php ./config.php
RUN cp ./admin/config-dist.php ./admin/config.php
COPY cnf/config.php ./config.php
COPY cnf/admin-config.php ./admin/config.php
RUN chown www-data:www-data ./config.php ./admin/config.php

COPY db.sql /tmp
RUN /bin/bash -c "/usr/bin/mysqld_safe &" \
  && sleep 10 \
  && mysql -u root --password= demo < /tmp/db.sql \
  && mysqladmin -uroot shutdown \
  && rm /tmp/db.sql
