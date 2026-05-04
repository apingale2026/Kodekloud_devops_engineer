#!/bin/bash

DB_NAME="kodekloud_db01"
USER="kodekloud_roy"
PASS="asdfgdsd"

# Check if database exists
mysql -u root -e "SHOW DATABASES;" | grep -q "${DB_NAME}"
if [ $? -eq 0 ]; then
    echo "Database already exists"
else
    mysql -u root -e "CREATE DATABASE ${DB_NAME};"
    echo "Database ${DB_NAME} has been created"
    mysql -u root -e "CREATE USER '${USER}'@'%' IDENTIFIED BY '${PASS}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${USER}'@'%';"
    mysql -u root -e "FLUSH PRIVILEGES;"
fi

# Check if database has tables
mysql -u root ${DB_NAME} -e "SHOW TABLES;" | grep -q "."
if [ $? -eq 0 ]; then
    echo "database is not empty"
else
    mysql -u root ${DB_NAME} < /opt/db_backups/db.sql
    echo "imported database dump into ${DB_NAME} database."
fi

# Take a backup
mysqldump -u root ${DB_NAME} > /opt/db_backups/${DB_NAME}.sql
