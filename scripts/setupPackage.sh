#! bin/bash
set -e
set -x
BUILD_DIR=$(pwd)
PACKAGE_NAME=$(composer config name)
cd /var/www/oxideshop
#this file is generated for modules only
#generating a empty one to avoid errors when using packages that are no oxid modules
touch autoload.oxid.php
composer config repositories.build path "${BUILD_DIR}"

#just in case the module has private repository dependencies clone that config
#into the oxid project
php -r "
\$orgComposerJson=json_decode(file_get_contents('$BUILD_DIR/composer.json'),true);
\$reUse['repositories'] = \$orgComposerJson['repositories'] ? \$orgComposerJson['repositories'] : [];
\$reUse['config'] = \$orgComposerJson['config'] ? \$orgComposerJson['config'] : [];
\$reUse['require-dev'] = \$orgComposerJson['require-dev'] ? \$orgComposerJson['require-dev'] : [];
\$c=json_decode(file_get_contents('composer.json'), true);
\$c=array_replace_recursive(\$c, \$reUse);
file_put_contents('composer.json', json_encode(\$c, JSON_PRETTY_PRINT));
//print json_encode(\$c, JSON_PRETTY_PRINT);
"

VERSION="0.0.0-alpha$(( ( RANDOM % 100000 )  + 1 ))"
composer --working-dir=$BUILD_DIR config version $VERSION
echo "installing ${PACKAGE_NAME} in ${TARGET_PATH}"
composer require "${PACKAGE_NAME}:$VERSION"
composer --working-dir=$BUILD_DIR config version --unset
