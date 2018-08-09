FROM alpine:latest

RUN mkdir -p /var/www/html/vendor \
    /var/www/html/generated \
    /var/www/html/var \
    /var/www/html/pub/static \
    /var/www/html/pub/media

RUN chown -R 1000:1000 /var/www/html/vendor \
    /var/www/html/generated \
    /var/www/html/var \
    /var/www/html/pub/static \
    /var/www/html/pub/media