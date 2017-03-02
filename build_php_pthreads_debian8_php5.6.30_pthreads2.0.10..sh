#Instalación de apache mysql y php con pthreads sobre debian 8 32bit

apt-get update
apt-get install -y apache2 mysql-server
apt-get install -y build-essential apache2-mpm-prefork apache2-prefork-dev libcurl4-openssl-dev libsqlite3-dev sqlite3 mysql-server libmysqlclient-dev libreadline-dev libzip-dev libxslt1-dev libicu-dev libmcrypt-dev libmhash-dev libpcre3-dev libjpeg-dev libpng12-dev libfreetype6-dev libbz2-dev libxpm-dev
apt-get -y build-dep php5

wget http://cl1.php.net/get/php-5.6.30.tar.gz/from/this/mirror -O php-5.6.30.tar.gz

tar zxvf php-5.6.30.tar.gz

rm -rf ext/pthreads/

wget http://pecl.php.net/get/pthreads-2.0.10.tgz -O pthreads-2.0.10.tgz
tar zxvf pthreads-2.0.10.tgz

cp -a pthreads-2.0.10/. php-5.6.30/ext/pthreads/

cd php-5.6.30

rm -rf aclocal.m4
rm -rf autom4te.cache/
./buildconf --force
make distclean

#--enable-debug

./configure --enable-maintainer-zts --enable-pthreads --prefix=/usr --with-config-file-path=/etc --with-curl --enable-cli --with-apxs2=/usr/bin/apxs2 \
--enable-mbstring \
    --enable-mbregex \
    --enable-phar \
    --enable-posix \
    --enable-soap \
    --enable-sockets \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-zip \
    --enable-inline-optimization \
    --enable-intl \
    --with-icu-dir=/usr \
    --with-gd \
    --with-jpeg-dir=/usr \
    --with-png-dir=shared,/usr \
    --with-xpm-dir=/usr \
    --with-freetype-dir=/usr \
    --with-bz2=/usr \
    --with-gettext \
    --with-iconv-dir=/usr \
    --with-mcrypt=/usr \
    --with-mhash \
    --with-zlib-dir=/usr \
    --with-regex=php \
    --with-pcre-regex \
    --with-openssl \
    --with-openssl-dir=/usr/bin \
    --with-mysql-sock=/var/run/mysqld/mysqld.sock \
    --with-mysqli=mysqlnd \
    --with-sqlite3=/usr \
    --with-pdo-mysql=mysqlnd \
    --with-pdo-sqlite=/usr \
	--enable-fpm \
    --with-fpm-user=www-data \
    --with-fpm-group=www-data \
	--config-cache \
    --localstatedir=/var \
    --with-layout=GNU \
    --disable-rpath
	
make clear 

make

make install
cp php.ini-development /etc/php.ini

cp /etc/apache2/mods-available/php5.load /etc/apache2/mods-enabled/php5.load
echo "<FilesMatch \.php$>
    SetHandler application/x-httpd-php
</FilesMatch>
" > /etc/apache2/mods-enabled/php5.conf

/etc/init.d/apache2 restart

cd ..

rm php-5.6.30.tar.gz
rm -rf php-5.6.30
rm -rf pthreads-2.0.10
rm pthreads-2.0.10.tgz

sed -i "s/^;date.timezone =$/date.timezone = \"America\/Santiago\"/" /etc/php.ini |grep "^timezone" /etc/php.ini


# change local-infile=1 on [mysql] and [mysqld] 
# change document root on  nano /etc/apache2/sites-enabled/000-default and restart apache


apt-get install -y ntp ntpdate

# nano /etc/ntp.conf and add server ntp.shoa.cl iburst
/etc/init.d/ntp stop 
ntpdate ntp.shoa.cl
/etc/init.d/ntp start
date  



#disable browse on apache nano nano /etc/apache2/sites-enabled/000-default remove INDEX
#disable banner 

