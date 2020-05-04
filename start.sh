#!/bin/bash

# Startup services.
nohup bash -c "service mysql start && \
  service apache2 start && \
  drush cutie --yes --profile=minimal --no-server --db-url=mysql://root:root@localhost:3306/drupal & sleep 4"

# Require the module.
composer config repositories.module path /module
composer config --global repositories.vc3 composer https://packages.web.vc3.com/7
rm -rf /module/node_modules /module/vendor
composer require $PROJECT_NAME

# Download insecure modules.
if [ ! -z "INSECURE_MODULES" ]; then
  drush pm-download --pm-force --yes $INSECURE_MODULES
fi

# Handle FPP unit test 500 error.
if [ `find . -type f -name fieldable_panels_panes.info | wc -l` -gt 0 ]; then
  echo "Fieldable Panels Panes discovered, downloading Services to prevent 500."
  drush pm-download --pm-force --yes services
fi

drush pm-enable --yes simpletest

# Assure the base_url variable is appended onto the settings.php file.
echo "\$base_url = 'http://localhost';" >> /drupal/web/sites/default/settings.php

# Clear all cache before proceeding with testing.
drush cache-clear all

mkdir -p /drupal/web/sites/default/files/results && \
  cp /container/scripts/run-tests.sh /drupal/web/scripts && \
  chown -R tester:www-data /drupal/web

COMMAND="php /drupal/web/scripts/run-tests.sh --color --url http://localhost --xml /drupal/web/sites/default/files/results \"$TEST_GROUP\""

su - tester -c "$COMMAND"
