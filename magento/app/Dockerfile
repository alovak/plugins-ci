FROM payfortstart/lamp

RUN apt-get update && apt-get install -y libmcrypt-dev php-soap libxml2-dev \
      php5-gd php5-mysql \
      && rm -rf /var/lib/apt/lists/* \
      && docker-php-ext-install -j$(nproc) soap mbstring mcrypt pdo_mysql

RUN curl -o magento.tar.gz -SL https://github.com/OpenMage/magento-mirror/archive/1.9.2.3.tar.gz \
      && tar -xzf magento.tar.gz -C /usr/src/ \
      && rm magento.tar.gz \
      && chown -R www-data:www-data /usr/src/magento-mirror-1.9.2.3

RUN tar cf - --one-file-system -C /usr/src/magento-mirror-1.9.2.3 . | tar xf -

COPY db.sql /tmp
RUN /bin/bash -c "/usr/bin/mysqld_safe &" \
  && sleep 10 \
  && mysql -u root --password= demo < /tmp/db.sql \
  && mysqladmin -uroot shutdown \
  && rm /tmp/db.sql

COPY magento-disable-alerts.xml app/etc/
COPY local.xml app/etc/
RUN chown www-data:www-data app/etc/*
