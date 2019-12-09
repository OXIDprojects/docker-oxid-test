# docker-oxid-test
A docker conteainer for testing modules


# How to use locally
navigate to the module root directory and execute
```
docker run --rm -d -p 3306:3306 --name=gim -e  MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -d --link gim:db --rm --name=oxid --mount type=bind,source=$(pwd),target=/var/www/module keywanghadamioxid/oxid-test:6.2
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

