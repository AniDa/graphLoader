#!/bin/bash
# Created by Anna Dabrowska anna.dabrowskaatderi.org

# show commands being executed, per debug
#set -x

# define database connectivity
_db="localhost" # Please define host
_port=1111 # Please define port (1111 is a default port)
_db_user="dba" # Change the database username
_db_password="dba" # Change the database password. Please note that the passowrd has to be used. If not the script will require some more changes 

# define directory containing RDF files
_basic_directory="/usr/local/Cellar/virtuoso/7.0.0/share/virtuoso/vad/"
_rdf_directory="${_basic_directory}/test"

#create directory if not exist
mkdir -p $_rdf_directory/new_rdf_folder

# go into directory
cd $_rdf_directory

# get a list of RDF files in directory (n3 format!)
_rdf_files=`ls -1 *.n3`

# loop through RDF files
for _rdf_file in ${_rdf_files[@]}
do
  
  # remove file extension
  _rdf_file_extensionless=`echo $_rdf_file | sed 's/\(.*\)\..*/\1/'`
  
  # define a file containing a graph name
  _graph_file=`echo $_rdf_file | sed 's/$/.graph/'`
  
  # define graph name for each file
  _graph_URI="http://${_rdf_file_extensionless}"
  
  #write graph URI to a graph file  
  echo $_graph_URI > $_graph_file
  
  
done

# Login to isql environment
/usr/local/opt/virtuoso/bin/isql $_port $_db_user $_db_password << EOF

  # Load RDF loader
  LOAD /usr/local/Cellar/virtuoso/rdfloader.sql;

  #Register the files in separate graphs
  ld_dir_all('/usr/local/Cellar/virtuoso/7.0.0/share/virtuoso/vad/test', '*.n3', '');
  
  #Start the process
  rdf_loader_run();
  
  EXIT;
  
EOF

exit
