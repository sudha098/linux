#!/bin/bash

cp apache/conf/httpd.conf /etc/httpd/conf/httpd.conf
cp apache/conf/main.conf /etc/httpd/conf.d/main.conf
cp apache/auth/authnz_external.conf /etc/httpd/conf.d/

mkdir -p /var/www/html/protected
cp -r apache/web/* /var/www/html/

systemctl restart httpd
