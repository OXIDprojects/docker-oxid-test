FROM oxidesales/oxideshop-docker-php:7.1
ARG OXID=6.1

RUN cd /var/www &&\
    mkdir -p OXID &&\
    cd OXID &&\
    OXID_PATH=$(pwd) &&\
    echo "installing OXID version ${OXID} in path $OXID_PATH" &&\
    composer create-project --no-interaction --no-progress oxid-esales/oxideshop-project . dev-b-"${OXID}"-ce

RUN composer require "psalm/phar:^3.7" "phpstan/phpstan:0.12" "phpmd/phpmd:@beta" --dev
RUN rm -r /root/.composer/cache/files/*
RUN rm -r /var/www/OXID/vendor/oxid-esales/oxideshop-ce/source/out/pictures/*
RUN rm -r /var/www/OXID/vendor/oxid-esales/oxideshop-demodata-ce/*
RUN rm -r /var/www/OXID/source/out/pictures/*
ADD setup.sh /var/www/OXID/setup.sh
