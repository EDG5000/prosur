-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION postgres;

COMMENT ON SCHEMA public IS 'standard public schema';
-- public.job_file definition

-- Drop table

-- DROP TABLE public.job_file;

CREATE TABLE public.job_file (
	"name" varchar NOT NULL,
	modified int8 NOT NULL, -- File modification datetime. Unix timestamp (UTC; seconds since Unix epoch)
	"data" bytea NOT NULL,
	CONSTRAINT file_pk PRIMARY KEY (name)
);

-- Column comments

COMMENT ON COLUMN public.job_file.modified IS 'File modification datetime. Unix timestamp (UTC; seconds since Unix epoch)';

-- Permissions

ALTER TABLE public.job_file OWNER TO postgres;
GRANT ALL ON TABLE public.job_file TO postgres;


-- public.job_parameter definition

-- Drop table

-- DROP TABLE public.job_parameter;

CREATE TABLE public.job_parameter (
	"key" text NOT NULL, -- Compound key is formed together with the job_id column.
	value text NOT NULL,
	job_id int4 NOT NULL,
	CONSTRAINT job_parameter_pk PRIMARY KEY (job_id, key)
);

-- Column comments

COMMENT ON COLUMN public.job_parameter."key" IS 'Compound key is formed together with the job_id column.';

-- Permissions

ALTER TABLE public.job_parameter OWNER TO postgres;
GRANT ALL ON TABLE public.job_parameter TO postgres;


-- public.frame definition

-- Drop table

-- DROP TABLE public.frame;

CREATE TABLE public.frame (
	"time" int8 NOT NULL, -- Unix time (UTC; seconds since Unix epoch)
	job_file_name text NULL, -- Must be provided in first frame recorded after transitioning to printing state. Point to a file blob in file table using filename. Must contain all data needed to start print job. May optionally contain one or more sources meshes embedded as comment/attachment using whatever method the file format allows. (in case of GCODE, base64 encoded gzipped 3mf data added as a comment is suggested)
	job_id int4 NULL, -- Must be supplied when printing. Must be a unix-epoch timestamp indicating job start time. Must be foreign key pointing to first collected record when job was started.
	temp_aux_7 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_6 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_5 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_4 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_3 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_2 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_1 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_0 float4 NULL, -- CPU/MCU; Degrees Celcius.
	pos_motor_0 float4 NULL, -- mm
	pos_motor_1 float4 NULL, -- mm
	pos_motor_2 float4 NULL, -- mm
	pos_motor_3 float4 NULL, -- mm
	print_progress_percentage float4 NULL, -- %
	print_layers_printed int4 NULL,
	print_layers_total int4 NULL,
	temp_cpu_0 float4 NULL, -- CPU/MCU; Degrees Celcius.
	speed_requested_mms float4 NULL, -- mm/s
	speed_current_mms float4 NULL, -- mm/s
	voltage int4 NULL, -- Hundreds of volts
	probe_0 int4 NULL, -- Value depending on implementation. Refer to relevant probe state constants.
	endstop_0 int4 NULL, -- For endstops, suggest using as 1=triggered. 0=not triggered.
	filament_used float4 NULL, -- mm
	still_0 bytea NULL, -- JPEG image taken at frame.time
	vin_0 float4 NULL, -- Input voltage to board
	endstop_1 int4 NULL,
	endstop_2 int4 NULL,
	temp_heater_0 float4 NULL,
	temp_heater_1 float4 NULL,
	temp_heater_2 float4 NULL,
	CONSTRAINT frames_pk PRIMARY KEY ("time"),
	CONSTRAINT frame_fk FOREIGN KEY (job_file_name) REFERENCES public.job_file("name") ON DELETE RESTRICT ON UPDATE RESTRICT
);
COMMENT ON TABLE public.frame IS 'CPU''s, such as those present on MCU''s and SOC''s.';

-- Column comments

