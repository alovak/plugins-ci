#!/bin/bash
set -e

echo "Setup DB"

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
	echo "=> Waiting for confirmation of MySQL service startup"
	sleep 2
	mysql -uroot -e "status" > /dev/null 2>&1
	RET=$?
done

echo "CREATE DATABASE IF NOT EXISTS demo; CREATE USER 'demo'@'%' IDENTIFIED BY 'demo'; GRANT ALL PRIVILEGES ON *.* TO 'demo'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql -uroot

mysqladmin -uroot shutdown
