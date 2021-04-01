#!/bin/bash

if [ -f sqlite/sqlite.db ]; then
    rm -rf sqlite/sqlite.db
fi


echo "working with database $1, $2" >> sqlite/sqlite_time.txt

sqlite3 sqlite/sqlite.db  << EOF >> dump.txt
.mode csv
.read sqlite/create_table.sql
.import $1 A
.import $2 B
EOF

for i in {1..7};
do
echo "running queries at $i time" >> sqlite/sqlite_time.txt
for num in {1..4}
do
sqlite3 sqlite/sqlite.db < sqlite/dummy.sql > dump.txt
sqlite3 sqlite/sqlite.db << EOF > sqlite/query${num}_output.txt
.timer on
.read sqlite/query${num}.sql
EOF
python3 clean.py sqlite sqlite/query${num}_output.txt
done
done



if [ -f sqlite/sqlite.db ]; then
    rm -rf sqlite/sqlite.db
fi