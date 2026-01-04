#!/bin/bash

yum install -y iptables-services
systemctl enable --now iptables

iptables-restore < iptables.rules

service iptables save
systemctl restart iptables
