#!/bin/bash

groupadd -g $OWNER_GID owner
if [[ $? -ne 9 ]];then
useradd -d /work/goldrush -u $OWNER_UID -g owner owner
chown owner -R /var/run/mysqld /var/log/mysql*
cp /work/tools/my.cnf /etc/mysql/
service mysql start
cp /work/tools/smb.conf /etc/samba/
service samba start
cd /work/sql
mysql -u root < CreateDatabase.SQL && mysql -u grdev -p grdev --password=grdev < InitData.SQL
cp /work/goldrush/config/database.yml{.org,}
cd /work/goldrush
bundle install
su owner -c "rake db:fixtures:load FIXTURES_PATH=fixtures/develop"
else
service mysql start
service samba start
fi
su owner
