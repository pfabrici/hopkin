CREATE DATABASE hopkin;
ALTER DATABASE hopkin CHARACTER SET utf8 COLLATE utf8_general_ci;

grant all on hopkin.* to dwhetl@'localhost' identified by 'password';

use hopkin;

/*
DROP TABLE job_param;
DROP TABLE job_param_group;
DROP TABLE job_prot;
DROP TABLE job_delta;
DROP TABLE job_def;
*/


CREATE TABLE job_def (
   job_name 		varchar(128) NOT NULL,
   job_folder 		varchar(255) NOT NULL,
   script_name 		varchar(128) DEFAULT NULL,
   script_type 		varchar(10) DEFAULT NULL,
   is_unique 		varchar(1) DEFAULT 'Y' NOT NULL,
   is_delta_job 	varchar(1) DEFAULT 'N' NOT NULL,
   delta_script 	varchar(128) DEFAULT NULL,
   valid_from 		date DEFAULT current_date(),
   valid_to 		date DEFAULT '3000-01-01',
   ins_timestamp 	datetime DEFAULT current_timestamp(),
   mod_timestamp 	datetime DEFAULT current_timestamp(),
   PRIMARY KEY (job_name, job_folder, valid_from)
);

CREATE TABLE job_delta
(
   target_name 	        varchar(255) NOT NULL,
   source_name 	        varchar(255) NOT NULL,
   delta_type 	        varchar(255) NOT NULL,
   delta_value 	        varchar(255) ,
   ins_timestamp        datetime DEFAULT current_timestamp(),
   mod_timestamp        datetime DEFAULT current_timestamp(),
   process_id           varchar(40),
   PRIMARY KEY (target_name,source_name,delta_type)
);


CREATE TABLE job_param_group (
   job_name             varchar(128) NOT NULL,
   job_folder           varchar(128) NOT NULL,
   param_group          varchar(128) NOT NULL,
   ins_timestamp        datetime DEFAULT current_timestamp(),
   mod_timestamp        datetime DEFAULT current_timestamp(),
   PRIMARY KEY (job_name,param_group)
);

CREATE TABLE job_param
(
   param_key            varchar(128) NOT NULL,
   param_value          varchar(256),
   param_group          varchar(128) NOT NULL,
   param_type           varchar(128) NOT NULL DEFAULT 'String',
   is_password          varchar(1) DEFAULT 'N' NOT NULL,
   configured_by        varchar(20) DEFAULT 'N/A',
   valid_from           date DEFAULT '1900-01-01' NOT NULL,
   valid_to             date DEFAULT '3000-12-31' NOT NULL,
   ins_timestamp        datetime DEFAULT current_timestamp(),
   mod_timestamp        datetime DEFAULT current_timestamp(),
   PRIMARY KEY (param_key,param_group,valid_from)
);


CREATE TABLE job_prot (
   process_id           varchar(40) PRIMARY KEY NOT NULL,
   job_name             varchar(128) NOT NULL,
   job_folder           varchar(128) NOT NULL,
   job_status           varchar(20) ,
   os_process_id        integer,
   exit_code            integer,
   duration 	        int default 0,
   ins_timestamp        datetime DEFAULT current_timestamp(),
   mod_timestamp        datetime DEFAULT current_timestamp()
);

