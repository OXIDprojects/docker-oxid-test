FROM oxidesales/oxideshop-docker-php:7.1
ARG OXID=6.1

RUN cd /var/www &&\
    mkdir -p OXID &&\
    cd OXID &&\
    OXID_PATH=$(pwd) &&\
    echo "installing OXID version ${OXID} in path $OXID_PATH" &&\
    composer create-project --no-interaction --no-progress oxid-esales/oxideshop-project . dev-b-"${OXID}"-ce

ADD setup.sh /var/www/OXID/setup.sh