COMMENT ON COLUMN public.frame."time" IS 'Unix time (UTC; seconds since Unix epoch)';
COMMENT ON COLUMN public.frame.job_file_name IS 'Must be provided in first frame recorded after transitioning to printing state. Point to a file blob in file table using filename. Must contain all data needed to start print job. May optionally contain one or more sources meshes embedded as comment/attachment using whatever method the file format allows. (in case of GCODE, base64 encoded gzipped 3mf data added as a comment is suggested)';
COMMENT ON COLUMN public.frame.job_id IS 'Must be supplied when printing. Must be a unix-epoch timestamp indicating job start time. Must be foreign key pointing to first collected record when job was started.';
COMMENT ON COLUMN public.frame.temp_aux_7 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_6 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_5 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_4 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_3 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_2 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_1 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_0 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.pos_motor_0 IS 'mm';
COMMENT ON COLUMN public.frame.pos_motor_1 IS 'mm';
COMMENT ON COLUMN public.frame.pos_motor_2 IS 'mm';
COMMENT ON COLUMN public.frame.pos_motor_3 IS 'mm';
COMMENT ON COLUMN public.frame.print_progress_percentage IS '%';
COMMENT ON COLUMN public.frame.temp_cpu_0 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.speed_requested_mms IS 'mm/s';
COMMENT ON COLUMN public.frame.speed_current_mms IS 'mm/s';
COMMENT ON COLUMN public.frame.voltage IS 'Hundreds of volts';
COMMENT ON COLUMN public.frame.probe_0 IS 'Value depending on implementation. Refer to relevant probe state constants.';
COMMENT ON COLUMN public.frame.endstop_0 IS 'For endstops, suggest using as 1=triggered. 0=not triggered.';
COMMENT ON COLUMN public.frame.filament_used IS 'mm';
COMMENT ON COLUMN public.frame.still_0 IS 'JPEG image taken at frame.time';
COMMENT ON COLUMN public.frame.vin_0 IS 'Input voltage to board';

-- Permissions

ALTER TABLE public.frame OWNER TO postgres;
GRANT ALL ON TABLE public.frame TO postgres;




-- Permissions

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

-- Drop table

-- DROP TABLE public.frame;

CREATE TABLE public.frame (
	"time" int8 NOT NULL, -- Unix time (UTC; seconds since Unix epoch)
	job_file_name text NULL, -- Must be provided in first frame recorded after transitioning to printing state. Point to a file blob in file table using filename. Must contain all data needed to start print job. May optionally contain one or more sources meshes embedded as comment/attachment using whatever method the file format allows. (in case of GCODE, base64 encoded gzipped 3mf data added as a comment is suggested)
	job_id int4 NULL, -- Must be supplied when printing. Must be a unix-epoch timestamp indicating job start time. Must be foreign key pointing to first collected record when job was started.
	temp_aux_7 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_6 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_5 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_4 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_3 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_2 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_1 float4 NULL, -- CPU/MCU; Degrees Celcius.
	temp_aux_0 float4 NULL, -- CPU/MCU; Degrees Celcius.
	pos_motor_0 float4 NULL, -- mm
	pos_motor_1 float4 NULL, -- mm
	pos_motor_2 float4 NULL, -- mm
	pos_motor_3 float4 NULL, -- mm
	print_progress_percentage float4 NULL, -- %
	print_layers_printed int4 NULL,
	print_layers_total int4 NULL,
	temp_cpu_0 float4 NULL, -- CPU/MCU; Degrees Celcius.
	speed_requested_mms float4 NULL, -- mm/s
	speed_current_mms float4 NULL, -- mm/s
	voltage int4 NULL, -- Hundreds of volts
	probe_0 int4 NULL, -- Value depending on implementation. Refer to relevant probe state constants.
	endstop_0 int4 NULL, -- For endstops, suggest using as 1=triggered. 0=not triggered.
	filament_used float4 NULL, -- mm
	still_0 bytea NULL, -- JPEG image taken at frame.time
	vin_0 float4 NULL, -- Input voltage to board
	endstop_1 int4 NULL,
	endstop_2 int4 NULL,
	temp_heater_0 float4 NULL,
	temp_heater_1 float4 NULL,
	temp_heater_2 float4 NULL,
	CONSTRAINT frames_pk PRIMARY KEY ("time"),
	CONSTRAINT frame_fk FOREIGN KEY (job_file_name) REFERENCES public.job_file("name") ON DELETE RESTRICT ON UPDATE RESTRICT
);
COMMENT ON TABLE public.frame IS 'CPU''s, such as those present on MCU''s and SOC''s.';

