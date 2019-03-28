#!/bin/bash

php scripts/run-tests.sh --color --verbose --url http://localhost:8080 --xml /var/www/html/results "$1"
