Roll=180629
a=$(($Roll%1000/100))
b=$(($Roll%100/10))
c=$(($Roll%10))

if [ -f dump.txt ]; then
    rm -rf dump.txt
fi


if [ $# -eq 0 ]; then
    rm -rf sqlite/*.txt
else 
    if [ $1 = 'sqlite' ]; then
        rm -rf sqlite/*.txt
    fi
fi


if [ $# -eq 0 ]; then
    rm -rf mariadb_idx/*.txt
else
    if [ $1 = 'mariadb_idx' ]; then
        rm -rf mariadb_idx/*.txt
    fi
fi


if [ $# -eq 0 ]; then
    rm -rf mariadb/*.txt
else
    if [ $1 = 'mariadb' ]; then
        rm -rf mariadb/*.txt
    fi
fi

if [ $# -eq 0 ]; then
    rm -rf mongo/*.txt
else
    if [ $1 = 'mongo' ]; then
        rm -rf mongo/*.txt
    fi
fi



abc=($a $b $c)
size=(100 1000 10000)
arr=(
    {3,5,10}
    {5,10,50}
    {5,50,500}
)


for i in {0,1,2};
do
    for j in {0,1,2};
    do
        id=$((i*3+j))
        r=$(($((${abc[i]}*${abc[j]}))%5))
        if [ $# -eq 0 ]
            then
                bash sqlite/sqlite3.sh dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv 3>&1 1>dump.txt 2>&1
                bash mariadb_idx/mariadb_idx.sh dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv
                bash mariadb/mariadb.sh dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv
                bash mongo/mongo.sh dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv
            else
                case $1 in
                    'sqlite')
                        echo 'running on ' dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv
                        bash sqlite/sqlite3.sh dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv 3>&1 1>dump.txt 2>&1
                    ;;
                    'mariadb_idx')
                        echo 'running on ' dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv
                        bash mariadb_idx/mariadb_idx.sh dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv
                    ;;
                    'mariadb')
                        echo 'running on ' dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv
                        bash mariadb/mariadb.sh dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv
                    ;;
                    'mongo')
                        echo 'running on ' dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv
                        bash mongo/mongo.sh dbs/A-${size[$i]}.csv dbs/B-${size[$i]}-${arr[$id]}-$r.csv
                    ;;
                esac
        fi
    done
done

# if [ -f dump.txt ]; then
#     rm -rf dump.txt
# fi
