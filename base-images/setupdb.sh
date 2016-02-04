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

mysql -uroot

for i in {30..0}; do
	if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
		break
	fi
	echo 'MySQL init process in progress...'
	sleep 1
done
if [ "$i" = 0 ]; then
	echo >&2 'MySQL init process failed.'
	exit 1
fi

echo "CREATE DATABASE IF NOT EXISTS demo;"
echo "CREATE USER demo@localhost IDENTIFIED BY 'demo';"
echo "GRANT ALL PRIVILEGES ON demo.* TO demo@localhost;"
echo "FLUSH PRIVILEGES;"
echo "exit"

mysqladmin -uroot shutdown
