#! bin/bash
set -e
set -x

bash /var/www/oxid/scripts/setupOxid.sh
bash /var/www/oxid/scripts/setupPackage.sh
bash /var/www/oxid/scripts/activateModule.sh
