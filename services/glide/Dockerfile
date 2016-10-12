FROM fschaper/glide

RUN cd /var/www \
    && docker-php-ext-install exif \
    && docker-php-ext-install mbstring \
    && composer require twistor/flysystem-guzzle

COPY ext/index.php /var/www/html/index.php
