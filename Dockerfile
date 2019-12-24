ARG PHP=7.1
FROM oxidprojects/oxid-apache-php:php$PHP
WORKDIR /var/www/oxid

COPY composer-withmetapackage.json .

ARG OXID=6.1
RUN php composer-withmetapackage.json > composer.json
RUN cat composer.json
#remove hirak/prestissimo because to try if it helps to get my testing lib fork installed
RUN composer global remove hirak/prestissimo

RUN OXID_PATH=$(pwd) &&\
    echo "installing OXID version ${OXID} in path $OXID_PATH" &&\
    composer install --no-interaction --no-progress
#remove hirak/prestissimo because it conflicts with composer patches
RUN composer global remove hirak/prestissimo
RUN cp vendor/oxid-esales/testing-library/test_config.yml.dist test_config.yml
RUN rm -r /root/.composer/cache/files/*
RUN rm -r vendor/oxid-esales/oxideshop-ce/source/out/pictures/*
RUN rm -r vendor/oxid-esales/oxideshop-demodata-ce/*
RUN rm -r source/out/pictures/*
COPY setup.sh setup.sh
COPY stubs stubs
COPY phpstan.neon phpstan.neon
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar

