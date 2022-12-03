#!/bin/bash
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%';"