#!/bin/bash

echo "working with database $1, $2" >> mariadb/mariadb_time.txt

mariadb<< EOF >> dump.txt
drop database if exists mariadb;
create database mariadb;
use mariadb;
source mariadb/create_table.sql;
load data local infile '$1'
into table A
fields terminated by ','
ignore 1 lines
(A1,A2);
load data local infile '$2'
into table B
fields terminated by ','
ignore 1 lines
(B1,B2,B3);
drop index \`primary\` on B;
alter table B drop foreign key B_ibfk_1;
drop index B2 on B;
drop index \`PRIMARY\` on A;
EOF



for i in {1..7};
do
echo "running queries at $i time" >> mariadb/mariadb_time.txt;
for num in {1..4}
do
mariadb << EOF > dump.txt
use mariadb;
source mariadb/dummy.sql; 
EOF
mariadb << EOF > mariadb/query${num}_output.txt
use mariadb;
reset query cache;
set profiling = 1;
source mariadb/query${num}.sql;
show profiles;
reset query cache;
EOF
python3 clean.py mariadb mariadb/query${num}_output.txt
done
done