-- Column comments

COMMENT ON COLUMN public.frame."time" IS 'Unix time (UTC; seconds since Unix epoch)';
COMMENT ON COLUMN public.frame.job_file_name IS 'Must be provided in first frame recorded after transitioning to printing state. Point to a file blob in file table using filename. Must contain all data needed to start print job. May optionally contain one or more sources meshes embedded as comment/attachment using whatever method the file format allows. (in case of GCODE, base64 encoded gzipped 3mf data added as a comment is suggested)';
COMMENT ON COLUMN public.frame.job_id IS 'Must be supplied when printing. Must be a unix-epoch timestamp indicating job start time. Must be foreign key pointing to first collected record when job was started.';
COMMENT ON COLUMN public.frame.temp_aux_7 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_6 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_5 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_4 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_3 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_2 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_1 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.temp_aux_0 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.pos_motor_0 IS 'mm';
COMMENT ON COLUMN public.frame.pos_motor_1 IS 'mm';
COMMENT ON COLUMN public.frame.pos_motor_2 IS 'mm';
COMMENT ON COLUMN public.frame.pos_motor_3 IS 'mm';
COMMENT ON COLUMN public.frame.print_progress_percentage IS '%';
COMMENT ON COLUMN public.frame.temp_cpu_0 IS 'CPU/MCU; Degrees Celcius.';
COMMENT ON COLUMN public.frame.speed_requested_mms IS 'mm/s';
COMMENT ON COLUMN public.frame.speed_current_mms IS 'mm/s';
COMMENT ON COLUMN public.frame.voltage IS 'Hundreds of volts';
COMMENT ON COLUMN public.frame.probe_0 IS 'Value depending on implementation. Refer to relevant probe state constants.';
COMMENT ON COLUMN public.frame.endstop_0 IS 'For endstops, suggest using as 1=triggered. 0=not triggered.';
COMMENT ON COLUMN public.frame.filament_used IS 'mm';
COMMENT ON COLUMN public.frame.still_0 IS 'JPEG image taken at frame.time';
COMMENT ON COLUMN public.frame.vin_0 IS 'Input voltage to board';

-- Permissions

ALTER TABLE public.frame OWNER TO postgres;
GRANT ALL ON TABLE public.frame TO postgres;

-- Drop table

-- DROP TABLE public.job_file;

CREATE TABLE public.job_file (
	"name" varchar NOT NULL,
	modified int8 NOT NULL, -- File modification datetime. Unix timestamp (UTC; seconds since Unix epoch)
	"data" bytea NOT NULL,
	CONSTRAINT file_pk PRIMARY KEY (name)
);

-- Column comments

COMMENT ON COLUMN public.job_file.modified IS 'File modification datetime. Unix timestamp (UTC; seconds since Unix epoch)';

-- Permissions

ALTER TABLE public.job_file OWNER TO postgres;
GRANT ALL ON TABLE public.job_file TO postgres;

-- Drop table

-- DROP TABLE public.job_parameter;

CREATE TABLE public.job_parameter (
	"key" text NOT NULL, -- Compound key is formed together with the job_id column.
	value text NOT NULL,
	job_id int4 NOT NULL,
	CONSTRAINT job_parameter_pk PRIMARY KEY (job_id, key)
);

-- Column comments

COMMENT ON COLUMN public.job_parameter."key" IS 'Compound key is formed together with the job_id column.';

-- Permissions

ALTER TABLE public.job_parameter OWNER TO postgres;
GRANT ALL ON TABLE public.job_parameter TO postgres;