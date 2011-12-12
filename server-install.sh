#! /bin/bash
# File : serveur.sh
# Author : Michael Thevenet
# Description : Preparation a l'installation de prestashop sur un serveur debian
# Creation : 2011-11-17
# Last Mod : 2011-11-17
# Version  : 0.2
#############################################################
#  2011-11-17  # 2011-11-17   #              #              #
#  Michael T.  # Michael M.   #              #              #
#   creation   # init/conf    #              #              #
#############################################################
# HISTORY
# 0.1
#    creation
# 0.2
#    + date, version, start/stoptime
#    + function verbose
#
#
SCRIPT_NAME="serveur.sh"
SCRIPT_VERSION="0.2"


DATE=`date` # +"%d %b %Y %H:%M:%S"`
STARTTIME=`date +%s`

path=`pwd`
. "$path/tools.sh"
. "$path/config.sh"
. "$path/init.sh"



 verbose 'Renseignement des variables nécessaires'
 echo "Adresse e-mail du Postmaster ?"
 read postmaster
 echo "Adresse IP du Master ?"
 read ipmaster
 echo 'Merci'
 echo
 M="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
 while [ "${n:=1}" -le "12" ]
 do  root="$root${M:$(($RANDOM%${#M})):1}"
   let n+=1
 done
 while [ "${o:=1}" -le "12" ]
 do  mysqlpass="$mysqlpass${M:$(($RANDOM%${#M})):1}"
   let o+=1
 done
 while [ "${p:=1}" -le "12" ]
 do  postfix="$postfix${M:$(($RANDOM%${#M})):1}"
   let p+=1 
 done
 while [ "${q:=1}" -le "12" ]
 do  pma="$pma${M:$(($RANDOM%${#M})):1}"
   let q+=1 
 done

echo "@TODO : http://stackoverflow.com/questions/1202347/how-can-i-pass-a-password-from-a-bash-script-to-aptitude-for-installing-mysql"
if (test $MODE_INTERACTIVE) then
	 echo "Mot de passe MySQL : $root"
	 echo "Mot de passe MySQLPass : $mysqlpass"
	 echo "Mot de passe postfix : $postfix"
	 	echo "Mot de passe pma : $pma"
	 echo "[Appuyez sur entree pour continuer]"
	 read
fi

if (test $INSTALL_MISSING_PACKAGE) then
	# NOTE : This should also install memcache, rewrite, deflat, etc... (for performance things)
	verbose
	verbose 'Mise à jour de apt-get ...'
	apt-get update
	apt-get upgrade
	apt-get dist-upgrade
	verbose '... Mise à jour terminée'
	verbose
	verbose 'Installation des paquets ...'
	apt-get install build-essential apache2 libapache2-mod-php5 php5-gd php5-mcrypt php-pear mysql-server php5-mysql
	if ($INSTALL_PMA) then
		apt-get install phpmyadmin
	fi
	verbose '... installation des paquets terminés'
fi
 # todo : if ($CONFIGURE_APACHE) then
 verbose
 verbose 'Paramétrage du serveur apache...'
 mkdir /var/www
 sed -i "s/webmaster@localhost/$postmaster/g" /etc/apache2/sites-enabled/000-default
 /etc/init.d/apache2 restart
 verbose '... paramétrage du serveur Apache terminé'
 # TODO : il manque le doctype (je sais c'est en construction, mais quand meme !
 # Solution alternative : un index.html déja pret
 echo '<html>' > /var/www/index.html
 echo '<head>' >> /var/www/index.html
 echo '<title>Site en contruction</title>' >> /var/www/index.html
 echo '</head>' >> /var/www/index.html
 echo '<body style="text-align:center;background:lightgrey">' >> /var/www/index.html
 echo '<a href="http://www.prestashop.com"><img src="http://img2.prestashopinc.netdna-cdn.com/images/en/logoPrestaShop.png" alt="Prestashop" border="0"/></a>' >> /var/www/index.html
 echo '<h1>Ce site est en construction, revenez bient&ocirc;t nous rendre visite</h1>' >> /var/www/index.html
 echo '</body>' >> /var/www/index.html
 echo '</html>' >> /var/www/index.html
 verbose 'Création du fichier index temporaire ...'

 verbose '... création terminée'
 verbose
 verbose 'Paramétrage Mysql...'
 echo "CREATE  USER 'prestashop'@'%' IDENTIFIED BY '$mysqlpass';" | mysql --user=root --password=$root
 echo "GRANT USAGE ON * . * TO 'prestashop'@'%' IDENTIFIED BY '$mysqlpass'" | mysql --user=root --password=$root
 echo "CREATE DATABASE IF NOT EXISTS prestashop ;" | mysql --user=root --password=$root
 echo "GRANT ALL PRIVILEGES ON prestashop . * TO 'prestashop'@'%';" | mysql --user=root --password=$root
 verbose '... paramétrage de Mysql terminé'
 echo
 verbose 'Paramétrage des e-mail ...'
