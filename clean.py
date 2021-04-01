from sys import argv

# print(argv)

def time_sqlite(fname):
    # print(fname)
    wfname = open('sqlite/sqlite_time.txt','a')
    with open(fname, 'r') as f:
        line = f.readlines()[-1].split()
        # print(line)
        wfname.write(str(int(max(float(line[3]), float(line[5]) + float(line[7]))*1000)))
        wfname.write('\n')
    
    wfname.close()

def time_mariadb(fname):
    wfname = open('mariadb/mariadb_time.txt','a')
    with open(fname, 'r') as f:
        line = f.readlines()[-1].split()
        wfname.write(str(int(float(line[1])*1000)))
        wfname.write('\n')

    wfname.close()

def time_mariadb_idx(fname):
    wfname = open('mariadb_idx/mariadb_idx_time.txt','a')
    with open(fname, 'r') as f:
        line = f.readlines()[-1].split()
        wfname.write(str(int(float(line[1])*1000)))
        wfname.write('\n')

    wfname.close()

def time_mongo(fname):
    wfname = open('mongo/mongo_time.txt','a')
    with open(fname, 'r') as f:
        for line in f:
            if "executionTimeMillisEstimate" in line:
                continue
            if "executionTimeMillis" in line:
                wfname.write(line.strip().split()[2][:-1])
                wfname.write('\n')
    
    wfname.close()



if argv[1] == 'sqlite':
    time_sqlite(argv[2])
elif argv[1] == 'mongo':
    time_mongo(argv[2])
elif argv[1] == 'mariadb':
    time_mariadb(argv[2])
elif argv[1] == 'mariadb_idx':
    time_mariadb_idx(argv[2])
else:
    exit(0)
