FROM alpine:latest

RUN mkdir -p /var/www/html/vendor \
    /var/www/html/generated \
    /var/www/html/var \
    /var/www/html/pub/static \
    /var/www/html/pub/media \
    /var/www/html/dev/tests/integration/tmp

RUN chown -R 1000:1000 /var/www/html/magento

# Keep container running until all other containers are created.
# This avoid issues when this container is started multiple times.
CMD sleep 30