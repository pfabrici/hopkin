INSERT INTO job_def ( JOB_NAME,JOB_TYPE,SCRIPT_NAME,SCRIPT_TYPE,UNIQUE_RUN, DELTAJOB,DELTASCRIPT,VALID_FROM,VALID_TO,mod_timestamp)
VALUES ('UTL_TEMPLATE','utl','utl_template','hpl','Y','N',NULL,'1900-01-01 00:00:00','3000-12-31 00:00:00', CURRENT_TIMESTAMP )
ON DUPLICATE KEY UPDATE
        script_name = VALUES(script_name),
        script_type = VALUES(script_type),
        unique_run = VALUES(unique_run),
        deltajob   = VALUES(deltajob),
        deltascript = VALUES(deltascript),
        mod_timestamp = CURRENT_TIMESTAMP;

