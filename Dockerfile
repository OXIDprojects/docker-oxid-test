FROM oxidesales/oxideshop-docker-php:7.1
ARG OXID=6.1
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN cd /var/www &&\
    mkdir -p OXID &&\
    cd OXID &&\
    OXID_PATH=$(pwd) &&\
    echo "installing OXID version ${OXID} in path $OXID_PATH" &&\
    composer create-project --no-interaction --no-progress oxid-esales/oxideshop-project . dev-b-"${OXID}"-ce
WORKDIR "/var/www/OXID"
RUN composer require "cweagans/composer-patches:^1.6.7" "alfredbez/oxid-dump-autoload:^0.1.0" "psalm/phar:^3.7" "phpstan/phpstan:0.12" "phpmd/phpmd:@beta" "squizlabs/php_codesniffer:>=2.3.1 <4.0" --dev
RUN composer config extra.enable-patching true
RUN cat composer.json
RUN rm -r /root/.composer/cache/files/*
RUN rm -r vendor/oxid-esales/oxideshop-ce/source/out/pictures/*
RUN rm -r vendor/oxid-esales/oxideshop-demodata-ce/*
RUN rm -r source/out/pictures/*
COPY setup.sh /var/www/OXID/setup.sh
COPY stubs /var/www/OXID/stubs
COPY phpstan.neon /var/www/OXID/phpstan.neon
