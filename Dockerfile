FROM oxidesales/oxideshop-docker-php:7.1
ARG OXID=6.1
ARG DB_USER=oxid
ARG DB_PWD=oxid
ARG DB_HOST=db
ARG SHOP_LOG_LEVEL=debug
ARG SHOP_URL=https://localhsot

RUN cd /var/www &&\
    mkdir -p OXID &&\
    cd OXID &&\
    OXID_PATH=$(pwd) &&\
    echo "installing OXID version ${OXID} in path $OXID_PATH" &&\
    composer create-project --no-interaction --no-progress oxid-esales/oxideshop-project . dev-b-"${OXID}"-ce &&\
    sed -i -e "s@<dbHost>@${DB_HOST}@g; s@<dbName>@${DB_NAME}@g; s@<dbUser>@${DB_USER}@g; s@<dbPwd>@${DB_PWD}@g" source/config.inc.php &&\
    sed -i -e "s@<sShopURL>@${SHOP_URL}@g; s@sLogLevel = 'error'@sLogLevel = '${SHOP_LOG_LEVEL}'@g" source/config.inc.php &&\
    sed -i -e "s@<sShopDir>@${OXID_PATH}/source@g; s@<sCompileDir>@${OXID_PATH}/source/tmp@g" source/config.inc.php &&\
    sed -i -e "s@run_tests_for_shop: true@run_tests_for_shop: false@g" test_config.yml

#RUN sed -i -e "s@partial_module_paths: null@partial_module_paths: ${TARGET_PATH}@g" test_config.yml
