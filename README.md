graphLoader
===========

This script loads graphs under separate named graphs in Virtuoso 7.0.0. 

First, you need Virtuoso. Assuming you don't have it just follow the steps from 
the beginning. It's a Mac OS X installation.


You can skip Homebrew and Virtuoso installations if you already have them installed.

##Homebrew installation

Download the latest version of the Homebrew though its official [website](http://brew.sh/)
Easiest way would be to just use the following command in the terminal
````
$ ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
````
Then run `brew update` to make sure there are no updates available and if there are it will update it.
````
$ brew update
#Then you can check the status of the installation by running the following command.
$ brew doctor
````
##Virtuoso installation

1) install Virtuoso

```brew install virtuoso```

2) go to ```virtuoso.ini``` and change couple of values there:

```cd /usr/local/Cellar/virtuoso/7.0.0/var/lib/virtuoso/db```

```vim virtuoso.ini```

Change the following values and save the file:

```` 
[Parameters]
NumberOfBuffers = 340000
MaxDirtyBuffers = 250000

[Database]
MaxCheckpointRemap = 625000


[SPARQL]
MaxQueryCostEstimationTime = 4000 ; in seconds
MaxQueryExecutionTime = 600 ; in seconds 
````

3) Start the server

```cd /usr/local/Cellar/virtuoso/7.0.0/var/lib/virtuoso/db```

```virtuoso-t -f &``` 

4) Go to [http://localhost:8890](http://localhost:8890) > Conductor > and type a standard username: ```dba``` and password: ```dba```

## LOAD graphs to Virtuoso

1) Go to ```loadToVirtuoso.sh``` script and change a path to a folder where all the files are stored. Save it. 

2) Make the file executable: ```chmod +x loadToVirtuoso.sh```

3) Run script ```./loadToVirtuoso.sh```

4) Go to [http://localhost:8890/sparql](http://localhost:8890/sparql) and check if your graphs are properly added

```SELECT ?g COUNT(*) { GRAPH ?g {?s ?p ?o.} } GROUP BY ?g ORDER BY DESC 2```

Works? So you did everything right :)
