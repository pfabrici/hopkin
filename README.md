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

# Usage

## 
- Install git systemwide
- create a Windows user, e.g. "hopkin" with a home folder in c:\Users\hopkin and login as the new user
- create C:\Users\hopkin\software 
- download jre ( Windows, zip, x64, jre11 ) e.g. from https://adoptium.net and unzip to c:\users\software. Rename jre folder to c:\Users\software\jre 
- download latest or desired version of Hop ( https://hop.apache.org/download ) and unzip o c:\Users\software.

- create C:\Users\hopkin\config
- set new windows environment variables
HOP_JAVA_HOME=C:\Users\hopkin\software\jre
HOP_CONFIG_FOLDER=C:\Users\hopkin\config
- add the hop location to the users path variable
PATH=<originalPath>;C:\Users\hopkin\software\hop;

- test the Hop base installation by running hop-gui.bat from a terminal ( cmd ). In the terminal you should see some log lines showing that a new configuration file
was created in C:\Users\hopkin\config. The Hop Gui should open up after a while



## Initial on Windows
- fork the original hopkin repo as a starting point for your project
git clone gggg myproject

- prepare a dataabse to store the metadata
currently supported is mysql, mariadb

create database hopkin;
grant all on hopkin.* to hopkin@'%' identified by 'hopkinpwd';
( unsecure, change password and % to reasonable values )

- start hop and create a new project with PROJECT_HOME pointing to your fork or use hop-conf.sh to create the project

hop-conf.bat -pc -p myproject -ph ${HOME}

- create an environment file that contains the configuration to the HOPKIN METADATABASE

hop-conf.bat -ec -e devenv -eg 

- restart hop and run hopkin_prepare.hwf

hop-run.bat -j myproject -e devenv ctrl/hopkin_prepare.hwf



## demo run


