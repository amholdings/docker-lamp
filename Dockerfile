FROM centos:centos7
MAINTAINER Mehul Bhatt <mehulsbhatt@hotmail.com> <https://mehulbhatt.com> <@mehulbhatt>
RUN yum -y update
RUN yum -y install epel-release
RUN rpm -Uvh http://repo.openfusion.net/centos7-x86_64/openfusion-release-0.7-1.of.el7.noarch.rpm
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN sed -i "/\[remi-php56\]/,/\[.*\]/s/enabled=.*/enabled=1/" /etc/yum.repos.d/remi.repo
RUN yum -y install php php-cli php-fpm php-common php-devel
RUN yum -y update --enablerepo=remi,remi-php56 php\*
RUN yum -y install --enablerepo=remi,remi-php56 gd-last
RUN yum -y install --enablerepo=remi,remi-php56 libgdata libvpx-devel
RUN yum -y install --enablerepo=remi,remi-php56 ImageMagick-last ImageMagick-last-libs
RUN yum -y install --enablerepo=remi,remi-php56 php-mysql php-pgsql php-odbc php-pdo php-curl php-mcrypt php-imap php-mbstring php-recode php-ldap php-xml php-xmlrpc php-bcmath php-soap php-process php-posix php-pspell php-snmp php-php-gettext php-doctrine-annotations php-embedded php-gliph php-imap php-jsonlint php-tidy php-tcpdf php-ZendFramework-Db-Adapter-Pdo-Mysql php-intl php-theseer-fDOMDocumen
RUN yum -y install --enablerepo=remi,remi-php56 php-pear php-pear-DB php-pear-MDB2 php-pear-MDB2-Driver-mysql php-pear-MDB2-Driver-pgsql php-pear-XML-RPC php-pear-XML-RPC2 php-pear-XML-Parser php-pear-XML-Beautifier php-pear-XML-Serializer php-pear-Date php-pear-SOAP php-pear-Net-IPv4 php-pear-Net-Ping php-pear-Net-DNS php-pear-Net-Ping php-pear-Net-Socket php-pear-Net-Traceroute php-pear-Net-FTP php-pear-Mail php-pear-Mail-Mime php-pear-Mail-mimeDecode php-pear-Net-IMAP php-pear-Net-POP3 php-pear-Net-Curl php-pear-Log php-pear-Event-Dispatcher php-pear-File-Fstab php-pear-File-Passwd php-pear-HTML-Table php-pear-Text-Password php-pear-Image-GraphViz
RUN yum -y install --enablerepo=remi,remi-php56 php-pecl-mongo php-pecl-sqlite php-pecl-ssh2 php-pecl-geoip php-pecl-jsonc php-pecl-jsonc-devel php-pecl-apc php-pecl-memcache php-pecl-lua php-pecl-ncurses php-pecl-sphinx php-pecl-pthreads php-pecl-xslcache php-pecl-rrd php-pecl-uploadprogress php-pecl-uuid php-pecl-crypto php-pecl-rar php-pecl-lzf php-pecl-http php-pecl-redis php-pecl-radius php-pecl-event php-pecl-xdebug php-pecl-stats php-pecl-imagick
RUN yum -y install --enablerepo=remi,remi-php56 php-ioncube-loader php-opcache
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php.ini 
RUN RUN sed -i 's/post_max_size = 8M/post_max_size = 256M/' /etc/php.ini
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 512M /' /etc/php.ini 
RUN sed -i 's/memory_limit = 128M/memory_limit = 1024M/' /etc/php.ini
RUN sed -i 's/post_max_size = 8M/post_max_size = 256M/' /etc/php.ini
RUN sed -i 's/display_errors = Off/display_errors = on/g'  /etc/php.ini
RUN sed -i 's/max_input_time = 60/max_input_time = 600/g'  /etc/php.ini
RUN sed -i 's/max_execution_time = 30/max_execution_time = 300/g'  /etc/php.ini
RUN sed -i 's/log_errors = On/log_errors = off/g'  /etc/php.ini
RUN sed -i '/^error_log/c error_log = /var/log/php.log' /etc/php.ini
RUN sed -i '/;date.timezone/c\date.timezone = Africa/Dar_es_Salaam' /etc/php.ini
RUN sed -i 's#;sendmail_path =#sendmail_path = /usr/sbin/sendmail -t -i#g' /etc/php.ini
RUN sed -i 's/magic_quotes_gpc = Off/magic_quotes_gpc = On/g' /etc/php.ini
RUN sed -i 's/disable_functions =/disable_functions = system,passthru,exec,shell_exec,popen,symlink,dl/g' /etc/php.ini
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini

RUN yum -y install mariadb-server mariadb
RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql/
RUN yum -y clean all
RUN sed -i '/\[mysqld\]/aport=3306' /etc/my.cnf

RUN \
  echo "/usr/bin/mysqld_safe --basedir=/usr &" > /tmp/config && \
  echo "cat /var/log/mariadb/mariadb.log" >> /tmp/config && \
  echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
  echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\";'" >> /tmp/config && \
  bash /tmp/config && \
  rm -f /tmp/config

VOLUME ["/var/lib/mysql"]

WORKDIR /data

CMD ["/usr/bin/mysqld_safe"]

EXPOSE 3306
EXPOSE 80

ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
