#!/bin/bash

echo "working with database $1, $2" >> mariadb_idx/mariadb_idx_time.txt

mariadb<< EOF > dump.txt
drop database if exists mariadb_idx;
create database mariadb_idx;
use mariadb_idx;
source mariadb_idx/create_table.sql;
load data local infile '$1'
into table A
fields terminated by ','
ignore 1 lines;
load data local infile '$2'
into table B
fields terminated by ','
ignore 1 lines;
create index sort on B(B3 asc,B1,B2);
EOF



for i in {1..7};
do
echo "running queries at $i time" >> mariadb_idx/mariadb_idx_time.txt;
for num in {1..4}
do
mariadb << EOF > dump.txt
use mariadb_idx;
source mariadb_idx/dummy.sql; 
EOF
mariadb << EOF > mariadb_idx/query${num}_output.txt
use mariadb_idx;
reset query cache;
set profiling = 1;
source mariadb_idx/query${num}.sql;
show profiles;
reset query cache;
EOF
python3 clean.py mariadb_idx mariadb_idx/query${num}_output.txt
done
done
