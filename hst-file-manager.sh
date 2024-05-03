#!/bin/bash

DIR="/var/www/html/manager"
ADDR="127.0.0.1:9753"
FPM_CONF="/var/www/hst-file-manager.conf"

# apache
cat << EOF > /etc/apache2/conf.d/manager.inc
Alias /manager ${DIR}

<Directory ${DIR}>
    AllowOverride All
    Options FollowSymLinks

    <IfModule mpm_event_module>
        <FilesMatch \.php$>
            SetHandler "proxy:fcgi://${ADDR}"
        </FilesMatch>
    </IfModule>
</Directory>
EOF

# php-fpm config
cat << EOF > ${FPM_CONF}
[hst-file-manager]
listen = ${ADDR}
listen.allowed_clients = 127.0.0.1

user = root
group = www-data

pm = ondemand
pm.max_children = 8
pm.max_requests = 5000
pm.process_idle_timeout = 10s

php_admin_value[disable_functions] =
php_admin_value[max_execution_time] = 0
php_admin_value[max_file_uploads] = 200
php_admin_value[max_input_time] = 0
php_admin_value[max_input_vars] = 1000000
php_admin_value[memory_limit] = -1
php_admin_value[post_max_size] = 10000M
php_admin_value[upload_max_filesize] = 10000M
EOF

# service
cat << EOF > /etc/systemd/system/hst-file-manager.service
[Unit]
Description=HestiaCP File Manager
After=network.target

[Service]
ExecStart=/usr/sbin/php-fpm8.1 -y ${FPM_CONF} -R -F

[Install]
WantedBy=multi-user.target
EOF

systemctl stop hst-file-manager
systemctl start hst-file-manager
systemctl enable hst-file-manager
systemctl daemon-reload

systemctl reload apache2

mkdir -p $DIR
cd $DIR

wget https://github.com/ngatngay/file-manager/releases/latest/download/file-manager.zip -O file-manager.zip
unzip file-manager.zip

chmod -R 777 $DIR
