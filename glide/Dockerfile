FROM fschaper/glide

RUN cd /var/www \
    && composer require twistor/flysystem-guzzle

COPY ext/index.php /var/www/html/index.php
