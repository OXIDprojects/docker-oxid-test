ARG PHP=7.1
FROM oxidprojects/oxid-apache-php:php$PHP
WORKDIR /var/www/oxid

COPY composer-withmetapackage.json .

ARG OXID=6.1
RUN php composer-withmetapackage.json > composer.json
RUN cat composer.json

RUN composer show -v -a oxid-esales/testing-library

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
COPY setup.sh .
COPY stubs/ stubs/
COPY scripts/ scripts/
RUN ls -al stubs
COPY phpstan.neon .
COPY psalm.xml .
COPY staticBoot.php .
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
RUN curl -OL https://github.com/OXIDprojects/oxrun/releases/download/4.1.1/oxrun.phar
RUN ls -al

