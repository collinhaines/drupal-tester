FROM ubuntu:18.04

# Handle the operating system.
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update --yes && \
  apt upgrade --yes

RUN apt install --yes curl git software-properties-common unzip

RUN add-apt-repository ppa:ondrej/php && \
  apt update --yes && \
  apt install --yes libapache2-mod-php7.2 php7.2 php7.2-curl php7.2-dom php7.2-gd php7.2-json php7.2-mbstring php7.2-mysql php7.2-xml php7.2-xmlrpc php7.2-zip && \
  sed -i 's/post_max_size = 8M/post_max_size = 100M/g' /etc/php/7.2/apache2/php.ini && \
  sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/g' /etc/php/7.2/apache2/php.ini

RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections && \
  echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections && \
  apt install mysql-server --yes && \
  chown -R mysql:mysql /var/lib/mysql* 2>/dev/null && \
  echo "<IfModule mod_dir.c>\n\tDirectoryIndex index.php index.html\n</IfModule>" > /etc/apache2/mods-enabled/dir.conf && \
  echo "<Directory /var/www/html>\n\tOptions FollowSymLinks\n\tAllowOverride All\n\tRequire all granted\n</Directory>" >> /etc/apache2/apache2.conf && \
  a2enmod rewrite && \
  sed -i 's/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=tester/g' /etc/apache2/envvars

RUN adduser --disabled-password --gecos "" tester && \
  adduser tester www-data

# Handle composer.
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php composer-setup.php && \
  php -r "unlink('composer-setup.php');" && \
  mv composer.phar /usr/bin/composer

# Handle Drupal.
WORKDIR /drupal
RUN composer create-project drupal-composer/drupal-project:7.x-dev /drupal --no-interaction && \
  rm -r /var/www/html && \
  ln -s /drupal/web /var/www/html

ENV PATH="/drupal/vendor/bin:${PATH}"

# Prepare the container.
ADD . /container
RUN chmod +x /container/start.sh

CMD ["/container/start.sh"]
