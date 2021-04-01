#!/bin/bash

echo "working with database $1, $2" >> mongo/mongo_time.txt

mongo <<EOF > dump.txt
use mongo_db
db.dropDatabase()
EOF

mongoimport --type csv -d mongo_db -c A  --headerline --drop $1 3>&1 1>dump.txt 2>&1
mongoimport --type csv -d mongo_db -c B  --headerline --drop $2 3>&1 1>dump.txt 2>&1



for i in {1..7};
do
echo "running queries at $i time" >> mongo/mongo_time.txt;
for num in {1..4}
do
mongo < mongo/query${num}.js >  mongo/query${num}_output.txt
python3 clean.py mongo mongo/query${num}_output.txt
done
done