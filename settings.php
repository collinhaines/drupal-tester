<?php

/**
 * @file
 * settings.php
 */

/**
 * Database settings:
 */
$databases = array(
  'default' => array(
    'default' => array(
      'database' => 'drupal',
      'username' => 'root',
      'password' => 'root',
      'host' => 'localhost',
      'port' => '3306',
      'driver' => 'mysql',
      'prefix' => '',
    ),
  ),
);

/**
 * Access control for update.php script.
 */
$update_free_access = FALSE;

/**
 * Salt for one-time login links and cancel links, form tokens, etc.
 */
$drupal_hash_salt = 'I4OetUGqkdp944JWLojR69SyvETqiA8A0kBpHL9jNBo';

/**
 * Base URL (optional).
 *
 * THIS IS REQUIRED FOR THIS CONTAINER. Otherwise, `drupalLogin` will fail.
 */
$base_url = 'http://localhost';

/**
 * PHP settings:
 */
ini_set('session.gc_probability', 1);
ini_set('session.gc_divisor', 100);
ini_set('session.gc_maxlifetime', 200000);
ini_set('session.cookie_lifetime', 2000000);

/**
 * Drupal automatically generates a unique session cookie name for each site
 * based on its full domain name. If you have multiple domains pointing at the
 * same Drupal site, you can either redirect them all to a single domain (see
 * comment in .htaccess), or uncomment the line below and specify their shared
 * base domain. Doing so assures that users remain logged in as they cross
 * between your various domains. Make sure to always start the $cookie_domain
 * with a leading dot, as per RFC 2109.
 */
$cookie_domain = '.localhost';

/**
 * Fast 404 pages:
 */
$conf['404_fast_paths_exclude'] = '/\/(?:styles)|(?:system\/files)\//';
$conf['404_fast_paths'] = '/\.(?:txt|png|gif|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i';
$conf['404_fast_html'] = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title>404 Not Found</title></head><body><h1>Not Found</h1><p>The requested URL "@path" was not found on this server.</p></body></html>';

/**
 * The default list of directories that will be ignored by Drupal's file API.
 *
 * @see file_scan_directory()
 */
$conf['file_scan_ignore_directories'] = array(
  'node_modules',
  'bower_components',
);
