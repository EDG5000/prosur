--
-- PostgreSQL database dump
--

-- Dumped from database version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)

-- Started on 2021-12-11 18:29:14 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 2974 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 16392)
-- Name: file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.file (
    name character varying NOT NULL,
    modified bigint NOT NULL,
    data bytea NOT NULL
);


ALTER TABLE public.file OWNER TO postgres;

--
-- TOC entry 2975 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN file.modified; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.file.modified IS 'File modification datetime. Unix timestamp (UTC; seconds since Unix epoch)';


--
-- TOC entry 202 (class 1259 OID 16384)
-- Name: frame; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.frame (
    "time" bigint NOT NULL,
    file_name text,
    job_id integer,
    temp_aux_7 integer,
    temp_aux_6 integer,
    temp_aux_5 integer,
    temp_aux_4 integer,
    temp_aux_3 integer,
    temp_aux_2 integer,
    temp_aux_1 integer,
    temp_aux_0 integer,
    temp_extruder_0 integer,
    temp_bed_0 integer,
    temp_chamber_0 integer,
    pos_motor_0 integer,
    pos_motor_1 integer,
    pos_motor_2 integer,
    pos_motor_3 integer,
    print_progress_percentage integer,
    print_layers_printed integer,
    print_layers_remaining integer,
    temp_cpu_0 integer,
    temp_cpu_1 integer,
    speed_requested_mms integer,
    speed_current_mms integer,
    voltage integer,
    probe_z integer,
    probe_x integer,
    filament_used integer
);


ALTER TABLE public.frame OWNER TO postgres;

--
-- TOC entry 2976 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE frame; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.frame IS 'CPU''s, such as those present on MCU''s and SOC''s.';


--
-- TOC entry 2977 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame."time"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame."time" IS 'Unix time (UTC; seconds since Unix epoch)';


--
-- TOC entry 2978 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.file_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.file_name IS 'Must be provided in first frame recorded after transitioning to printing state. Point to a file blob in file table using filename. Must contain all data needed to start print job. May optionally contain one or more sources meshes embedded as comment/attachment using whatever method the file format allows. (in case of GCODE, base64 encoded gzipped 3mf data added as a comment is suggested)';


--
-- TOC entry 2979 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.job_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.job_id IS 'Must be supplied when printing. Must be a unix-epoch timestamp indicating job start time. Must be foreign key pointing to first collected record when job was started.';


--
-- TOC entry 2980 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_aux_7; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_aux_7 IS 'Hundreds of degrees celcius.';


--
-- TOC entry 2981 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_aux_6; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_aux_6 IS 'Hundreds of degrees celcius.';


--
-- TOC entry 2982 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_aux_5; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_aux_5 IS 'Hundreds of degrees celcius.';


--
-- TOC entry 2983 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_aux_4; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_aux_4 IS 'Hundreds of degrees celcius.';


--
-- TOC entry 2984 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_aux_3; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_aux_3 IS 'Hundreds of degrees celcius.';


--
-- TOC entry 2985 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_aux_2; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_aux_2 IS 'Hundreds of degrees celcius.';


--
-- TOC entry 2986 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_aux_1; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_aux_1 IS 'Hundreds of degrees celcius.';


--
-- TOC entry 2987 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_aux_0; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_aux_0 IS 'Hundreds of degrees celcius.';


--
-- TOC entry 2988 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_extruder_0; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_extruder_0 IS 'Hundreds of degrees celcius.';


--
-- TOC entry 2989 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_bed_0; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_bed_0 IS 'Hundreds of degrees celcius.';


--
-- TOC entry 2990 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_chamber_0; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_chamber_0 IS 'Hundreds of degrees celcius.';


--
-- TOC entry 2991 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.pos_motor_0; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.pos_motor_0 IS 'Hundreds of mm';


--
-- TOC entry 2992 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.pos_motor_1; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.pos_motor_1 IS 'Hundreds of mm';


--
-- TOC entry 2993 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.pos_motor_2; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.pos_motor_2 IS 'Hundreds of mm';


--
-- TOC entry 2994 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.pos_motor_3; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.pos_motor_3 IS 'Hundreds of mm';


--
-- TOC entry 2995 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.print_progress_percentage; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.print_progress_percentage IS 'Hundreds of %';


--
-- TOC entry 2996 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_cpu_0; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_cpu_0 IS 'CPU''s, such as those present on MCU''s and SOC''s.; Hundreds of degrees celcius.';


--
-- TOC entry 2997 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.temp_cpu_1; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.temp_cpu_1 IS 'CPU''s, such as those present on MCU''s and SOC''s.; Hundreds of degrees celcius.';


--
-- TOC entry 2998 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.speed_requested_mms; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.speed_requested_mms IS 'Hundreds of mm/s';


--
-- TOC entry 2999 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.speed_current_mms; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.speed_current_mms IS 'Hundreds of mm/s';


--
-- TOC entry 3000 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.voltage; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.voltage IS 'Hundreds of volts';


--
-- TOC entry 3001 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.probe_z; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.probe_z IS 'Value depending on implementation. Refer to relevant probe state constants.';


--
-- TOC entry 3002 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.probe_x; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.probe_x IS 'For endstops: 1=triggered. 0=not triggered.';


--
-- TOC entry 3003 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN frame.filament_used; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.frame.filament_used IS 'Hundreds of mm.';


--
-- TOC entry 2968 (class 0 OID 16392)
-- Dependencies: 203
-- Data for Name: file; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.file (name, modified, data) FROM stdin;
\.


--
-- TOC entry 2967 (class 0 OID 16384)
-- Dependencies: 202
-- Data for Name: frame; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.frame ("time", file_name, job_id, temp_aux_7, temp_aux_6, temp_aux_5, temp_aux_4, temp_aux_3, temp_aux_2, temp_aux_1, temp_aux_0, temp_extruder_0, temp_bed_0, temp_chamber_0, pos_motor_0, pos_motor_1, pos_motor_2, pos_motor_3, print_progress_percentage, print_layers_printed, print_layers_remaining, temp_cpu_0, temp_cpu_1, speed_requested_mms, speed_current_mms, voltage, probe_z, probe_x, filament_used) FROM stdin;
\.


--
-- TOC entry 2839 (class 2606 OID 16399)
-- Name: file file_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file
    ADD CONSTRAINT file_pk PRIMARY KEY (name);


--
-- TOC entry 2837 (class 2606 OID 16432)
-- Name: frame frames_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.frame
    ADD CONSTRAINT frames_pk PRIMARY KEY ("time");


--
-- TOC entry 2840 (class 2606 OID 16405)
-- Name: frame frame_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.frame
    ADD CONSTRAINT frame_fk FOREIGN KEY (file_name) REFERENCES public.file(name) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- Completed on 2021-12-11 18:29:14 CET

--
-- PostgreSQL database dump complete
--

