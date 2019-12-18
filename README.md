# docker-oxid-test
A docker conteainer for testing modules


# How to use locally
navigate to the module root directory and execute
```
docker run --rm -d -p 3306:3306 --name=gim -e  MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=oxid  mysql:5.7
docker run -d --link gim:mysql --rm --name=oxid --mount type=bind,source=$(pwd),target=/var/www/module keywanghadamioxid/oxid-test:6.2
docker exec -ti oxid bash
cd /var/www/module
bash ../OXID/setup.sh

find . -not -path "./vendor/*" -name "*.php" -print0 | xargs -0 -n1 -P8 php -l
cd /var/www/OXID
vendor/bin/phpstan analyse --configuration phpstan.neon /var/www/module
vendor/bin/phpcs --standard=PSR12 --extensions=php /var/www/module
vendor/bin/psalm.phar --show-info=false /var/www/module
vendor/bin/runtests 
```

# How to use in ci

## gitlab

image: keywanghadamioxid/oxid-test:6.2

test:static:
  script:
    - /var/www/OXID/vendor/bin/phpcs --standard=PSR12 --extensions=php --ignore="vendor/|Scripts|tests" .
    - find . -not -path "./vendor/*" -name "*.php" -print0 | xargs -0 -n1 -P8 php -l

.test_template: &test_definition
  script:
    - bash /var/www/OXID/setup.sh
    - MD=$(pwd)
    - cd /var/www/OXID
    - composer install -vvv
    - composer require oxid-professional-services/oxid-console:dev-fixRcCommand
    - vendor/bin/oxid module:activate oxps/debuguser
    - vendor/bin/oxid-dump-autoload
    #- cat autoload.oxid.php
    - vendor/bin/phpstan analyse --configuration phpstan.neon $MD
    - vendor/bin/runtests
  services:
    - mariadb:10.2.24
  after_script:
    - composer config cache-dir

test:OXID6.1:
  <<: *test_definition
  image: keywanghadamioxid/oxid-test:6.1

test:OXID6.2:
  <<: *test_definition
  allow_failure: true

variables:
  DB_HOST: 'mariadb'
  MYSQL_DATABASE: 'oxid'
  MYSQL_ROOT_PASSWORD: 'root'

