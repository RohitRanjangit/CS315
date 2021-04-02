# How to Run Scripts?

The engines names are : `[sqlite, mariadb_idx, mariadb, mongodb]` 

**To run queries for all engines for 7 runs**

Run the following command

`sudo bash run.sh `

Then, enter you root administrator password for continue. It'll run for around 22-24 hrs depending on the environment and machine.

The time taken for each query for each engine  will appear in  directorie \${engine}/ in the file \${engine}\_time.txt .

    For eg.

                for **sqlite** the output(time taken) will appear in **sqlite/sqlite_time.txt**

To get the time for queries for specific engine. we can enter the following command:

`sudo bash run.sh engine_name`

        For eg.  To get the time for **mariadb with indexing**. 

            `sudo bash run.sh mariadb_idx`

To run using specific files on specific engine. we can enter the following command:

            `sudo engine_name/engine_name.sh file_name_A file_name_B`

        For eg. To run using files A-100.csv B-100-3-1.csv on mongodb

                `sudo mongo/mongo.sh A-100.csv B-100-3-1.csv`

To get the graphs and tables

we can add the following command, make sure you have installed the follwing python (pip3) packages: **[matplotlib, numpy, pandas, dataframe_image, uncertainties]**

`python3 draw.py`

The graphs and table will appear in the **graphs/** directory.

The see the graphs and tables for some engines. you can issue the following command:

`python3 draw.py [engine_names]`

        For eg. To see the table and graphs for mariadb with indexing and without                       indexing. use,

                      `python3 draw.py mariadb_idx mariadb`

          
