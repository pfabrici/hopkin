# Hopkin
## Purpose
Hopkin is a template project for Apache Hop, that adds a couple of features often needed by larger projects in professional environments as :

- standardized delta value handling for extractions and transformations
- mechanism to optionally avoid jobs from being started in parallel
- mechanism to have time dependent configurations
- enhanced variable handling that allows to 
    - have job centric variables instead of global values 
    - switch variable content by startparameter
- central configuration for error mails/notifications

# Getting started
## Installation and configuration of Apache Hop

There is a detailed documentation of how to get started with Apache Hop on its website at https://hop.apache.org/manual/latest/getting-started/.  However, it is useful to use a good folder structure for the installation, that supports
- software updates for Hop itself, the Java JRE and the JDBC drivers
- handling and deployment of the projects script/program files 
- environment configuration
- handling of different server and developer environments, maybe on different OS types

Lets go through it step by step for Windows and Linux environments:

As an admin prepare a technical user that owns the installation. There is no need for admin rights so you can simply create a local user on windows. 
Choose a username without blanks, e.g. "hopkin". This will create a user home folder C:\Users\hopkin on windows and /home/hopkin on linux systems.
We need git to fetch and manage the hopkin sources so be sure to have it installed on your system.

Login with the newly created account and create C:\Users\hopkin\software on windows or /home/hopkin/software on Linux. 
We want to use a Java JRE that is dedicated only to Hop to avoid malfunctions due to automatic software updates on system level.
Therefore download an OpenJDK/JRE as zip or tarball e.g. from https://adoptium.net and unzip to c:\users\software or /home/hopkin/software.
Unzip the file and rename the resulting folder to c:\Users\hopkin\software\jre

Download latest or desired version of Hop from https://hop.apache.org/download and unzip to c:\Users\software or /home/hopkin/software.
Download MariaDB/mysql driver as a jar file and put it into a new folder C:\Users\hopkin\software\jdbc or to /home/hopkin/software/jdbc if you are on Linux.

Create an additional folder C:\Users\hopkin\config to hold general config files.

On Windows open the Usersetting dialog where you can define variables on user level. Create a couple of new variables and extend the path variable 

HOP_JAVA_HOME=C:\Users\hopkin\software\jre
HOP_CONFIG_FOLDER=C:\Users\hopkin\config
HOP_SHARED_JDBC_FOLDER=C:\Users\hopkin\software\jdbc
HOP_AUDIT_FOLDER=C:\Users\hopkin\config\audit
- add the hop location to the users path variable
PATH=<originalPath>;C:\Users\hopkin\software\hop;

In case of a linux system create a ~/.profile with the following content :

HOP_JAVA_HOME=/home/hopkin/software/jre
HOP_CONFIG_FOLDER=/home/hopkin/config
HOP_SHARED_JDBC_FOLDER=/home/hopkin/software/jdbc
HOP_AUDIT_FOLDER=/home/hopkin/config/audit
- add the hop location to the users path variable
PATH=${PATH}:/home/hopkin/software/hop
export HOP_JAVA_HOME HOP_CONFIG_FOLDER HOP_SHARED_JDBC_FOLDER HOP_AUDIT_FOLDER PATH 

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


