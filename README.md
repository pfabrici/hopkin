# Hopkin
## Purpose
Hopkin aims to support you to get started with Apache Hop ( https://hop.apache.org ) projects by supplying a template project containing some useful extensions and a documentation how to set up an environment that supports developer and server.

The extensions include a 
- standardized delta value handling for extractions and transformations
- mechanism to optionally avoid jobs from being started in parallel ( execution control )
- usage of a metadata database for configuration items that allows the separation of operations and development, which is still a topic even in times of DevOps
- enhanced variable handling that allows to 
    - have job centric variables instead of global values 
    - have variable values that depend on date/time
    - switch variable content by startparameter
- central management of notifications ( by mail )

# Getting started
## Installation and configuration of Apache Hop

There is a detailed documentation of how to get started with Apache Hop on its website at https://hop.apache.org/manual/latest/getting-started/. However, some more thoughts are necessary to end up with a robust installation that fulfills production needs.

A folder structure for the installation, that is similar for all developer and server environments in a project, is useful and a good starting point. The structure should support

- easy software updates for Hop itself, the Java JRE and the JDBC drivers
- clear handling and deployment of the projects script/program files 
- standardized environment configuration

Data integration projects often require the ETL software to be installed on different developer computers and several servers, e.g. for production, testing, etc. Any combination of operating systems can be used; Windows, Mac and Linux are supported by Apache Hop for both server and client.

While the servers tend to work with dedicated operating system users for the ETL processes, the developer computers tend to work with personal accounts. This documentation describes the installation with a dedicated “hopkin” operating system user, which is, however, easily transferable to personal users.

However, due to various problems with file paths, care should be taken to ensure that the user names do not contain any spaces

Lets go through this step by step for Windows and Linux environments

### General
#### Database for Metadata



### Windows
#### Preparations on OS level
As an admin user prepare a technical user that owns the installation. There is no need for admin rights so you can simply create a local user on windows. Choose a username without blanks, e.g. "hopkin". This will create a user home folder C:\Users\hopkin.

We need git to fetch and manage the hopkin sources so be sure to have it installed on your system. Fetch the latest git client from https://git-scm.com/.

Now log in with the new hopkin account and create C:\Users\hopkin\software where you want to put your software. 

#### Install JRE
We want to use a Java JRE that is dedicated only to Hop to avoid malfunctions due to automatic software updates on system level. Therefore download an OpenJDK/JRE as zip or tarball e.g. from https://adoptium.net and unzip to C:\users\hopkin\software .
Unzip the file and rename the resulting folder to c:\Users\hopkin\software\jre.

#### Install Hop
Download the latest or desired version of Hop from https://hop.apache.org/download and unzip to C:\Users\hopkin\software. This should create a new folder C:\Users\hopkin\software\hop.

### Install JDBC Drivers
Download the MariaDB/mysql JDBC driver as a jar file and put it into a new folder C:\Users\hopkin\software\jdbc.

### Configuration of the software setup
It is necessary to set some environment variables for the user, so open the dialog and add :

![Environment](doc/img/EnvironmentVariables.png?raw=true "Environment Settings")

HOP_JAVA_HOME=C:\Users\hopkin\software\jre
HOP_CONFIG_FOLDER=C:\Users\hopkin\config
HOP_SHARED_JDBC_FOLDER=C:\Users\hopkin\software\jdbc
HOP_AUDIT_FOLDER=C:\Users\hopkin\config\audit

Finally add the hop location to the users path variable
PATH=<originalPath>;C:\Users\hopkin\software\hop;


Create an additional folder C:\Users\hopkin\config to hold general config files.

Re-Login with the hopkin user and check, if the variables are correctly set in the environment. Test the Hop base installation by running hop-gui.bat from a terminal ( cmd ). 
In the terminal you should see some log lines showing that a new configuration file was created in C:\Users\hopkin\config. The Hop Gui should open up after a while.




## Initial on Windows
- fork the original hopkin repo as a starting point for your project
cd C:\Users\hopkin\projects
git clone gggg myproject

- prepare a dataabse to store the metadata
currently supported is mysql, mariadb

create database hopkin;
grant all on hopkin.* to hopkin@'%' identified by 'hopkinpwd';
( unsecure, change password and % to reasonable values )

- start hop and create a new project with PROJECT_HOME pointing to your fork or use hop-conf.sh to create the project

hop-conf.bat -pc -p myproject -ph ${HOME}

- create an environment file that contains the configuration to the HOPKIN METADATABASE

cp C:\Users\hopkin\projects\myproject\env\hopkin_env.json.template C:\Users\hopkin\config\myproject_dev.json
Edit C:\Users\hopkin\config\myproject_dev.json 

To encrypt the password use 
hop-encrypt.bat -hop <mydbpassword>

hop-conf.bat -ec -e myproject-dev -eg C:\Users\hopkin\config\myproject-dev.json -ep myproject
hop-run.bat -j myproject -e devenv -r local -f ${PROJECT_HOME}/ctrl/hopkin_prepare.hwf

## demo run
hop-run.bat -j myproject -e devenv -r local -f ${PROJECT_HOME}/ctrl/hopkin_main.hwf


In case of a linux system create a ~/.profile with the following content :

HOP_JAVA_HOME=/home/hopkin/software/jre
HOP_CONFIG_FOLDER=/home/hopkin/config
HOP_SHARED_JDBC_FOLDER=/home/hopkin/software/jdbc
HOP_AUDIT_FOLDER=/home/hopkin/config/audit
- add the hop location to the users path variable
PATH=${PATH}:/home/hopkin/software/hop
export HOP_JAVA_HOME HOP_CONFIG_FOLDER HOP_SHARED_JDBC_FOLDER HOP_AUDIT_FOLDER PATH 
