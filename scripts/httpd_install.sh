#!/bin/bash
yum install -y httpd
systemctl enable --now httpd
