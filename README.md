# Drupal 7 Simpletest Docker Container
Docker container created with intention to be used for Azure DevOps Pipelines.

## Example Usage
All `docker run` commands must have the required environment variables and the module volume linked to `/module`.

### Creation
```bash
# Run tests on the Panelizer module.
docker run -d --name simpletest -e PROJECT_NAME="drupal/panelizer" -e TEST_GROUP="Panelizer" -v /local/path/module:/module collinhaines/drupal-tester

# Run tests on the Panelizer module and use the insecure module: field_collection_table
docker run -d --name simpletest -e PROJECT_NAME="drupal/panelizer" -e TEST_GROUP="Panelizer" -e INSECURE_MODULES="field_collection_table" -v /local/path/module:/module collinhaines/drupal-tester
```

## Environment Variables
### `PROJECT_NAME` (required)
Composer project name.

### `TEST_GROUP` (required)
Test group name.

### `INSECURE_MODULES`
List of modules sent to `drush pm-download` to download. This should only be used if `composer require drupal/[module]` fails.

### `VC3_MODULES`
List of modules to download from VC3's Mission Control website.

## Common Executions
### Retrieve XML (JUnit) Results
```bash
docker cp $(image):/drupal/web/sites/default/files/results/*.xml .
```

### Retrieve HTML Verbose Results
```bash
docker cp $(image):/drupal/web/sites/default/files/simpletest/verbose/*.html .
```

## Modifications
The `run-tests.sh` file is modified to better accommodate expected JUnit elements as deemed by Azure DevOps.
