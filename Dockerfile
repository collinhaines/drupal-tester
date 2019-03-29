FROM ubuntu:18.04

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update --yes
RUN apt install --yes curl software-properties-common sqlite3 unzip
RUN add-apt-repository ppa:ondrej/php
RUN apt install --yes php7.1 php7.1-curl php7.1-gd php7.1-json php7.1-mbstring php7.1-mcrypt php7.1-sqlite3 php7.1-xml php7.1-xmlrpc php7.1-zip

# Drupal.
WORKDIR /var/www/html

# Ref: https://github.com/docker-library/drupal/blob/master/7/apache/Dockerfile
ENV DRUPAL_VERSION 7.65
ENV DRUPAL_MD5 d453c23413627594f3f05c984e339706

RUN curl -fSL https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz -o drupal.tar.gz && \
  echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - && \
  tar -xz --strip-components=1 -f drupal.tar.gz  && \
  rm drupal.tar.gz index.html && \
  chown -R www-data:www-data sites modules themes && \
  mkdir /var/www/html/results

# Composer.
RUN curl -fSL https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer

# Drush.
WORKDIR /opt

RUN composer require drush/drush:8.2.2 && \
  ln -s /opt/vendor/drush/drush/drush /usr/local/bin/drush

# Custom scripts.
COPY list.sh /var/www/html/list.sh
COPY test.sh /var/www/html/test.sh

WORKDIR /var/www/html
RUN chmod +x list.sh test.sh

EXPOSE 8080

CMD drush cutie --yes --use-existing --server=:8080 --enable=simpletest
