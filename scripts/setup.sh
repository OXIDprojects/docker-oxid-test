#! bin/bash
set -e
set -x

bash /var/www/oxideshop/scripts/setupOxid.sh
bash /var/www/oxideshop/scripts/setupPackage.sh
bash /var/www/oxideshop/scripts/activateModule.sh
