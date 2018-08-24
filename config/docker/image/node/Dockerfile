FROM modestcoders/node-php:node8-php7.1

RUN mkdir -p /home/app
RUN usermod -d /home/app -l app node
RUN chown -R app /home/app

USER app