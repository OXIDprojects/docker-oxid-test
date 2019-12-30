#! bin/bash
set -e
set -x

cd /var/www/oxid
bash scripts/setupOxid.sh
bash scripts/setupPackage.sh
bash scripts/activateModule.sh
