# Hopkin

* [Purpose](#Purpose)
* [Getting started with Apache Hop and Hopkin](#Getting-started-with-Apache-Hop-and-Hopkin)
    * [General](#General)
    * [Prepare Database for Metadata](#Prepare-Database-for-Metadata)
    * [Preparations on OS level](#Preparations-on-OS-level)
        * [Prepare an OS User](#Prepare-an-OS-User)
    * [Install JRE](#Install-JRE)
    * [Install Apache Hop](#Install-Apache-Hop)
    * [Install JDBC Drivers](#Install-JDBC-Drivers)
    * [Clone Hopkin repository](#Clone-Hopkin-repository)
    * [Hopkins Initialization](#Hopkins-Initialization)
    * [Demo Run](#Demo-Run)


## Purpose
Hopkin aims to support you to get started implementing real projects with Apache Hop ( https://hop.apache.org ) by supplying a template project containing some useful extensions and a guideline on how to set up an environment that supports developer and headless execution on a server.

The extensions include a 
- standardized delta value handling for extractions and transformations
- mechanism to optionally avoid jobs from being started in parallel ( execution control )
- usage of a metadata database for configuration items that allows the separation of operations and development, which is still a topic even in times of DevOps
- enhanced variable handling that allows to 
    - have job centric variables instead of global values 
    - have variable values that depend on date/time
    - switch variable content by startparameter
- central management of notifications ( by mail )

## Getting started with Apache Hop and Hopkin
### General

There is a detailed documentation of how to get started with Apache Hop on its website at https://hop.apache.org/manual/latest/getting-started/. However, some more thoughts are necessary to end up with a robust installation that fulfills production needs.

A folder structure for the installation, that is similar for all developer and server environments in a project, is useful and a good starting point. The structure should support

- easy software updates for Hop itself, the Java JRE and the JDBC drivers
- clear handling and deployment of the projects script/program files 
- standardized environment configuration

Data integration projects often require the ETL software to be installed on different developer computers and several servers, e.g. for production, testing, etc. Any combination of operating systems can be used; Windows, Mac and Linux are supported by Apache Hop for both server and client.

While the servers tend to work with dedicated operating system users for the ETL processes, the developer computers tend to work with personal accounts. This documentation describes the installation with a dedicated “hopkin” operating system user, which is, however, easily transferable to personal users.

However, due to various problems with file paths, care should be taken to ensure that the user names do not contain any spaces

Lets go through this step by step for Windows and Linux environments

### Prepare Database for Metadata
Hopkin stores metadata e.g. regarding job definitions and values for delta handling in a metadata database. This is different to Apache Hop itself, which stores all kinds of metadata details in the filesystem, mostly as json files.

At least one database needs to be provided upfront, currently supported is only MySQL/MariaDB. 

Create this database with 
```sql
CREATE DATABASE hopkin;
GRANT ALL ON hopkin.* TO hopkin@'%' IDENTIFIED BY 'hopkinpwd'
```
Be sure that you restrict network access to the database to your needs, e.g. replace '%' by a valid network pattern or IP and change the password to something secure.

Each server installation ( e.g. prod,test) of Hopkin should have its own metadata database. It depends on your development strategy if you like to create a database for each developer or if you have one shared dev database. 
Choose a matching naming convention for the database, e.g. hopkin_prod, hopkin_test, hopkin_dev1 etc.

### Preparations on OS level
#### Prepare an OS user
On a developer machine you might prefer to install hopkin for an existing personal user. You can do so and simply go over to the following steps. On servers you should prefer to have a dedicated technical user which hosts the hopkin installation.

Create this technical user with an admin user on Windows or with sudo/root on Linux as explained below. There is no need that the technical user gets admin rights so you can create a simple local user. Choose a username without blanks, e.g. "hopkin". 

On Windows run
```shell
net user hopkin hopkinpwd /add 
```
as Admin  to create a user hopkin with password hopkinpwd or create the user with the corresponding dialog. The users home folder will be accessible at 
C:\Users\hopkin.

On Linux you can create a user with the home folder /home/hopkin and set a password by running 
```
sudo useradd -s /bin/bash -m hopkin
sudo passwd hopkin
```

#### Install software packages
We need the git version control tool to fetch and manage the hopkin sources so be sure to have it installed on your system. 
On Windows fetch the latest git client package from the [Git website](https://git-scm.com/) and install the software. On Linux git can be installed using the package manager, e.g.
```
sudo apt-get install git
```

#### Prepare the folder structure
Now log in with the new hopkin account. All software packages, code and configuration files will be located in subfolders in the hopkin home folder. The overall structure will look like : 

![Folders](doc/img/directoryStructure.png?raw=true "Directory Structure")

To prepare the folder structure run this command in a windows terminal  
```shell
 md projects config software\jdbc
```

or 
```
cd ~
mkdir -p projects config software/jdbc
``` 
on Linux.

### Install JRE
It is recommended to use a Java JRE that is dedicated only to Hop to avoid malfunctions due to automatic software updates on system level. Therefore download an OpenJDK/JRE as zip or tarball e.g. from [Adoptium](https://adoptium.net) and unzip to C:\users\hopkin\software .
Unzip the file and rename the resulting folder to c:\Users\hopkin\software\jre.

### Install Apache Hop
Download the latest or desired version of Hop from https://hop.apache.org/download and unzip to C:\Users\hopkin\software. This should create a new folder C:\Users\hopkin\software\hop.

### Install JDBC Drivers
Download the MariaDB/mysql JDBC driver as a jar file and put it into a new folder C:\Users\hopkin\software\jdbc.

### Clone Hopkin repository
The hopkin repository contains a basic Apache Hop project. It contains a structure for ETL code, definitions of metadata tables and some control workflows and pipelines that will be described later. Clone the repository as a starting point for your ETL project by running 

```
cd c:\Users\hopkin\projects
git clone -o hopkin https://github.com/pfabrici/hopkin.git myproject
```

### Configuration of the software setup
The installation paths need to be available in some user environment variables, so that hop starts from the command line and finds and puts its components. Therefore open the user environment dialog and add :
![Environment](doc/img/EnvironmentVariables.png?raw=true "Environment Settings")
Finally add the hop location to the users path variable
PATH=<originalPath>;C:\Users\hopkin\software\hop;

Re-login to your hopkin user start a terminal and type 
```
set
```
to verify if the variables are set correctly.

In the next step we need to prepare a Hop environment file that contains the connection details to the metadata database. Create an additional folder C:\Users\hopkin\config and copy the template environment file from the repository from the command line or with the file explorer :

```
copy C:\Users\hopkin\projects\myproject\env\hopkin_env.json.template C:\Users\hopkin\config\myproject_dev.json
```

Edit C:\Users\hopkin\config\myproject_dev.json and change the values of HOPKIN_DB_USER, HOPKIN_DB_PASSWORD, HOPKIN_DB_CLASS, HOPKIN_DB_URL to what you defined in [Database for Metadata](#Database for Metadata). It is possible to use an encrypted password in HOPKIN_DB_PASSWORD. Open a terminal and  run

```
hop-encrypt.bat -hop <dbpassword>
```
The program will return a string that you can use in the JSON file.

### Hopkins Initialization 
As software, code and configuration files are now in place we need to tell Hop which projects and environments are available :

First, register project(s) and environments by running two commands on the command line:
```
hop-conf.bat -pc -p myproject -ph C:\Users\hopkin\projects\myproject
hop-conf.bat -ec -e myproject-dev -eg C:\Users\hopkin\config\myproject-dev.json -ep myproject
```
tells Hop that there is a project folder in C:\Users\hopkin\projects\myproject for a project called myproject. The second command indicates that there is an environment *myproject-dev* which belongs to project *myproject* and contains one definition file.

Please note that the naming convention is up to you :
- the project name *myproject* does not need to be the same as the referenced folder
- the environment name might be freely chosen, but is related to one project

The last init step is calling another command line command :
```
hop-run.bat -j myproject -e myproject-dev -r local -f ${PROJECT_HOME}/ctrl/hopkin_prepare.hwf
```
This starts the execution of some Hop code which 
- creates tables in the metadata database defined in the *myproject-dev* environment file
- populates the tables by reading data from jobdefinition files found under the src path of the *myproject* project folder.

### Demo run
To check if everything went fine you can start a demo ETL job that is included in the Hopkin repo by calling : 
```
hop-run.bat -j myproject -e myproject-dev -r local -f ${PROJECT_HOME}/ctrl/hopkin_main.hwf
```
