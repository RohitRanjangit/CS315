#!/bin/bash

if [ -f sqlite.db ]; then
    rm -rf sqlite.db
fi


echo -e "\nworking with database $1, $2\n" >> sqlite_time.txt

sqlite3 sqlite.db  << EOF >> dump.txt
.mode csv
.read create_table.sql
.import $1 A
.import $2 B
EOF

for i in {1..5};
do
echo "running queries at $i time" >> sqlite_time.txt
sqlite3 sqlite.db << EOF >> sqlite_time.txt
.timer on
.output dump.txt
.read query1.sql
.output dump.txt
.read query2.sql
.output dump.txt
.read query3_2.sql
.output dump.txt
.read query4_2.sql  
EOF
done


if [ -f sqlite.db ]; then
    rm -rf sqlite.db
fi