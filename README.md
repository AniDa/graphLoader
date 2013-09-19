graphLoader
===========

Graph loader (under separate named graphs) to Virtuoso 7.0.0.

From scrath on MAC:

1) install Virtuoso

```brew install virtuoso```

2) go to ```virtuoso.ini``` and change couple of values there:

```cd /usr/local/Cellar/virtuoso/7.0.0/var/lib/virtuoso/db```
```vim virtuoso.ini```

Change the following values and save the file:

[Parameters]
NumberOfBuffers          = 340000
MaxDirtyBuffers          = 250000

[SPARQL]
MaxQueryCostEstimationTime 	= 4000	; in seconds
MaxQueryExecutionTime      	= 600	; in seconds

3) Start the server

```cd /usr/local/Cellar/virtuoso/7.0.0/var/lib/virtuoso/db```
```virtuoso-t -f &``` 

4) Go to ```http://localhost:8890``` > Conductor > and type a standard username: ```dba``` and password: ```dba```

5) Go to ```loadToVirtuoso.sh``` script and change a path to a folder where all the files are stored. Save it. 

6) make the file executable: ```chmod +x loadToVirtuoso.sh```

7) run script
``` ./loadToVirtuoso.sh```

8) Go to ```http://localhost:8890/sparql``` and check if your graphs are properly added

```SELECT ?g COUNT(*) { GRAPH ?g {?s ?p ?o.} } GROUP BY ?g ORDER BY DESC 2```

Works? So you did everything right :)
