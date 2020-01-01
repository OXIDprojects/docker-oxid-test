#! bin/bash
set -e
set -x

BUILD_DIR=$(pwd)
TARGET_PATH=$(grep '"target-directory":' composer.json | awk -F'"' '{print $4}')
cd /var/www/oxid
sed -i -e "s@partial_module_paths:@partial_module_paths: ${TARGET_PATH}@g" test_config.yml

if [ -z "$MODULE_NAME" ]
then
echo showing id from metadata.php:
cat $BUILD_DIR/metadata.php |grep "\s*'id'\s*="
echo module name to activate?
read MODULE_NAME
fi
#oxrun does not work on oxid 6.2 
#php oxrun.phar module:activate $MODULE_NAME
vendor/bin/oxid module:activate $MODULE_NAME
vendor/bin/oxid-dump-autoload
