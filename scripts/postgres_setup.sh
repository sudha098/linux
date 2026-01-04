#!/bin/bash

yum install -y postgresql-server postgresql-contrib
postgresql-setup initdb
systemctl enable --now postgresql

sudo -u postgres psql -f postgres/db_setup.sql
