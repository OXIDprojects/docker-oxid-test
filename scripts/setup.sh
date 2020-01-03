#! bin/bash
set -e
set -x

bash /var/www/oxidesales/scripts/setupOxid.sh
bash /var/www/oxidesales/scripts/setupPackage.sh
bash /var/www/oxidesales/scripts/activateModule.sh
