ARG PHP=7.1
FROM oxidprojects/oxid-apache-php:php$PHP
WORKDIR /var/www/oxideshop

COPY composer-withmetapackage.json .

ARG OXID=6.1
RUN php composer-withmetapackage.json > composer.json
RUN cat composer.json

RUN composer show -v -a oxid-esales/testing-library
RUN umask 0000
RUN OXID_PATH=$(pwd) &&\
    echo "installing OXID version ${OXID} in path $OXID_PATH" &&\
    composer create-project --prefer-dist --no-interaction --no-progress
RUN composer show -v oxid-esales/testing-library
RUN ls -al vendor/bin
#remove hirak/prestissimo because it conflicts with composer patches
RUN composer global remove hirak/prestissimo
RUN cp vendor/oxid-esales/testing-library/test_config.yml.dist test_config.yml
RUN rm -r /root/.composer/cache/files/*
RUN rm -r vendor/oxid-esales/oxideshop-ce/source/out/pictures/*
RUN rm -r vendor/oxid-esales/oxideshop-demodata-ce/*
RUN rm -r source/out/pictures/*
COPY stubs/ stubs/
COPY scripts/ scripts/
RUN ls -al stubs
COPY phpstan-baseline.neon .
COPY phpstan.neon .
COPY psalm.xml .
COPY staticBoot.php .
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
RUN curl -OL https://github.com/OXIDprojects/oxrun/releases/download/4.1.1/oxrun.phar
RUN curl -OL http://codeception.com/codecept.phar
RUN if [ "$PHP" = "7.1" ]; then phpunit=7; else phpunit=8; fi
RUN echo https://phar.phpunit.de/phpunit-${phpunit}.phar
RUN curl -Lo phpunit https://phar.phpunit.de/phpunit-${phpunit}.phar
RUN chmod +x codecept.phar phpunit oxrun.phar phpcs.phar
RUN ls -al

