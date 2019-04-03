# Drupal 7 Simpletest Docker Container
Docker container created with intention to be used for Azure DevOps Pipelines.

## Example Usage
Do note that due to `drupal-tester-start` final startup time may take up to 30 seconds _after_ the Docker container is up and running. This time will vary based on allocated resources and modules needing to download and/or enable.

### Creation
```bash
# Create a basic container.
docker run -d --name simpletest collinhaines/drupal-tester

# Create a container with the entity and views module downloaded.
docker run -d --name simpletest -e modules=entity,views collinhaines/drupal-tester

# Create a container with the entity and views module downloaded and enabled.
docker run -d --name simpletest -e enable=entity,views collinhaines/drupal-tester

# Create a container with your local module within the site structure.
docker run -d --name simpletest -v /path/to/my_module:/var/www/html/sites/all/modules/my_module collinhaines/drupal-tester
```

#### Windows OS Volume Reminder
Using the `--volume` option on `docker run` may only copy the main folder of your local module. To circumvent this execute `docker cp` followed by `docker exec simpletest drush cc all` to assure the test files are found within simpletest.

## Environment Variables
### `enable`
Comma-separated list of modules to enable on install. Defaults to `simpletest`.

This is passed to the `--enable` option for [drush core-quick-drupal](https://drushcommands.com/drush-8x/core/core-quick-drupal/)

**ProTip:** The `simpletest` module is REQUIRED for this container to work to its full potential, regardless of other modules enabled.

### `modules`
Comma-separated list of modules to download. Defaults to none.

This is passed to the `projects` argument for [drush core-quick-drupal](https://drushcommands.com/drush-8x/core/core-quick-drupal/).

## Server Scripts
### `drupal-simpletest`
Executes `php scripts/run-tests.sh` with the `--color`, `--verbose`, and `--xml /var/www/html/results` options alongside the given group.

### `drupal-simpletest-listing`
Executes `php scripts/run-tests.sh --list`. This is helpful due to `--php` needing to be passed outside the docker container.

## Common Executions
### Retrieve XML (JUnit) Results
```bash
docker cp $(image):/var/www/html/results/*.xml .
```

### Retrieve HTML Verbose Results
```bash
docker cp $(image):/var/www/html/sites/default/files/simpletest/verbose/*.html .
```

## Modifications
The `run-tests.sh` file is modified to better accommodate expected JUnit elements as deemed by Azure DevOps.
