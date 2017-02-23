FROM payfortstart/lamp

COPY .htaccess .htaccess

RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-4.7.2.tar.gz \
        && tar -xzf wordpress.tar.gz -C /usr/src/ \
        && rm wordpress.tar.gz \
        && chown -R www-data:www-data /usr/src/wordpress

RUN tar cf - --one-file-system -C /usr/src/wordpress . | tar xf -

RUN curl -SL https://github.com/woothemes/woocommerce/archive/2.6.14.tar.gz -o woocommerce.tar.gz \
   && tar xzf woocommerce.tar.gz -C /usr/src/ \
   && rm woocommerce.tar.gz \
   && cp -r /usr/src/woocommerce-2.6.14 /var/www/html/wp-content/plugins/woocommerce \
   && chown -R www-data:www-data /var/www/html/wp-content/plugins/woocommerce

# COPY wp-config.php  wp-config.php
