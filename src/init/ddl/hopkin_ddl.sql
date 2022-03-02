CREATE DATABASE hopkin;
ALTER DATABASE hopkin CHARACTER SET utf8 COLLATE utf8_general_ci;

grant all on hopkin.* to dwhetl@'localhost' identified by 'password';

use hopkin;

CREATE TABLE job_def
(
   job_name varchar(128) NOT NULL,
   job_type varchar(255) DEFAULT NULL,
   script_name varchar(128) DEFAULT NULL,
   script_type varchar(10) DEFAULT NULL,
   unique_run varchar(1) DEFAULT 'Y' NOT NULL,
   deltajob varchar(1) DEFAULT 'N' NOT NULL,
   deltascript varchar(128) DEFAULT NULL,
   valid_from datetime DEFAULT current_timestamp() NOT NULL,
   valid_to datetime DEFAULT '3000-12-31 00:00:00',
   ins_timestamp datetime DEFAULT current_timestamp(),
   mod_timestamp datetime DEFAULT current_timestamp(),
   PRIMARY KEY (job_name,valid_from)
)
;

CREATE TABLE job_delta
(
   target_name varchar(255) NOT NULL,
   source_name varchar(255) NOT NULL,
   source varchar(255) NOT NULL,
   delta_type varchar(255) NOT NULL,
   str_value varchar(255) ,
   date_value date ,
   ts_value timestamp ,
   int_value integer ,
   ins_timestamp datetime DEFAULT current_timestamp() NOT NULL,
   mod_timestamp datetime DEFAULT current_timestamp(),
   run_id integer ,
   PRIMARY KEY (target_name,source_name,source)
)
;

CREATE TABLE job_param_group (
   job_name varchar(128) NOT NULL,
   param_group varchar(128) NOT NULL,
   ins_timestamp datetime DEFAULT current_timestamp(),
   mod_timestamp datetime DEFAULT current_timestamp(),
   PRIMARY KEY (job_name,param_group)
);

ALTER TABLE job_param_group
ADD CONSTRAINT job_param_group_ibfk_1
FOREIGN KEY (job_name)
REFERENCES job_def(job_name)
;

CREATE TABLE job_param
(
   param_key varchar(128) NOT NULL,
   param_value varchar(256) ,
   param_group varchar(128) NOT NULL,
   param_ispwd varchar(1) DEFAULT 'N' NOT NULL,
   valid_from datetime DEFAULT '1900-01-01 00:00:00' NOT NULL,
   valid_to datetime DEFAULT '3000-12-31 23:59:59',
   mod_timestamp datetime DEFAULT current_timestamp(),
   configured varchar(20) DEFAULT 'N/A',
   PRIMARY KEY (param_key,param_group,valid_from)
)
;

CREATE TABLE job_prot
(
   run_id integer PRIMARY KEY NOT NULL,
   process_id varchar(40) DEFAULT NULL,
   job_name varchar(128) NOT NULL,
   job_status varchar(20) ,
   os_process_id integer ,
   ins_timestamp datetime DEFAULT current_timestamp(),
   mod_timestamp datetime DEFAULT current_timestamp()
)
;
ALTER TABLE job_prot
ADD CONSTRAINT job_prot_ibfk_1
FOREIGN KEY (job_name)
REFERENCES job_def(job_name)
;
CREATE INDEX job_name ON job_prot(job_name)
;
CREATE TABLE job_suffix
(
   job_name varchar(128) NOT NULL,
   source_name varchar(20) DEFAULT NULL,
   script_suffix varchar(20) DEFAULT NULL,
   valid_from datetime DEFAULT current_timestamp(),
   valid_to datetime DEFAULT '3000-12-31 23:59:59',
   ins_timestamp datetime DEFAULT current_timestamp() NOT NULL,
   mod_timestamp datetime DEFAULT current_timestamp(),
   configured varchar(20) DEFAULT 'N/A'
)
;
ALTER TABLE job_suffix
ADD CONSTRAINT job_suffix_ibfk_1
FOREIGN KEY (job_name)
REFERENCES job_def(job_name)
;
CREATE INDEX job_name ON job_suffix(job_name)
;

