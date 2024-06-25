--
-- PostgreSQL database dump
--

-- Dumped from database version 12.18 (Ubuntu 12.18-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.18 (Ubuntu 12.18-0ubuntu0.20.04.1)

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
-- Name: uuid(); Type: FUNCTION; Schema: public; Owner: agrotech
--

CREATE FUNCTION public.uuid() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    BEGIN
		RETURN (SELECT uuid_in(overlay(overlay(md5(random()::text || ':' || clock_timestamp()::text) placing '4' from 13) placing to_hex(floor(random()*(11-8+1) + 8)::int)::text from 17)::cstring));
    END;
$$;


ALTER FUNCTION public.uuid() OWNER TO agrotech;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: file_detail; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.file_detail (
    oid character varying(128) NOT NULL,
    file_url character varying(128) NOT NULL,
    loaded_file_name character varying(128) NOT NULL,
    file_size_in_bytes character varying(128) NOT NULL,
    file_type character varying(128) NOT NULL,
    file_extension character varying(128) NOT NULL,
    hash_value character varying(128),
    status character varying(128) DEFAULT 'Unused'::character varying NOT NULL,
    added_by character varying(128),
    added_on timestamp without time zone,
    product_oid character varying(128)
);


ALTER TABLE public.file_detail OWNER TO agrotech;

--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO agrotech;

--
-- Name: login; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.login (
    oid character varying(128) NOT NULL,
    user_id character varying(128) NOT NULL,
    password character varying(256) NOT NULL,
    user_name character varying(256) NOT NULL,
    user_name_bn character varying(256),
    email character varying(256) NOT NULL,
    mobile_number character varying(256) NOT NULL,
    address text,
    reset_required character varying(256),
    status character varying(128) NOT NULL,
    created_by character varying(128) DEFAULT 'System'::character varying NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    edited_by character varying(128),
    edited_on timestamp without time zone,
    role_oid character varying(128),
    CONSTRAINT ck_status_login CHECK ((((status)::text = 'Active'::text) OR ((status)::text = 'Inactive'::text)))
);


ALTER TABLE public.login OWNER TO agrotech;

--
-- Name: login_log; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.login_log (
    oid character varying(128) NOT NULL,
    user_id character varying(128) NOT NULL,
    access_token text NOT NULL,
    refresh_token text,
    signin_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    sign_out_time timestamp without time zone,
    status character varying(128) DEFAULT 'Signin'::character varying,
    CONSTRAINT ck_status_login_log CHECK ((((status)::text = 'Signin'::text) OR ((status)::text = 'Signout'::text)))
);


ALTER TABLE public.login_log OWNER TO agrotech;

--
-- Name: product; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.product (
    oid character varying(128) NOT NULL,
    product_id character varying(128) NOT NULL,
    product_title_bn character varying(128) NOT NULL,
    product_title_en character varying(128) NOT NULL,
    unit_price numeric NOT NULL,
    stock numeric NOT NULL,
    description text NOT NULL,
    status character varying(128) DEFAULT 'Active'::character varying NOT NULL,
    created_by character varying(128) NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    edited_by character varying(128),
    edited_on timestamp without time zone,
    product_category_oid character varying NOT NULL,
    unit_type_oid character varying NOT NULL
);


ALTER TABLE public.product OWNER TO agrotech;

--
-- Name: product_attribute; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.product_attribute (
    oid character varying(128) NOT NULL,
    product_attribute_id character varying(128) NOT NULL,
    product_attribute_title_bn character varying(128) NOT NULL,
    product_attribute_title_en character varying(128) NOT NULL,
    value_bn character varying NOT NULL,
    value_en character varying NOT NULL,
    status character varying(128) DEFAULT 'Active'::character varying NOT NULL,
    created_by character varying(128) NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    edited_by character varying(128),
    edited_on timestamp without time zone,
    product_oid character varying NOT NULL
);


ALTER TABLE public.product_attribute OWNER TO agrotech;

--
-- Name: product_category; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.product_category (
    oid character varying(128) NOT NULL,
    product_category_id character varying(128) NOT NULL,
    product_category_bn character varying(128) NOT NULL,
    product_category_en character varying(128) NOT NULL,
    description text,
    status character varying(128) DEFAULT 'Active'::character varying NOT NULL,
    created_by character varying(128) NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    edited_by character varying(128),
    edited_on timestamp without time zone,
    product_type_oid character varying NOT NULL
);


ALTER TABLE public.product_category OWNER TO agrotech;

--
-- Name: product_order; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.product_order (
    oid character varying(128) NOT NULL,
    product_order_id character varying(128) NOT NULL,
    order_by character varying(128) NOT NULL,
    total_amount numeric NOT NULL,
    description text,
    status character varying(128) DEFAULT 'Submitted'::character varying NOT NULL,
    created_by character varying(128) NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    edited_by character varying(128),
    edited_on timestamp without time zone
);


ALTER TABLE public.product_order OWNER TO agrotech;

--
-- Name: product_order_detail; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.product_order_detail (
    oid character varying(128) NOT NULL,
    order_detail_id character varying(128) NOT NULL,
    product_order_oid character varying(128) NOT NULL,
    product_oid character varying(128) NOT NULL,
    unit_type_oid character varying(128) NOT NULL,
    unit_price numeric NOT NULL,
    quantity numeric NOT NULL,
    total_amount numeric NOT NULL,
    description text,
    status character varying(128) DEFAULT 'Submitted'::character varying NOT NULL,
    created_by character varying(128) NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    edited_by character varying(128),
    edited_on timestamp without time zone
);


ALTER TABLE public.product_order_detail OWNER TO agrotech;

--
-- Name: product_type; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.product_type (
    oid character varying(128) NOT NULL,
    product_type_id character varying(128) NOT NULL,
    product_type_bn character varying(128) NOT NULL,
    product_type_en character varying(128) NOT NULL,
    description text,
    status character varying(128) DEFAULT 'Active'::character varying NOT NULL,
    created_by character varying(128) NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    edited_by character varying(128),
    edited_on timestamp without time zone
);


ALTER TABLE public.product_type OWNER TO agrotech;

--
-- Name: role; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.role (
    oid character varying(128) NOT NULL,
    role_name character varying(128) NOT NULL,
    role_name_bn character varying(128) NOT NULL,
    status character varying(32) NOT NULL,
    role_description text,
    web_json text DEFAULT '[]'::text NOT NULL,
    api_json text DEFAULT '[]'::text NOT NULL,
    CONSTRAINT ck_status_role CHECK ((((status)::text = 'Active'::text) OR ((status)::text = 'Inactive'::text)))
);


ALTER TABLE public.role OWNER TO agrotech;

--
-- Name: unit_type; Type: TABLE; Schema: public; Owner: agrotech
--

CREATE TABLE public.unit_type (
    oid character varying(128) NOT NULL,
    unit_type_id character varying(128) NOT NULL,
    unit_type_bn character varying(128) NOT NULL,
    unit_type_en character varying(128) NOT NULL,
    description text,
    status character varying(128) DEFAULT 'Active'::character varying NOT NULL,
    created_by character varying(128) NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    edited_by character varying(128),
    edited_on timestamp without time zone
);


ALTER TABLE public.unit_type OWNER TO agrotech;

--
-- Data for Name: file_detail; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.file_detail (oid, file_url, loaded_file_name, file_size_in_bytes, file_type, file_extension, hash_value, status, added_by, added_on, product_oid) FROM stdin;
e7957257-5bb7-40b1-9ff8-f61476e467b5	3105d729-b5b5-409f-abdd-c1120e7a3135.jpg	rice.jpg	81708	.jpg	.jpg	5f8049707988d225c3233b15e8ce728d4fd87550bb45e849e0a5212be47d95cb	Used	LN-USER-0000041	2024-02-29 13:09:58	7f682484-cacb-4440-95ae-aca7721566ce
7f8fe5bf-0d76-42ad-8b91-7464652ba0ff	0d344fb9-1113-444b-93de-f51042380f8f.jpeg	kilijira_rice.jpeg	7983	.jpeg	.jpeg	4af834a0568d0ca2fae6c41c2a42707cdd0fa50d44e64802804c381fa4efcad2	Used	LN-USER-0000041	2024-03-11 13:05:05	46154a8c-3919-4b99-afd2-2c76d67339c0
b4a0e2c4-93f4-4b53-a589-11b155555912	4fd002a9-cb97-4285-83d7-e10ca0b3a419.jpeg	najirshail.jpeg	5495	.jpeg	.jpeg	7c8e5d0f6cb08376e62c33c902705966b12d3fe6b840cfd20974916288c3e475	Used	LN-USER-0000041	2024-03-11 13:11:11	108e359c-55c7-432a-ba21-cdfc79bfb5db
87ddbb5d-55b6-4fe5-9b55-fd71d78d9fcf	4261ad5b-db8d-4d6a-b8c8-8eb8d257a1bb.jpeg	bashful.jpeg	9682	.jpeg	.jpeg	996a5c4c36d2a51a093fa8667284b3ba275c7f0f5f3ebe246132e8716be9310f	Used	LN-USER-0000041	2024-03-11 13:14:16	61569486-fb80-4c1a-af26-4831789e6e3e
00f67578-57b9-4e06-973c-58e022fa2399	bf59b925-be6e-4170-83ea-4af39a4af0f9.jpeg	bashmoti.jpeg	10649	.jpeg	.jpeg	375339304ea459afd03f3c7ca4e9527e3ad795c4adf4d40aad51ae22ef7597e4	Used	LN-USER-0000041	2024-03-11 13:17:57	40aa7907-173c-44bc-84a0-d4a08bb5b9d1
01663edf-312f-4e79-b72e-599dec45a286	6d105608-75f5-490f-99ed-3fbc2a1d265d.jpeg	lalboro-rice.jpeg	7221	.jpeg	.jpeg	4134a3abdb271329068a062efe802b92490f81389ecefefd8ee0c8143176b9b9	Used	LN-USER-0000041	2024-03-11 13:25:58	4a7fe85d-9981-458b-baa6-f37de591445f
8a8bfced-8a1f-43c1-b0eb-519435141ad4	03d619d1-d983-4c1c-8e77-eed29d25e53e.jpeg	lentil.jpeg	11992	.jpeg	.jpeg	8c836acc8341bc49a9cb8a5820bdba25047730dd99531ebf7db7b317cf94b883	Used	LN-USER-0000041	2024-03-11 14:40:06	c7cea0f5-64d4-460e-8ea2-7fb24d2e0ba3
4baeb9a7-df85-47a6-a74b-b34655430b8e	cdedb4c2-227e-4d3c-8517-85f623242ccf.jpg	moong-dal.jpg	346167	.jpg	.jpg	c98d6651c23da44791d66bd4439c70e709fdd36a75cd5dad5fd22a3b958272c8	Used	LN-USER-0000041	2024-03-11 14:49:33	ab44ed3c-c33b-4615-a258-20d3581813c0
5bda4e83-1f31-4f54-b6f6-04073de970ca	1e9dcf56-eab9-43a7-aded-017a9d203da3.ico	favicon.ico	10459	.ico	.ico	57c68a23e3628ba06f6383f088353dea297d3470ecbb9504a3fcaed196f2c9bc	Unused	LN-USER-0000041	2024-03-24 11:23:33.277901	\N
540bc71f-b7a4-4593-9390-b7abb76c645e	af75ecf1-3e41-470c-97fe-95913ac515fc.png	22a467ba-fdfb-4646-86f8-9f8a718fbef0.png	3102	.png	.png	e5d65a7198eb2a0dea16417ccac55b4ad70d6012ec18aa78c0965c8f95dda174	Used	LN-USER-0000041	2024-03-24 11:23:42.683117	d7741928-8f0f-4a66-84de-507688d243ff
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	\N	01 00 00  security	SQL	00-settings/R__01_00_00__security.sql	-178577943	agrotech	2024-03-11 15:31:38.63202	33	t
2	\N	01 01 01  product	SQL	01-product/R__01_01_01__product.sql	67522441	agrotech	2024-03-11 15:31:38.68687	86	t
3	\N	01 01 02  product order	SQL	01-product/R__01_01_02__product_order.sql	-1178871738	agrotech	2024-03-11 15:31:38.787654	24	t
4	\N	07 00 00  security	SQL	00-settings/R__07_00_00__security.sql	313621802	agrotech	2024-03-11 15:31:38.839617	13	t
5	\N	07 01 01  product	SQL	01-product/R__07_01_01__product.sql	893586166	agrotech	2024-03-11 15:31:38.912773	53	t
\.


--
-- Data for Name: login; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.login (oid, user_id, password, user_name, user_name_bn, email, mobile_number, address, reset_required, status, created_by, created_on, edited_by, edited_on, role_oid) FROM stdin;
LN-USER-0000041	humayun.kabir	$2a$10$cKDMskogKg2Af0kUPM5d0eFG.SR5OywqKzmEJorLMLJQTbBEuXphq	Humayun Kabir	হুমায়ুন কবির	kabir.humayun@doer.com.bd	01927040075	\N	No	Active	System	2024-03-11 15:31:38.832999	\N	\N	AD-00001
LN-USER-0000042	rashida.akter	$2a$10$a5aCRphLznEFLYUqxz05w.WRj/Pj17RK5lo22WM5PE0zRnsdTtvIu	Rashida Akter	রাশিদা আক্তার	rashida.akter@doer.com.bd	01643862402	\N	No	Active	System	2024-03-11 15:31:38.832999	\N	\N	NU-00001
LN-USER-0000043	robin.das	$2a$10$HaVQROzKd.EV.u9BYxw.lO.M1qn0MeuEXa8qe47XAMQy5jU7KVbE.	Robin Das	রবিন দাস	robin.das@doer.com.bd	01843684994	\N	No	Active	System	2024-03-11 15:31:38.832999	\N	\N	MN-00001
c31f277e-4667-49b1-b695-00825cc2a69c	test.test	$2a$10$54dIJgPMW/bEyspyWqCzG.sYDIzp6aLyI9eGGnPRKkHJnuq0MU8R6	test	test	test	test	test	No	Active	USER	2024-03-12 10:26:58.422732	\N	\N	NU-00001
\.


--
-- Data for Name: login_log; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.login_log (oid, user_id, access_token, refresh_token, signin_time, sign_out_time, status) FROM stdin;
LOGIN-LOG-0001	chat.bot	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiY2hhdC5ib3QiLCJyb2xlIjoiQ0FMTCBDRU5URVIgQUdFTlQiLCJsb2dpbl9vaWQiOiJDQi1DQ0UtMDAwMDEiLCJpYXQiOjE2NTkxNjExMDQsImV4cCI6MTY1OTI0NzUwNH0.IKpmH6kR-GUJeoJuI-oTMD19anmJkSNrjDlkh_5m_Qc	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiY2hhdC5ib3QiLCJyb2xlIjoiQ0FMTCBDRU5URVIgQUdFTlQiLCJsb2dpbl9vaWQiOiJDQi1DQ0UtMDAwMDEiLCJpYXQiOjE2NTkxNjExMDQsImV4cCI6MTY1OTU5MzEwNH0.qT7wJOWmLmlhBTWrSzuJHtBJNu2vqjm2esUXhg5pKkE	2022-07-30 11:34:46	2025-07-31 11:34:46	Signin
24c9bf52-c939-43f1-be30-d87b17e8cbd3	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDE0OTYwNSwiZXhwIjoxNzEwMjM2MDA1fQ.pe2KLwO8nUbJjIggneCjZowqYNWlCJolVbw1MgVWGzE	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDE0OTYwNSwiZXhwIjoxNzEwNTgxNjA1fQ.O8CvyhZYkiRnHeXGFECakbUX8Sd00EmoM6dVl6H6dzk	2024-03-11 15:33:25.546459	2024-03-12 15:33:25.546459	Signin
a62f2f1f-2b0b-436f-a699-93920cfa02b2	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDE0OTYxNCwiZXhwIjoxNzEwMjM2MDE0fQ.4MKZtMsWtqP-8_wAKx-3HnPADqRaoHJMQjwqHFPu83E	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDE0OTYxNCwiZXhwIjoxNzEwNTgxNjE0fQ.x2gXZ4WENFm_DMFJlrP8FgydkDhK6hNaFryfYhjHrV0	2024-03-11 15:33:34.364273	2024-03-12 15:33:34.364274	Signin
95fd863f-1f6c-47f4-9a0d-b78af881bbd3	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDE0OTYxNiwiZXhwIjoxNzEwMjM2MDE2fQ.vBiQu8vMdO9QftEC8iMs6XAC10N-B84u5pb3ZqPbO1g	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDE0OTYxNiwiZXhwIjoxNzEwNTgxNjE2fQ.2oKCyUn7Z7-ZEQ6_2rsCXKntwg6nE_ddJtH7aMss5PQ	2024-03-11 15:33:36.720096	2024-03-12 15:33:36.720096	Signin
466ae7a9-bcd0-4588-8cd7-3674a3545780	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDE0OTYyMCwiZXhwIjoxNzEwMjM2MDIwfQ.SawAlIEhCr_2BobhW-_JxaV9bJpX4pzuDp7cbK4f8Xs	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDE0OTYyMCwiZXhwIjoxNzEwNTgxNjIwfQ.1pTniNQvAQHBZ3fVfn9KjrVsRF5lwcWtImoKr366zvw	2024-03-11 15:33:40.278917	2024-03-12 15:33:40.278918	Signin
4182b96a-1a2a-45fe-8d7c-cb07672b51ec	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTAxNDk2MjYsImV4cCI6MTcxMDIzNjAyNn0.aHJtGvXWTK0W0cjR5lxjKTJcRJDZ1M-7BiPanoBR-SI	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTAxNDk2MjYsImV4cCI6MTcxMDU4MTYyNn0.g8IHzOLEjMRFWoI4gVGBsfpRIhaP9pI6WLU3hyvXBBA	2024-03-11 15:33:46.986171	2024-03-12 15:33:46.986172	Signout
b09b3e51-667d-437f-9a11-029fea094caf	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDE0OTY1NSwiZXhwIjoxNzEwMjM2MDU1fQ.COzu6Prr29NtDeUsyI91kj2E9S57WEIwY1SXfTYNbkc	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDE0OTY1NSwiZXhwIjoxNzEwNTgxNjU1fQ.WC2iHmvC7BD9yo_fmFM8EV6ZobC_NCqss2_etENww1E	2024-03-11 15:34:15.391943	2024-03-12 15:34:15.391944	Signin
c5c1974d-9bcb-48a2-a67d-a6f89e31ca0c	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTAxNDk2NjMsImV4cCI6MTcxMDIzNjA2M30.OzMJS5Wxgrmf0spCzGjKj0VjURfV-PHkoFAeWi_nwCg	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTAxNDk2NjMsImV4cCI6MTcxMDU4MTY2M30.CUYVsfEBzQpVzO2OTG-lXhU3bpimGKrFl6W01SMek3A	2024-03-11 15:34:23.033962	2024-03-12 15:34:23.033963	Signin
2669f3dd-b6cd-48e6-ad24-a3957e781afb	test.test	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdC50ZXN0Iiwicm9sZSI6IlVzZXIiLCJsb2dpbl9vaWQiOiJjMzFmMjc3ZS00NjY3LTQ5YjEtYjY5NS0wMDgyNWNjMmE2OWMiLCJ1c2VyX25hbWUiOiJ0ZXN0IiwiaWF0IjoxNzEwMjE3NjM4LCJleHAiOjE3MTAzMDQwMzh9.aWJZ6M_n7Vof4Cjk5dQJoXy0KJw3EPZ4l6QHnOYdarI	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdC50ZXN0Iiwicm9sZSI6IlVzZXIiLCJsb2dpbl9vaWQiOiJjMzFmMjc3ZS00NjY3LTQ5YjEtYjY5NS0wMDgyNWNjMmE2OWMiLCJ1c2VyX25hbWUiOiJ0ZXN0IiwiaWF0IjoxNzEwMjE3NjM4LCJleHAiOjE3MTA2NDk2Mzh9.vf2Wwus2gMJgD1PTC1CQfT1bSfSS3ythPny8rR0cXQs	2024-03-12 10:27:18.666036	2024-03-13 10:27:18.666036	Signin
184a1294-2d11-4116-9bbe-216b74f13e7c	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDg0OTM0OCwiZXhwIjoxNzEwOTM1NzQ4fQ.bQgsokLr6HqASAPkso70d6MsEWW463_eXCGw_lWAOBA	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDg0OTM0OCwiZXhwIjoxNzExMjgxMzQ4fQ.nXk4O7JbT-NcWpbL2O7SoM9I_VKsLikzmpLY-fl25wM	2024-03-19 17:55:48.280357	2024-03-20 17:55:48.280359	Signin
d0823239-8c37-41c9-865e-e67195e73238	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA4NDkzNzIsImV4cCI6MTcxMDkzNTc3Mn0.3i119PSUjtEjDPYjlzrVo4Icye-_KD7oYtzMIrR6BRY	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA4NDkzNzIsImV4cCI6MTcxMTI4MTM3Mn0.h-Z4uAWmFTEJ-yNFqg1ZpZxLkQhaSUdxAgrvC77w_m4	2024-03-19 17:56:12.627572	2024-03-20 17:56:12.627572	Signin
ce1bcadd-2f87-44da-b648-242d5f649c06	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDg0OTQwNCwiZXhwIjoxNzEwOTM1ODA0fQ.s6_Ou7wfYilj9Rld30kTK-QxbNe6OWJqCk9kuQprqUI	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDg0OTQwNCwiZXhwIjoxNzExMjgxNDA0fQ.KBz69ci_yaQZJjil2MlK-294vLaXyPyDPYmtmnckgqk	2024-03-19 17:56:44.916136	2024-03-20 17:56:44.916137	Signin
9d89c740-b1da-40f6-8513-068ea1d83270	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA4NDk0ODksImV4cCI6MTcxMDkzNTg4OX0.u5VHHsO_4wrZYbPdEz1pZDU6rHsalvCV9XI4JkO-NPw	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA4NDk0ODksImV4cCI6MTcxMTI4MTQ4OX0.3Mmv84pwy_n1YdOeL0ac_2swRfKczErjIuonXBLwZVQ	2024-03-19 17:58:09.494741	2024-03-20 17:58:09.494741	Signout
97449738-c621-419c-b199-ce9bb5ce6a96	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDg1NzM4NywiZXhwIjoxNzEwOTQzNzg3fQ.hS-OBzEpPbRL4vSg4fbZ94A32igPXy8D2cH8Xcn15A4	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDg1NzM4NywiZXhwIjoxNzExMjg5Mzg3fQ.BwX6nHESeQbdBoeAGHAo7Q7P163xpes1adT-XECQCSg	2024-03-19 20:09:47.965713	2024-03-20 20:09:47.965714	Signin
7f76fedf-d89b-4ed0-b3d1-1a0d26cd1b22	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA4NTc0MjEsImV4cCI6MTcxMDk0MzgyMX0._KgqBe78l0Y5Pm58xXINoll_5u19o4Q7l7A6qw082g4	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA4NTc0MjEsImV4cCI6MTcxMTI4OTQyMX0.600akGAzFYDRt7Yz7EWwuimFsRU4WsB_jTR4sGUrzYU	2024-03-19 20:10:21.857073	2024-03-20 20:10:21.857074	Signout
f2298d4c-7bc7-43f0-8f76-4c01e7c51c0a	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDg1NzUwNywiZXhwIjoxNzEwOTQzOTA3fQ.uwLmYA2Y94yyPMg76l27aweZ7TPZqGwYlZFV9wMc3w4	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDg1NzUwNywiZXhwIjoxNzExMjg5NTA3fQ.TA7K7Mt7SOiWh5WO1zV78mu0hxc50VHzn_rcYHFMeu8	2024-03-19 20:11:47.455043	2024-03-20 20:11:47.455044	Signin
d37b62f8-665a-44d3-95d6-29246b7ee26e	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA4NTc1MjAsImV4cCI6MTcxMDk0MzkyMH0.suYFcB4wC2iw-7w7eSQtQdskIHTvk5GULQY9toGha1Y	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA4NTc1MjAsImV4cCI6MTcxMTI4OTUyMH0.T810-f0Ddr33wYvDatu7i_Njsz9Pd2A3PLMkmFvYyBk	2024-03-19 20:12:00.932656	2024-03-20 20:12:00.932656	Signout
0ded7ef7-9a05-4a6f-ae34-1a204db73017	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDg1NzU0OCwiZXhwIjoxNzEwOTQzOTQ4fQ.qDpSOBtpik7LI9qCdd1Uy1_d7ZXtDz76nrHdxymHdP0	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDg1NzU0OCwiZXhwIjoxNzExMjg5NTQ4fQ.igZ6PrI8lIyMyUoNAhGnNG3gR1sOPfOH-xxRvtV9ph8	2024-03-19 20:12:28.832495	2024-03-20 20:12:28.832496	Signin
dcce5868-2fad-43db-9eda-2dc12a6a4048	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDkwOTE3MiwiZXhwIjoxNzEwOTk1NTcyfQ.IDiPruaUdBHZySr7XK8w_u4dl-X6RDvLkP-b435elZE	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDkwOTE3MiwiZXhwIjoxNzExMzQxMTcyfQ.cKE4_7j-FxtziMPzgQ-66-wkAYKD49UTI0GC8_gTYSM	2024-03-20 10:32:52.862745	2024-03-21 10:32:52.862745	Signin
76d1738f-48ed-439d-98ef-8f50b433804f	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA5MDkxOTIsImV4cCI6MTcxMDk5NTU5Mn0.9loebZ5z_jOq-KL_1SeKLlyvdObF5mgXA3z4_Nte3o8	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA5MDkxOTIsImV4cCI6MTcxMTM0MTE5Mn0.T6bHFCqVSe-f36DPIA5oq3Tw_FOd6eyG5f3nCTcOhCQ	2024-03-20 10:33:12.545199	2024-03-21 10:33:12.5452	Signout
8b0d8cf1-e065-4cbf-9c57-972609990a84	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDkwOTIyMSwiZXhwIjoxNzEwOTk1NjIxfQ.NIHXjpu9F7r_WKNXdisl3W_OJ5_bA8a85w1Yi_75peI	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDkwOTIyMSwiZXhwIjoxNzExMzQxMjIxfQ.AyjFGp7CYcp0vDQUaA5VrIEPqEtoILACZJSKiIg3dVo	2024-03-20 10:33:41.204142	2024-03-21 10:33:41.204143	Signin
b6cc6390-0c98-4311-b0a4-7c0570f12e38	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA5MDkyNTksImV4cCI6MTcxMDk5NTY1OX0.MAI8hb6CYCLkNf1BItu-xn6m4eCba_CxX-E23EXuxBw	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTA5MDkyNTksImV4cCI6MTcxMTM0MTI1OX0.S3zivo50apxnK4TMTpsMlcQEwvnpgjqanc4DA9L9NO4	2024-03-20 10:34:19.118306	2024-03-21 10:34:19.118307	Signout
d251db53-2f5e-481c-bc3b-ccd2624c2066	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDkxMDM0MiwiZXhwIjoxNzEwOTk2NzQyfQ.34i-fU1PR1ryz3eAqaI9G8w1rTw-_d33DL_DFgrQhJ4	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMDkxMDM0MiwiZXhwIjoxNzExMzQyMzQyfQ.OF09qKXpCPymu2QZoNz6wG1IU-xKAcTNNaK8SQolgfA	2024-03-20 10:52:22.542932	2024-03-21 10:52:22.542933	Signin
d1752a8f-8093-414a-85cd-7e067be022bb	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMTI1NzcwNiwiZXhwIjoxNzExMzQ0MTA2fQ.lNx761vcVnb5RdNe2FsZDscAkS8tjd2i8GPk01ObpBc	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMTI1NzcwNiwiZXhwIjoxNzExNjg5NzA2fQ.lKsCmXKxqGRYTSlaT2Mc-8o4La-V1QojH6RcbJ685hI	2024-03-24 11:21:46.117926	2024-03-25 11:21:46.117927	Signin
8314d0ee-ca34-4e82-b6f7-c447d73a4f48	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTEyNTc3NDksImV4cCI6MTcxMTM0NDE0OX0._5KLMQGBhW8Injqo3ncYJwNKm85ctl8oEqZhoL5poGU	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTEyNTc3NDksImV4cCI6MTcxMTY4OTc0OX0.Hb7GJ1bK4cDCBswlrYaE65uqac9eCdwzq1YFs5O16Nw	2024-03-24 11:22:29.498815	2024-03-25 11:22:29.498815	Signout
20eacd99-0d45-4707-bd2a-15f2567f5914	robin.das	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicm9iaW4uZGFzIiwicm9sZSI6Ik1hbmFnZXIiLCJsb2dpbl9vaWQiOiJMTi1VU0VSLTAwMDAwNDMiLCJ1c2VyX25hbWUiOiJSb2JpbiBEYXMiLCJpYXQiOjE3MTEyNTgwNzAsImV4cCI6MTcxMTM0NDQ3MH0.VSBNOI05cOV0aNpSBCXOlC23MTf4Y1uJHoxuMw-LPIY	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicm9iaW4uZGFzIiwicm9sZSI6Ik1hbmFnZXIiLCJsb2dpbl9vaWQiOiJMTi1VU0VSLTAwMDAwNDMiLCJ1c2VyX25hbWUiOiJSb2JpbiBEYXMiLCJpYXQiOjE3MTEyNTgwNzAsImV4cCI6MTcxMTY5MDA3MH0.4Sl2rkzZwX1TT0JkeqD6sY-ystboC1BhbufgOvJggmo	2024-03-24 11:27:50.985226	2024-03-25 11:27:50.985226	Signout
4fba9c43-7376-4e7b-9e5f-c10ada179a8c	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMTI1ODA5NSwiZXhwIjoxNzExMzQ0NDk1fQ.t5UQ235QBpROKP-yYsWk6Cv5GPTmxvu6xy8LQP-p8b0	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMTI1ODA5NSwiZXhwIjoxNzExNjkwMDk1fQ.iHIR0o-6ig-NPsIPBVIPKFZTGj51ikyc2i4Ia5e3k1k	2024-03-24 11:28:15.578377	2024-03-25 11:28:15.578377	Signin
228629b1-32ef-4ec9-a220-06bff5f7e152	rashida.akter	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMTI1OTkxMSwiZXhwIjoxNzExMzQ2MzExfQ.jXkdo9dObe9BDWJ5satB0ituNP95qfU_X1o3n30WpcU	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicmFzaGlkYS5ha3RlciIsInJvbGUiOiJVc2VyIiwibG9naW5fb2lkIjoiTE4tVVNFUi0wMDAwMDQyIiwidXNlcl9uYW1lIjoiUmFzaGlkYSBBa3RlciIsImlhdCI6MTcxMTI1OTkxMSwiZXhwIjoxNzExNjkxOTExfQ.x_BmrUpXtjI7C698PKDH3kLa3o7FiLLTelGyvkrFT_E	2024-03-24 11:58:31.81734	2024-03-25 11:58:31.817341	Signin
e8ab2403-c1f4-4755-a03b-6728c1799f2c	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTEyNTk5MTksImV4cCI6MTcxMTM0NjMxOX0.1LBCk1K8zcX4iOv9i0c0H6vJ3I-S5sLvP2m0EV4GS5k	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTEyNTk5MTksImV4cCI6MTcxMTY5MTkxOX0.JxuFtvMzanGa7Kglb6rXuEAMS4jI_zMCP3gu-Tpzrbc	2024-03-24 11:58:39.730136	2024-03-25 11:58:39.730137	Signin
a0654288-1016-42e8-881b-d9c824a12b3a	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTEyNTk5MjEsImV4cCI6MTcxMTM0NjMyMX0.nS1wFeHBoNs-88wCRfx5TxxN0pxnzlXvbORqu1Wp46k	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTEyNTk5MjEsImV4cCI6MTcxMTY5MTkyMX0.eH_1CbWqTz0JIAP2_2-sLwg-6kKdDUCw1LwzSaL2I3E	2024-03-24 11:58:41.732264	2024-03-25 11:58:41.732264	Signin
7c6ab3d2-ed38-400b-bc81-a6632e1b6e45	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTEyNTk5MjQsImV4cCI6MTcxMTM0NjMyNH0.DYmqqtCfTxkhXd6Mp_gBvTxO5-BPT3dN7R105hxSatc	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTEyNTk5MjQsImV4cCI6MTcxMTY5MTkyNH0.15PaqxRpx9Wk1C5dYWVOvvWxj5W1l39YNFmyvl3pRH4	2024-03-24 11:58:44.7137	2024-03-25 11:58:44.713701	Signin
1cf965e8-169e-4c7b-ac1e-ab362019e94d	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTEyNTk5MzIsImV4cCI6MTcxMTM0NjMzMn0.aPClEFzdcly-aRA8hoTVxWdKKydHkgIBSNL7_PaUA5g	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTEyNTk5MzIsImV4cCI6MTcxMTY5MTkzMn0.jrO1RkS61dA6ZjE3DfoukHzVJOIgTW1zLhrwqh-Xxgg	2024-03-24 11:58:52.157759	2024-03-25 11:58:52.157759	Signin
0dd8b5b4-f964-4f98-870a-3b862ad7e153	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTE1NTAwMTUsImV4cCI6MTcxMTYzNjQxNX0.Rgm99tkcG1wTyNrzbAPftiM2sfyUKRhWbJ_It9zOuK0	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTE1NTAwMTUsImV4cCI6MTcxMTk4MjAxNX0.Y0oFQegjJqXSGXqsz4lNR28-rAB3tfaKlxNx1wN-xho	2024-03-27 20:33:35.939949	2024-03-28 20:33:35.93995	Signout
f0bc92b5-f8e4-4a8c-840f-6c2d96c682dc	humayun.kabir	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTE1NTAxNDksImV4cCI6MTcxMTYzNjU0OX0.oLlzX8yGwlNV0F9FCgP7FlE9JelF8ILa_9EGiWPfiR0	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaHVtYXl1bi5rYWJpciIsInJvbGUiOiJBZG1pbiIsImxvZ2luX29pZCI6IkxOLVVTRVItMDAwMDA0MSIsInVzZXJfbmFtZSI6Ikh1bWF5dW4gS2FiaXIiLCJpYXQiOjE3MTE1NTAxNDksImV4cCI6MTcxMTk4MjE0OX0.TW3UWtvULIKUJDxy6tzxo7U5elntAtu8H_OH-zXndZo	2024-03-27 20:35:49.297086	2024-03-28 20:35:49.297087	Signout
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.product (oid, product_id, product_title_bn, product_title_en, unit_price, stock, description, status, created_by, created_on, edited_by, edited_on, product_category_oid, unit_type_oid) FROM stdin;
40aa7907-173c-44bc-84a0-d4a08bb5b9d1	PD - 2024-2-114	বাসমতী চাল	Basmati Rice	480	100	Basmati rice is characterized by its long  slender grains that elongate further upon cooking. The grains remain separate and fluffy  with a distinct texture that is neither sticky nor clumpy. Visually  Basmati rice grains are pale and slender  with a slight opalescence.	Active	LN-USER-0000041	2024-03-11 13:05:58	\N	\N	PC-0001	123-456-789
c7cea0f5-64d4-460e-8ea2-7fb24d2e0ba3	PD - 2024-2-116	মসুর ডাল	Lentil	140	100	Lentils are versatile and can be used in a variety of dishes, including soups, stews, salads, curries, and side dishes. They cook relatively quickly compared to other legumes and have a mild, earthy flavor that pairs well with a wide range of ingredients and seasonings.	Active	LN-USER-0000041	2024-03-11 14:40:08	\N	\N	PC-0002	123-456-789
d7741928-8f0f-4a66-84de-507688d243ff	PD - 2024-2-248	ggg	ggg	200	23	ghggf	Active	LN-USER-0000041	2024-03-24 11:23:50.26866	\N	\N	PC-0002	123-456-789
7f682484-cacb-4440-95ae-aca7721566ce	PD - 2024-1-290	চিনি গুঁড়া চাল: গ্রীন হারভেস্ট	Chini Gura Rice: Green Harvest	120	38	Chinigura Rice is a famous type of rice which is cultivated in Dinajpur. It gives you the pure and fresh texture of rice which is amazing to eat. This rice was produced before the region of Aryan in Dinajpur. The size of the rice is very small and a bit curvy in shape. It gives a sweet aroma when it is cooked. Chinigura rice is cultivated in sandy and loamy soil which makes the rice fresh. Cow dung fertilizer is used to grow Chinigura rice which makes the rice fresher.	Active	LN-USER-0000041	2024-02-29 13:11:25	\N	\N	PC-0001	123-456-789
61569486-fb80-4c1a-af26-4831789e6e3e	PD - 2024-2-113	বাশফুল চাল	Bashful Rice	85	96	Bashful rice is renowned for its long  slender grains  which elongate further upon cooking. The grains remain separate and fluffy  with a characteristic texture that is neither sticky nor clumpy. Visually  Basmati rice is pale and slender  with a slight opalescence.	Active	LN-USER-0000041	2024-03-11 13:05:58	\N	\N	PC-0001	123-456-789
ab44ed3c-c33b-4615-a258-20d3581813c0	PD - 2024-2-117	মুগ ডাল ২ কেজি প্রিমিয়াম	Moong Dal 2kg premium	300	497	These lentils are split and hulled mung beans, resulting in small, yellow-colored lentils with a smooth texture. They cook relatively quickly compared to whole mung beans and have a mild, slightly sweet flavor.	Active	LN-USER-0000041	2024-03-11 14:49:50	\N	\N	PC-0002	123-456-791
46154a8c-3919-4b99-afd2-2c76d67339c0	PD - 2024-2-111	কালিজিরা চাল	Kalijira Rice	175	97	\nKalijira rice also known as baby basmati or kalo jeera rice  is a unique variety of rice primarily cultivated in the Indian subcontinent particularly in the Bengal region of India and Bangladesh. It is highly prized for its delicate aroma fine texture and distinctive flavor.\n\nAppearance wise Kalijira rice grains are small and slender resembling miniature basmati rice grains. They are characterized by their pearly white color and elongated shape  which sets them apart from other types of rice.	Active	LN-USER-0000041	2024-03-11 13:05:58	\N	\N	PC-0001	123-456-789
108e359c-55c7-432a-ba21-cdfc79bfb5db	PD - 2024-2-112	নাজিরশাইল প্রিমিয়াম রাইস	Nazirshail Premium Rice	80	497	Najirshail Rice is a variety of aromatic rice predominantly cultivated in the Indian subcontinent  particularly in the northeastern regions of India and Bangladesh. Also known as Najirshail or najirsail this rice variety is renowned for its unique fragrance slender grains  and versatility in culinary applications.\n	Active	LN-USER-0000041	2024-03-11 13:05:58	\N	\N	PC-0001	123-456-789
4a7fe85d-9981-458b-baa6-f37de591445f	PD - 2024-2-115	লালবোরো চাল	Lalboro Rice	100	95	Lalboro rice is a type of rice commonly cultivated in Bangladesh  India  Pakistan  Sri Lanka  and other countries. The name Lalboro originates from the red color of its seeds. The plants of Lalboro rice resemble the crescent moon in appearance  and the rice grains are usually off-white or reddish-brown in color.	Active	LN-USER-0000041	2024-03-11 13:05:58	\N	\N	PC-0001	123-456-789
\.


--
-- Data for Name: product_attribute; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.product_attribute (oid, product_attribute_id, product_attribute_title_bn, product_attribute_title_en, value_bn, value_en, status, created_by, created_on, edited_by, edited_on, product_oid) FROM stdin;
5976b7a6-9a05-4291-8fac-a4e6918453ee	PA - 2024-1-290	আকার	Size	ছোট	Small	Active	LN-USER-0000041	2024-02-29 13:11:25	\N	\N	7f682484-cacb-4440-95ae-aca7721566ce
0eebcb4f-08ec-4f28-8cb1-889c75183695	PA - 2024-1-291	সুগন্ধি	Fragrance	হ্যাঁ	Yes	Active	LN-USER-0000041	2024-02-29 13:11:25	\N	\N	7f682484-cacb-4440-95ae-aca7721566ce
057337d3-cb22-426d-ba27-bb62673573fc	PA - 2024-1-292	ব্র্যান্ড	Brand	গ্রীন হারভেস্ট	Green Harvest	Active	LN-USER-0000041	2024-02-29 13:11:25	\N	\N	7f682484-cacb-4440-95ae-aca7721566ce
6cda61d3-24b8-42e1-bab5-ab31d1ca8a9c	PA - 2024-2-113	প্রকার	Type	প্রাকৃতিক এবং জৈব	Natural and Organic	Active	LN-USER-0000041	2024-03-11 13:05:58	\N	\N	46154a8c-3919-4b99-afd2-2c76d67339c0
705807fe-db16-4828-88f7-131bce72e1c2	PA - 2024-2-114	মেড ইন	Made In	বাংলাদেশ	Bangladesh	Active	LN-USER-0000041	2024-03-11 13:05:58	\N	\N	46154a8c-3919-4b99-afd2-2c76d67339c0
37c790bf-6de0-4aa9-8fe2-4b45a1605b68	PA - 2024-2-115	প্রকার	Type	প্রাকৃতিক এবং অর্গানিক	Natural and Organic	Active	LN-USER-0000041	2024-03-11 13:11:51	\N	\N	108e359c-55c7-432a-ba21-cdfc79bfb5db
07ff436f-6e54-4641-894a-280700bec8e4	PA - 2024-2-116	প্রকার	Type	প্রাকৃতিক এবং জৈব	Natural and Organic	Active	LN-USER-0000041	2024-03-11 13:15:02	\N	\N	61569486-fb80-4c1a-af26-4831789e6e3e
b7410193-4d11-4975-85a1-001c0012caf3	PA - 2024-2-117	টাইপ	Type	প্রাকৃতিক এবং জৈব	Natural and Organic	Active	LN-USER-0000041	2024-03-11 13:18:51	\N	\N	40aa7907-173c-44bc-84a0-d4a08bb5b9d1
7a8ca50d-1e00-4bde-91ec-8e90937d2c74	PA - 2024-2-118	টাইপ	Type	প্রাকৃতিক এবং জৈব	Natural and Organic	Active	LN-USER-0000041	2024-03-11 13:27:40	\N	\N	4a7fe85d-9981-458b-baa6-f37de591445f
5811c7f2-a0b7-44dc-806d-8a7b80040527	PA - 2024-2-119	প্রকার	Type	অর্গানিক	organic	Active	LN-USER-0000041	2024-03-11 14:40:08	\N	\N	c7cea0f5-64d4-460e-8ea2-7fb24d2e0ba3
f3d2e310-a0d0-4232-9d0b-9e9a3943fd5a	PA - 2024-2-1110	টাইপ	Type	প্রাকৃতিক এবং জৈব	Natural and Organic	Active	LN-USER-0000041	2024-03-11 14:49:50	\N	\N	ab44ed3c-c33b-4615-a258-20d3581813c0
055513db-187a-4601-a7e1-516ae26d320d	PA - 2024-2-2411	Size	Size	Small	Small	Active	LN-USER-0000041	2024-03-24 11:23:50.26866	\N	\N	d7741928-8f0f-4a66-84de-507688d243ff
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.product_category (oid, product_category_id, product_category_bn, product_category_en, description, status, created_by, created_on, edited_by, edited_on, product_type_oid) FROM stdin;
PC-0001	PC-0001	চাল	Rice	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.870606	\N	\N	PT-0001
PC-0002	PC-0002	ডাল	Dal	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.870606	\N	\N	PT-0001
PC-0003	PC-0003	স্ন্যাকস	Snacks	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.870606	\N	\N	PT-0001
PC-0004	PC-0004	নোবেল	Nobel	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.870606	\N	\N	PT-0002
PC-0005	PC-0005	সেলফ মোটিভেশন	Self Motivation	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.870606	\N	\N	PT-0002
PC-0006	PC-0006	সাহিত্য	Literature	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.870606	\N	\N	PT-0002
PC-0007	PC-0007	শরীরের স্প্রে	Body Spray	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.870606	\N	\N	PT-0003
PC-0008	PC-0008	লোশন	Lotion	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.870606	\N	\N	PT-0003
PC-0009	PC-0009	সেম্পো	Sempo	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.870606	\N	\N	PT-0003
\.


--
-- Data for Name: product_order; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.product_order (oid, product_order_id, order_by, total_amount, description, status, created_by, created_on, edited_by, edited_on) FROM stdin;
de2ebe33-42ee-478b-a7df-f3a1ca6fafc8	PO - 2024-2-100	LN-USER-0000042	475		Active	LN-USER-0000042	2024-03-11 15:33:30.459976	\N	\N
57b56884-1fb2-4adb-9a20-7c5ec20b4b25	PO - 2024-2-191	LN-USER-0000042	320		Active	LN-USER-0000042	2024-03-19 20:10:06.93366	\N	\N
26999647-6528-4dd2-81ab-0e4d28bc2986	PO - 2024-2-192	LN-USER-0000042	1140		Active	LN-USER-0000042	2024-03-20 10:34:10.668212	\N	\N
76f8d16e-09d8-40f6-9d01-57f7ce3200fc	PO - 2024-2-243	LN-USER-0000042	810		Active	LN-USER-0000042	2024-03-24 11:22:11.690651	\N	\N
\.


--
-- Data for Name: product_order_detail; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.product_order_detail (oid, order_detail_id, product_order_oid, product_oid, unit_type_oid, unit_price, quantity, total_amount, description, status, created_by, created_on, edited_by, edited_on) FROM stdin;
0c385f53-808a-4efd-b3fd-16f0e64b19db	POD - 2024-2-100	de2ebe33-42ee-478b-a7df-f3a1ca6fafc8	46154a8c-3919-4b99-afd2-2c76d67339c0	123-456-789	175	1	175		Active	LN-USER-0000042	2024-03-11 15:33:30.459976	\N	\N
f844b732-c636-4811-bc1e-7d93eeda6650	POD - 2024-2-101	de2ebe33-42ee-478b-a7df-f3a1ca6fafc8	ab44ed3c-c33b-4615-a258-20d3581813c0	123-456-791	300	1	300		Active	LN-USER-0000042	2024-03-11 15:33:30.459976	\N	\N
7f5fc080-5d2b-43ad-a548-1572f9e3c9a9	POD - 2024-2-192	57b56884-1fb2-4adb-9a20-7c5ec20b4b25	7f682484-cacb-4440-95ae-aca7721566ce	123-456-789	120	2	240		Active	LN-USER-0000042	2024-03-19 20:10:06.93366	\N	\N
d1fe26fb-ff71-47ac-b3dd-6d3fceb1e28f	POD - 2024-2-193	57b56884-1fb2-4adb-9a20-7c5ec20b4b25	108e359c-55c7-432a-ba21-cdfc79bfb5db	123-456-789	80	1	80		Active	LN-USER-0000042	2024-03-19 20:10:06.93366	\N	\N
aa28e3b9-98a7-4b83-b8c2-4345bcacbf90	POD - 2024-2-194	26999647-6528-4dd2-81ab-0e4d28bc2986	61569486-fb80-4c1a-af26-4831789e6e3e	123-456-789	85	4	340		Active	LN-USER-0000042	2024-03-20 10:34:10.668212	\N	\N
9c9d973c-03fe-44b5-a909-f1437df8df78	POD - 2024-2-195	26999647-6528-4dd2-81ab-0e4d28bc2986	4a7fe85d-9981-458b-baa6-f37de591445f	123-456-789	100	2	200		Active	LN-USER-0000042	2024-03-20 10:34:10.668212	\N	\N
44d425df-638c-4a89-8c3a-e62df5235a16	POD - 2024-2-196	26999647-6528-4dd2-81ab-0e4d28bc2986	ab44ed3c-c33b-4615-a258-20d3581813c0	123-456-791	300	2	600		Active	LN-USER-0000042	2024-03-20 10:34:10.668212	\N	\N
a2a06902-fe22-44b2-a5bf-c0df3073897f	POD - 2024-2-247	76f8d16e-09d8-40f6-9d01-57f7ce3200fc	46154a8c-3919-4b99-afd2-2c76d67339c0	123-456-789	175	2	350		Active	LN-USER-0000042	2024-03-24 11:22:11.690651	\N	\N
e43176c5-4a35-495a-8219-a4a2345bd903	POD - 2024-2-248	76f8d16e-09d8-40f6-9d01-57f7ce3200fc	108e359c-55c7-432a-ba21-cdfc79bfb5db	123-456-789	80	2	160		Active	LN-USER-0000042	2024-03-24 11:22:11.690651	\N	\N
6aa8c903-9efa-49f5-b0f1-c62053b21553	POD - 2024-2-249	76f8d16e-09d8-40f6-9d01-57f7ce3200fc	4a7fe85d-9981-458b-baa6-f37de591445f	123-456-789	100	3	300		Active	LN-USER-0000042	2024-03-24 11:22:11.690651	\N	\N
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.product_type (oid, product_type_id, product_type_bn, product_type_en, description, status, created_by, created_on, edited_by, edited_on) FROM stdin;
PT-0001	PT-0001	খাদ্য	Food	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.859856	\N	\N
PT-0002	PT-0002	বই	Book	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.859856	\N	\N
PT-0003	PT-0003	প্রসাধনী	Cosmetics	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.859856	\N	\N
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.role (oid, role_name, role_name_bn, status, role_description, web_json, api_json) FROM stdin;
AD-00001	Admin	এডমিন	Active	ADMIN	[{"text":"Dashboard","icon":"dashboard","url":"/dashboard"},{"text":"Product Info","icon":"receipt","children":[{"text":"Unit Type","icon":"local_atm","url":"/unit-type"},{"text":"Add Unit Type","icon":"local_atm","url":"/unit-type/add"},{"text":"Product Type","icon":"local_atm","url":"/product-type"},{"text":"Add Product Type","icon":"local_atm","url":"/product-type/add"},{"text":"Product Category","icon":"local_atm","url":"/product-category"},{"text":"Add Product Category","icon":"local_atm","url":"/product-category/add"},{"text":"Product","icon":"local_atm","url":"/product"},{"text":"Add Product","icon":"local_atm","url":"/product/add"}]},{"text":"Order","icon":"receipt","children":[{"text":"Order List","icon":"local_atm","url":"/order/order-list"}]},{"text":"User","icon":"receipt","children":[{"text":"User List","icon":"local_atm","url":"/user-info"},{"text":"Add User","icon":"history","url":"/user-info/add"}]},{"text":"Report","icon":"analytics","children":[{"text":"Order Details","icon":"local_atm","url":"reports/order-details"},{"text":"Order Summary","icon":"local_atm","url":"reports/order-summary"}]}]	[]
NU-00001	User	ইউজার	Active	Normal User	[{"text":"Dashboard","icon":"dashboard","url":"/dashboard"},{"text":"Order","icon":"receipt","children":[{"text":"Order List","icon":"local_atm","url":"/order"},{"text":"Add Order","icon":"history","url":"/order/add"}]},{"text":"Report","icon":"analytics","children":[{"text":"Order Details","icon":"local_atm","url":"reports/order-details"},{"text":"Order Summary","icon":"local_atm","url":"reports/order-summary"}]}]	[]
MN-00001	Manager	ম্যানেজার	Active	Manager	[{"text":"Dashboard","icon":"dashboard","url":"/dashboard"},{"text":"Order","icon":"receipt","children":[{"text":"Order List","icon":"local_atm","url":"/order/order-list"}]},{"text":"Report","icon":"analytics","children":[{"text":"Order Details","icon":"local_atm","url":"reports/order-details"},{"text":"Order Summary","icon":"local_atm","url":"reports/order-summary"}]}]	[]
\.


--
-- Data for Name: unit_type; Type: TABLE DATA; Schema: public; Owner: agrotech
--

COPY public.unit_type (oid, unit_type_id, unit_type_bn, unit_type_en, description, status, created_by, created_on, edited_by, edited_on) FROM stdin;
123-456-789	UT-001	কেজি	Kg	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.866476	\N	\N
123-456-790	UT-002	লিটার	Liter	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.866476	\N	\N
123-456-791	UT-003	পিস	PC	\N	Active	LN-USER-0000041	2024-03-11 15:31:38.866476	\N	\N
\.


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: file_detail pk_file_detail; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.file_detail
    ADD CONSTRAINT pk_file_detail PRIMARY KEY (oid);


--
-- Name: login pk_login; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.login
    ADD CONSTRAINT pk_login PRIMARY KEY (oid);


--
-- Name: login_log pk_login_log; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.login_log
    ADD CONSTRAINT pk_login_log PRIMARY KEY (oid);


--
-- Name: product pk_product; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT pk_product PRIMARY KEY (oid);


--
-- Name: product_attribute pk_product_attribute; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_attribute
    ADD CONSTRAINT pk_product_attribute PRIMARY KEY (oid);


--
-- Name: product_category pk_product_category; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT pk_product_category PRIMARY KEY (oid);


--
-- Name: product_order pk_product_order; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_order
    ADD CONSTRAINT pk_product_order PRIMARY KEY (oid);


--
-- Name: product_order_detail pk_product_order_detail; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_order_detail
    ADD CONSTRAINT pk_product_order_detail PRIMARY KEY (oid);


--
-- Name: product_type pk_product_type; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT pk_product_type PRIMARY KEY (oid);


--
-- Name: role pk_role; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT pk_role PRIMARY KEY (oid);


--
-- Name: unit_type pk_unit_type; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.unit_type
    ADD CONSTRAINT pk_unit_type PRIMARY KEY (oid);


--
-- Name: product_order_detail uk_order_detail_id_product_order_detail; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_order_detail
    ADD CONSTRAINT uk_order_detail_id_product_order_detail UNIQUE (order_detail_id);


--
-- Name: product_attribute uk_product_attribute_id_product_attribute; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_attribute
    ADD CONSTRAINT uk_product_attribute_id_product_attribute UNIQUE (product_attribute_id);


--
-- Name: product_category uk_product_category_id_product_category; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT uk_product_category_id_product_category UNIQUE (product_category_id);


--
-- Name: product uk_product_id_product; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT uk_product_id_product UNIQUE (product_id);


--
-- Name: product_type uk_product_type_id_product_type; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT uk_product_type_id_product_type UNIQUE (product_type_id);


--
-- Name: unit_type uk_unit_type_id_unit_type; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.unit_type
    ADD CONSTRAINT uk_unit_type_id_unit_type UNIQUE (unit_type_id);


--
-- Name: login uk_user_id_login; Type: CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.login
    ADD CONSTRAINT uk_user_id_login UNIQUE (user_id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: agrotech
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: file_detail fk_added_by_file_detail; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.file_detail
    ADD CONSTRAINT fk_added_by_file_detail FOREIGN KEY (added_by) REFERENCES public.login(oid);


--
-- Name: product fk_created_by_product; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_created_by_product FOREIGN KEY (created_by) REFERENCES public.login(oid);


--
-- Name: product_attribute fk_created_by_product_attribute; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_attribute
    ADD CONSTRAINT fk_created_by_product_attribute FOREIGN KEY (created_by) REFERENCES public.login(oid);


--
-- Name: product_category fk_created_by_product_category; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT fk_created_by_product_category FOREIGN KEY (created_by) REFERENCES public.login(oid);


--
-- Name: product_order fk_created_by_product_order; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_order
    ADD CONSTRAINT fk_created_by_product_order FOREIGN KEY (created_by) REFERENCES public.login(oid);


--
-- Name: product_order_detail fk_created_by_product_order_detail; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_order_detail
    ADD CONSTRAINT fk_created_by_product_order_detail FOREIGN KEY (created_by) REFERENCES public.login(oid);


--
-- Name: product_type fk_created_by_product_type; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT fk_created_by_product_type FOREIGN KEY (created_by) REFERENCES public.login(oid);


--
-- Name: unit_type fk_created_by_unit_type; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.unit_type
    ADD CONSTRAINT fk_created_by_unit_type FOREIGN KEY (created_by) REFERENCES public.login(oid);


--
-- Name: product_order fk_edited_by_product_order; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_order
    ADD CONSTRAINT fk_edited_by_product_order FOREIGN KEY (edited_by) REFERENCES public.login(oid);


--
-- Name: product_order_detail fk_edited_by_product_order_detail; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_order_detail
    ADD CONSTRAINT fk_edited_by_product_order_detail FOREIGN KEY (edited_by) REFERENCES public.login(oid);


--
-- Name: product fk_product_category_oid_product; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_category_oid_product FOREIGN KEY (product_category_oid) REFERENCES public.product_category(oid);


--
-- Name: file_detail fk_product_oid_file_detail; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.file_detail
    ADD CONSTRAINT fk_product_oid_file_detail FOREIGN KEY (product_oid) REFERENCES public.product(oid);


--
-- Name: product_attribute fk_product_oid_product_attribute; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_attribute
    ADD CONSTRAINT fk_product_oid_product_attribute FOREIGN KEY (product_oid) REFERENCES public.product(oid);


--
-- Name: product_order_detail fk_product_oid_product_order_detail; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_order_detail
    ADD CONSTRAINT fk_product_oid_product_order_detail FOREIGN KEY (product_oid) REFERENCES public.product(oid);


--
-- Name: product_order_detail fk_product_order_oid_product_order_detail; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_order_detail
    ADD CONSTRAINT fk_product_order_oid_product_order_detail FOREIGN KEY (product_order_oid) REFERENCES public.product_order(oid);


--
-- Name: product_category fk_product_type_oid_product_category; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT fk_product_type_oid_product_category FOREIGN KEY (product_type_oid) REFERENCES public.product_type(oid);


--
-- Name: login fk_role_oid_login; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.login
    ADD CONSTRAINT fk_role_oid_login FOREIGN KEY (role_oid) REFERENCES public.role(oid);


--
-- Name: product fk_unit_type_oid_product; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_unit_type_oid_product FOREIGN KEY (unit_type_oid) REFERENCES public.unit_type(oid);


--
-- Name: product_order_detail fk_unit_type_oid_product_order_detail; Type: FK CONSTRAINT; Schema: public; Owner: agrotech
--

ALTER TABLE ONLY public.product_order_detail
    ADD CONSTRAINT fk_unit_type_oid_product_order_detail FOREIGN KEY (unit_type_oid) REFERENCES public.unit_type(oid);


--
-- PostgreSQL database dump complete
--

