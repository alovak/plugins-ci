FROM php:5.6-apache

RUN a2enmod rewrite expires

RUN apt-get update && apt-get -y install supervisor

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mysqli opcache

RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini


# install and configure MySQL
RUN groupadd -r mysql && useradd -r -g mysql mysql
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5

ENV MYSQL_MAJOR 5.6
ENV MYSQL_VERSION 5.6.28-1debian8

RUN echo "deb http://repo.mysql.com/apt/debian/ jessie mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list

RUN { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections \
	&& apt-get update && apt-get install -y mysql-server="${MYSQL_VERSION}" && rm -rf /var/lib/apt/lists/*

RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf \
	&& echo 'skip-host-cache\nskip-name-resolve' | awk '{ print } $1 == "[mysqld]" && c == 0 { c = 1; system("cat") }' /etc/mysql/my.cnf > /tmp/my.cnf \
	&& mv /tmp/my.cnf /etc/mysql/my.cnf

# ENV WORDPRESS_VERSION 4.4.2
# ENV WORDPRESS_SHA1 7444099fec298b599eb026e83227462bcdf312a6

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
# RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
#	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
#	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
#	&& rm wordpress.tar.gz \
#	&& chown -R www-data:www-data /usr/src/wordpress

#RUN /usr/sbin/mysqld & \
#    sleep 10s &&\
#    echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY 'changeme' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

COPY setupdb.sh /setupdb.sh
RUN chmod 755 /setupdb.sh
CMD ["/setupdb.sh"]

COPY supervisord-apache.conf /etc/supervisor/conf.d/supervisord-apache2.conf
COPY supervisord-mysql.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

CMD ["supervisord", "-n"]
