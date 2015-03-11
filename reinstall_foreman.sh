#!/bin/bash

service foreman stop
service foreman-proxy stop
service foreman-tasks stop
service httpd stop

#export FOREMAN_GATEWAY=172.16.250.200
#export FOREMAN_GATEWAY=`ifconfig eth0 | grep "inet addr" | awk  '{print $2}' | awk -F: '{print $2}'`

#export FOREMAN_DIR=/usr/share/foreman
#export FOREMAN_PROVISIONING=true
#export FOREMAN_PROVISIONING=false

sudo -u foreman scl enable ruby193 "cd $FOREMAN_DIR; rake db:drop RAILS_ENV=production FOREMAN_PROVISIONING=$FOREMAN_PROVISIONING"
#sudo -u foreman scl enable ruby193 "cd $FOREMAN_DIR; rake db:create RAILS_ENV=production FOREMAN_PROVISIONING=$FOREMAN_PROVISIONING"
#sudo -u foreman scl enable ruby193 "cd $FOREMAN_DIR; rake db:migrate RAILS_ENV=production FOREMAN_PROVISIONING=$FOREMAN_PROVISIONING"
#cd /usr/share/openstack-foreman-installer/bin
#./foreman_server.sh 

export SEED_ADMIN_USER=tonyli
export SEED_ADMIN_FIRST_NAME=Tony
export SEED_ADMIN_LAST_NAME=Li
export SEED_ADMIN_EMAIL=jintli@redhat.com
export SEED_ADMIN_PASSWORD=changeme!

#/usr/sbin/rhel-osp-installer 

