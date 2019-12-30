#! bin/bash
set -e
set -x
DB_HOST=${DB_HOST:-mysql}
DB_NAME=${DB_NAME:-oxid}
DB_USER=${DB_USER:-root}
DB_PWD=${DB_PWD:-root}
SHOP_URL=${SHOP_URL:-http://127.0.0.1}
SHOP_LOG_LEVEL=${SHOP_LOG_LEVEL:-info}

PACKAGE_NAME=$(composer config name)

BUILD_DIR=$(pwd)
TARGET_PATH=$(grep '"target-directory":' composer.json | awk -F'"' '{print $4}')


cd /var/www/oxid
OXID_PATH=$(pwd)
sed -i -e "s@<dbHost>@${DB_HOST}@g; s@<dbName>@${DB_NAME}@g; s@<dbUser>@${DB_USER}@g; s@<dbPwd>@${DB_PWD}@g" source/config.inc.php
sed -i -e "s@<sShopURL>@${SHOP_URL}@g; s@sLogLevel = 'error'@sLogLevel = '${SHOP_LOG_LEVEL}'@g" source/config.inc.php
sed -i -e "s@<sShopDir>@${OXID_PATH}/source@g; s@<sCompileDir>@${OXID_PATH}/source/tmp@g" source/config.inc.php
sed -i -e "s@partial_module_paths:@partial_module_paths: ${TARGET_PATH}@g" test_config.yml
sed -i -e "s@run_tests_for_shop: true@run_tests_for_shop: false@g" test_config.yml
#cat test_config.yml
echo loading DB
CLEAN_DB_HOST=${DB_HOST/;*/}
echo clean host: $CLEAN_DB_HOST
mysql -u $DB_USER -p$DB_PWD -h $CLEAN_DB_HOST -e "create database if not exists $DB_NAME" 
mysql -u $DB_USER -p$DB_PWD -h $CLEAN_DB_HOST $DB_NAME < vendor/oxid-esales/oxideshop-ce/source/Setup/Sql/database_schema.sql
mysql -u $DB_USER -p$DB_PWD -h $CLEAN_DB_HOST $DB_NAME < vendor/oxid-esales/oxideshop-ce/source/Setup/Sql/initial_data.sql
vendor/bin/oe-eshop-db_migrate migrations:migrate
vendor/bin/oe-eshop-db_views_generate
