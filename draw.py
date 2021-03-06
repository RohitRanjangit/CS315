import numpy as np
import matplotlib.pyplot as plt
import os
import pandas as pd
import dataframe_image as dfi
import math

from sys import argv
from uncertainties import ufloat


if not os.path.exists('graph'):
    os.makedirs('graph')

def round_up(n, decimals=0): 
    multiplier = 10 ** decimals 
    return math.ceil(n * multiplier) / multiplier

def round_down(n, decimals=0): 
    multiplier = 10 ** decimals 
    return math.floor(n * multiplier) / multiplier

query = {}

engines = ['sqlite', 'mariadb_idx', 'mariadb' , 'mongo']
#engines = ['sqlite']
if len(argv) > 1:
    engines = argv[1:]

def insert_into(q, database, engine, avg_time, std_dev):

    if q not in query:
        query[q] = {}

    if engine not in query[q]:
        query[q][engine] = {}

    if query[q][engine] == {}:
        query[q][engine]['time'] = []
        query[q][engine]['std'] = []
        query[q][engine]['databases'] = []
    
    query[q][engine]['time'] += [avg_time]
    query[q][engine]['std'] += [std_dev]
    query[q][engine]['databases'] += [database]

    
    

def scan_time(engine):

    fname = engine + '/' + engine + '_time.txt'

    with open(fname ,'r') as f:

        for line in f:
            if "working" in line:

                database = line.split('/')[-1][:-1]
                query_time =[[] for _ in range(4)]

                for t in range(7):
                    line = f.readline()
                    for q in range(4):
                        query_time[q] += [int(f.readline())]
                
                for q in range(4):

                    query_time[q].sort()
                    # print(query_time[q])

                    avg_time = round_up(np.mean(query_time[q][1:-1]),1)
                    std_dev = round_down(np.std(query_time[q][1:-1]),0)

                    insert_into(q, database, engine, avg_time, std_dev)


for engine in engines:
    scan_time(engine)

for q in query:

    fig, (time) = plt.subplots(1, figsize= (13,8)) # add 2 on place of 1 

    fig.suptitle('query' + str(q + 1))
    

    time.set_title("time graph")
    #std.set_title("std dev graph")

    for engine in engines:
        time.errorbar(query[q][engine]['databases'], [t if t > 1 else 1 for t in query[q][engine]['time']] , query[q][engine]['std'], label = engine)
        # std.plot(query[q][engine]['databases'], query[q][engine]['std'] , label = engine)
    
    time.set(xlabel = 'database sizes', ylabel = 'time in milliseconds (log10 scale)')
    #std.set(xlabel = 'database engine', ylabel = 'time in milliseconds')

    time.legend()
    #std.legend()

    # if q==1 or q == 3:
    time.set_yscale("log")

    fig.tight_layout()

    plt.savefig('graph/'  + 'query' + str(q + 1) + '.png')
    plt.close()

query_name = ['query' + str(q + 1) for q in query]
plt.figure(figsize= (13,8))
plt.title('time for last set of databases')
for engine in engines:
    times =[]
    for q in query:
        times += [query[q][engine]['time'][-1]]
    plt.plot(query_name, [t if t >1 else 1 for t in times], label=engine)
plt.xlabel("Queries")
plt.ylabel("time in milliseconds (log10 scale)")
plt.legend()
plt.yscale('log')
plt.savefig('graph/'  + 'query.png')
plt.close()
    

database_time_table = {}
index = [[], []]

for engine in engines:
    for q in query:
        index[0] += [engine]
        index[1] += ['query' + str(q + 1)]
        for i, database in enumerate(query[q][engine]['databases']):
            if database not in database_time_table:
                database_time_table[database] = []
            database_time_table[database] += [str(ufloat(query[q][engine]['time'][i], query[q][engine]['std'][i])).replace('+/-',u"\u00B1")]

df = pd.DataFrame(database_time_table, index=index)
dfi.export(df, 'graph/table.png')
