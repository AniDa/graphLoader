#!/bin/bash
# Created by Anna Dabrowska anna.dabrowskaatderi.org
# 
# Upload to Virtuoso 7.0. 
# Graphs are stored in .gz files in separate folders. 
# All folders are collected under one directory, which 
# should be given to _folder_location. Virtuoso: port, 
# user and password are standard and can be changed.
#------------------------------------------------------


# show commands being executed, per debug
#set -x

#------------------------------------------------------
# define database connectivity and folder location
#------------------------------------------------------

_port=1111 # Define port (1111 is a default port)
_db_user="dba" # Define a database username
_db_password="dba" # Define a database password. Please note that the passowrd has to be used. If not the script will require some small changes 
_folder_location="path to a folder location" # Change it to the location of the folder, which stores all RDF files that will be loaded to Virtuoso



# get the folder name from the path where all graphs are located
_folder_name=`basename $_folder_location`

# define directory containing RDF files in virtuoso
_basic_directory="/usr/local/Cellar/virtuoso/7.0.0/share/virtuoso/vad"
_rdf_directory="${_basic_directory}/${_folder_name}"


#------------------------------------------------------
# Copy a directory with RDF files to a default directory 
# from which files are uploaded to Virtuoso.
# Files are unzipped and zipped versions deleted
#------------------------------------------------------

# copy a folder with rdf files to a default directory in virtuoso
cp -a -R "$_folder_location" "$_rdf_directory"

#go to basic directory
cd $_rdf_directory

# loop through all .gz files
for _rdf_file in `find . -iname '*.gz'`
do	  
	# remove .gz extension
	_rdf_file_no_gz=`echo $_rdf_file | sed 's/\(.*\)\..*/\1/'`
	
	# unzip the file and save it in the same directory it's located
	gzip -dc $_rdf_file > $_rdf_file_no_gz
	
	# remove zipped file (it's not needed  for uploading to Virtuoso)
	#rm -rf $_rdf_file    
done

#------------------------------------------------------
# Create *.graph files that store graph names that are 
# later used during LOAD in Virtuoso.
# File name is used as a graph name
#------------------------------------------------------

# go to directory
cd $_rdf_directory


# get a list of RDF files in directory (nt format)
_rdf_files=`find $_rdf_directory -iname '*.nt'`

# loop through RDF files
for _rdf_file in ${_rdf_files[@]}
do
  
  # remove file extension
  _rdf_path_extensionless=`echo $_rdf_file | sed 's/\(.*\)\..*/\1/'`

  # leave only file name (cut the path)
  _rdf_file_extensionless=`basename "$_rdf_path_extensionless"`
  
  # define a file containing a graph name
  _graph_file=`echo $_rdf_file | sed 's/$/.graph/'`
  
  # define graph name for each file
  _graph_URI="http://${_rdf_file_extensionless}"
    #echo $_graph_URI
  
  #write graph URI to a graph file  
  echo $_graph_URI > $_graph_file
  
done

#-----------------------------------------------
# Load all files to Virtuoso under separate graphs
#-----------------------------------------------

/usr/local/opt/virtuoso/bin/isql $_port $_db_user $_db_password << EOF

LOAD /usr/local/Cellar/virtuoso/rdfloader.sql;
ld_dir_all('$_rdf_directory', '*.nt', '');
rdf_loader_run();
EXIT;  

EOF

exit
