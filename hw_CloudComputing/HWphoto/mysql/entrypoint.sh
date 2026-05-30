#!/bin/bash

# newly init volume by compose has something in it, so mysql didn't automatically change the owner from root:root to mysql:mysql
chown -R mysql:mysql /var/lib/mysql
echo "chown status : $?"



# start mysql
mysqld & 
echo -n 'waiting for mysqld to start...'
until mysqladmin ping >/dev/null 2>&1; do 
	echo -n '.'
	sleep 1
done 
echo 'done'

# creating a user that accept all host (if not exists)
mysql -v -e "
	create user if not exists root@'%';
	grant all privileges on *.* to root@'%' with grant option;
	flush privileges;
	select user,host from mysql.user;
" 2>&1

# create the database and table
mysql -v -e "
	create database if not exists mydb;
	use mydb;
	create table if not exists data (
		id int primary key auto_increment, 
		image_name varchar(1024), 
		image longblob, 
		location varchar(1024), 
		time datetime
	);
	alter table data alter column image_name set default 'unknown image';
	alter table data alter column location set default 'unknown location';
	alter table data alter column time set default (current_date);
" 2>&1


# kill mysqld
m_pid=$(pgrep mysqld)
kill $m_pid
echo -n "waiting for mysqld($m_pid) to stop..."
while ps -p $m_pid >/dev/null 2>&1; do
	echo -n '.'
	sleep 1
done
echo 'done'

ps -e

exec "$@"