apt-get install mysql-server postfix apache2 libapache2-mod-php5 courier-authlib-mysql phpmyadmin
mysqladmin -u root $root $postfix
apt-get install build-essential dpkg-dev binutils make dpatch debhelper lsb-release libdb4.3-dev
libgdbm-dev libldap2-dev libpcre3-dev libmysqlclient15-dev libssl-dev libsasl2-dev libpq-dev
libcdb-dev
cd /usr/src
apt-get source postfix
wget http://vda.sourceforge.net/VDA/postfix-2.3.8-vda.patch.gz
gunzip postfix-2.3.8-vda.patch.gz
cd postfix-2.3.8
patch –p1 < ../postfix-2.3.8-vda.patch
dpkg-buildpackage
cd ..
dpkg –i postfix_2.3.8-2_i386.deb
dpkg -i postfix-doc_2.3.8-2_all.deb
dpkg –i postfix-mysql-2.3.8-1_i386.deb
cd /usr/local/share
wget http://mesh.dl.sourceforge.net/sourceforge/postfixadmin/postfixadmin-2.1.0.tgz
tar -xzvf postfixadmin-2.1.0.tgz
rm postfixadmin-2.1.0.tgz
cd /usr/local/share/postfixadmin-2.1.0
chmod 640 *.php *.css
cd /usr/local/share/postfixadmin-2.1.0/admin/
chmod 640 *.php .ht*
cd /usr/local/share/postfixadmin-2.1.0/images/
chmod 640 *.png
cd /usr/local/share/postfixadmin-2.1.0/languages/
chmod 640 *.lang
cd /usr/local/share/postfixadmin-2.1.0/templates/
chmod 640 *.tpl
cd /usr/local/share/postfixadmin-2.1.0/users/
chmod 640 *.php
chown -R www-data:www-data /usr/local/share/postfixadmin-2.1.0
ln -s /usr/local/share/postfixadmin-2.1.0 /var/www/postfixadmin
sed -i "s/password\('postfix'\)/password('$postfix')/g" /usr/local/share/postfixadmin-2.1.0/DATABASE_MYSQL.TXT
sed -i "s/password\('postfixadmin'\)/password('$postfix')/g" /usr/local/share/postfixadmin-2.1.0/DATABASE_MYSQL.TXT
mysql --user=root --password=$root < /usr/local/share/postfixadmin-2.1.0/DATABASE_MYSQL.TXT
cd /usr/local/share/postfixadmin-2.1.0/
cp -p config.inc.php.sample config.inc.php
sed -i "s/x.x.x.x/$ipmaster/g" config.inc.php
sed -i "s/mysecretpassword/$postfix/g" config.inc.php
sed -i "s/password'\] \= 'postfixadmin'/password'] = '$postfix'/g" config.inc.php
echo "AuthUserFile /var/www/postfixadmin/admin/.htpasswd" > /usr/local/share/postfixadmin-2.1.0/admin/.htaccess
echo "AuthGroupFile /dev/null" >> /usr/local/share/postfixadmin-2.1.0/admin/.htaccess
echo "AuthName \"Postfix Admin\"" >> /usr/local/share/postfixadmin-2.1.0/admin/.htaccess
echo "AuthType Basic" >> /usr/local/share/postfixadmin-2.1.0/admin/.htaccess
echo "" >> /usr/local/share/postfixadmin-2.1.0/admin/.htaccess
echo "<limit GET POST>" >> /usr/local/share/postfixadmin-2.1.0/admin/.htaccess
echo "require valid-user" >> /usr/local/share/postfixadmin-2.1.0/admin/.htaccess
echo "</limit>" >> /usr/local/share/postfixadmin-2.1.0/admin/.htaccess
htpasswd -b /var/www/postfixadmin/admin/.htpasswd admin $postfix
echo "" >> /etc/apache2/sites-enabled/000-default
echo "<Directory /var/www/postfixadmin/admin>" >> /etc/apache2/sites-enabled/000-default
echo "  AuthUserFile /var/www/postfixadmin/admin/.htpasswd" >> /etc/apache2/sites-enabled/000-default
echo "  AuthGroupFile /dev/null" >> /etc/apache2/sites-enabled/000-default
echo "  AuthName \"Postfix Admin\"" >> /etc/apache2/sites-enabled/000-default
echo "  AuthType Basic" >> /etc/apache2/sites-enabled/000-default
echo "" >> /etc/apache2/sites-enabled/000-default
echo "<limit GET POST>" >> /etc/apache2/sites-enabled/000-default
echo "  require valid-user" >> /etc/apache2/sites-enabled/000-default
echo "</limit>" >> /etc/apache2/sites-enabled/000-default
echo "  Allowoverride All" >> /etc/apache2/sites-enabled/000-default
echo "</Directory>" >> /etc/apache2/sites-enabled/000-default
/etc/init.d/apache2 restart
mv /var/www/postfixadmin/setup.php /var/www/postfixadmin/setup.php.bak
mv /var/www/postfixadmin/motd-admin.txt /var/www/postfixadmin/motd-admin.txt.bak
groupadd -g 5000 vmail
useradd -g vmail -u 5000 vmail -d /home/vmail -s /bin/false
mkdir -p /var/mail/vmail
chown -R 5000:5000 /var/mail/vmail
chmod -R 770 /var/mail/vmail
mkdir -p /etc/postfix/mysql
touch /etc/postfix/mysql/mysql-virtual_alias.cf
touch /etc/postfix/mysql/mysql-virtual_domains.cf
touch /etc/postfix/mysql/mysql-virtual_mailboxes.cf
touch /etc/postfix/mysql/mysql-virtual_domains_relay.cf
touch /etc/postfix/mysql/mysql-virtual_limit_maps.cf
cd /etc/postfix/mysql/
echo "user = postfix
password = $postfix
hosts = localhost
dbname = postfix
query = SELECT goto FROM alias WHERE address='%s' AND active = 1" > mysql-virtual_alias.cf
echo "user = postfix
password = $postfix
hosts = localhost
dbname = postfix
#query = SELECT domain FROM domain WHERE domain='%s'
#optional query to use when relaying for backup MX
query = SELECT domain FROM domain WHERE domain='%s' and backupmx = '0' and active = '1'" > mysql-virtual_domains.cf
echo "user = postfix
password = $postfix
hosts = localhost
dbname = postfix
query = SELECT domain FROM domain WHERE domain='%s' and backupmx = '1'" > mysql-virtual_domains_relay.cf
echo "user = postfix
password = $postfix
hosts = localhost
dbname = postfix
query = SELECT quota FROM mailbox WHERE username='%s'" > mysql-virtual_limit_maps.cf
echo "user = postfix
password = $postfix
hosts = localhost
dbname = postfix
query = SELECT maildir FROM mailbox WHERE username='%s' AND active = 1" > mysql-virtual_mailboxes.cf
echo "SET PASSWORD FOR 'postfixadmin'@'localhost' = PASSWORD('$postfix')" > TEMP.txt
mysql --user=root --password=$root < TEMP.txt
rm TEMP.txt
rm -R /home/prestashop
ln -s /var/www /home/prestashop
sed -i "s/width\: 750px;/width: 100%/g" /var/www/postfixadmin/stylesheet.css
#! /bin/bash
aptitude install horde3 php5-pgsql

 ln -s /usr/share/horde3/imp /var/www/webmail
 chmod 777 /etc/horde/horde3/conf.php
 touch /etc/horde/horde3/conf.bak.php
 chmod 777 /etc/horde/horde3/conf.bak.php

 touch /var/log/horde/horde3.log
 chown root.www-data /var/log/horde/horde3.log
 chmod 770 /var/log/horde/horde3.log

gunzip < /usr/share/doc/horde3/examples/scripts/\
sql/create.mysql.sql.gz \
| mysql --user=root --password=NoQ2GXx0NFsc

sed -i "s/echo \"Horde3 / \/\/ echo \"Horde3 /g" /etc/horde/horde3/conf.php
sed -i "s/exit/\/\/ exit/g" /etc/horde/horde3/conf.php

aptitude install imp4

 chmod 777 /etc/horde/imp4/conf.php
 touch /etc/horde/imp4/conf.bak.php
 chmod 777 /etc/horde/imp4/conf.bak.php

 chmod 644 /etc/horde/imp4/conf.php
 chmod 700 /etc/horde/imp4/conf.bak.php


sed -i "s/'status' => 'inactive',/'status' => 'active',/g" /etc/horde/horde3/registry.php

verbose "Fin du script"
