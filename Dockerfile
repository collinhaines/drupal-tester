FROM ubuntu:18.04

ENV DEBIAN_FRONTEND="noninteractive"
ENV DRUPAL_VERSION="7.67"
ENV DRUPAL_MD5="78b1814e55fdaf40e753fd523d059f8d"
ENV DRUSH_VERSION="8.3.0"

RUN apt update --yes
RUN apt install --yes curl software-properties-common unzip
RUN apt install --yes sendmail
RUN add-apt-repository ppa:ondrej/php
RUN apt install --yes php7.1 php7.1-curl php7.1-gd php7.1-json php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-xml php7.1-xmlrpc php7.1-zip
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections && \
  echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections && \
  apt-get install mysql-server --yes

# Drupal.
WORKDIR /var/www/html

# Ref: https://github.com/docker-library/drupal/blob/master/7/apache/Dockerfile
RUN curl -fSL https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz -o drupal.tar.gz && \
  echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - && \
  tar --extract --gunzip --strip-components=1 --file=drupal.tar.gz && \
  rm drupal.tar.gz index.html && \
  mkdir /var/www/html/results && \
  chown -R www-data:www-data /var/www/html

# Drush.
RUN curl -fSL https://github.com/drush-ops/drush/releases/download/${DRUSH_VERSION}/drush.phar -o /usr/local/bin/drush

# Custom scripts and files.
COPY drupal /etc/init.d/
COPY drupal-simpletest drupal-simpletest-listing drupal-tester-start /usr/local/bin/
COPY run-tests.sh /var/www/html/scripts
COPY settings.php /var/www/html/sites/default

RUN chmod +x /usr/local/bin/*

EXPOSE 80

CMD drupal-tester-start
