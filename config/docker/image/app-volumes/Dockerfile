FROM alpine:latest

RUN mkdir -p /var/www/html && chown -R 1000:1000 /var/www/html

# Keep container running until all other containers are created.
# This avoid issues when this container is started multiple times.
CMD sleep 30