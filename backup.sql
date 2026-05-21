--
-- PostgreSQL database dump
--

\restrict yialSSW2Xle8Jfsz6KQYpm12DKpxBuyFFPVk6lWIgcsPGcPe1ZkibjC5fapJBer

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: directors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directors (
    id integer NOT NULL,
    full_name text NOT NULL,
    birth_date date NOT NULL,
    movies_count integer DEFAULT 0,
    is_deleted boolean DEFAULT false,
    deleted_at timestamp without time zone
);


ALTER TABLE public.directors OWNER TO postgres;

--
-- Name: directors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directors_id_seq OWNER TO postgres;

--
-- Name: directors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directors_id_seq OWNED BY public.directors.id;


--
-- Name: movies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movies (
    id integer NOT NULL,
    title text NOT NULL,
    director_id integer NOT NULL,
    release_date date,
    duration_minutes integer,
    rating numeric(3,2),
    is_deleted boolean DEFAULT false,
    deleted_at timestamp without time zone,
    description text DEFAULT ''::text,
    CONSTRAINT movies_duration_minutes_check CHECK ((duration_minutes > 0)),
    CONSTRAINT movies_rating_check CHECK (((rating >= (0)::numeric) AND (rating <= (10)::numeric)))
);


ALTER TABLE public.movies OWNER TO postgres;

--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.movies_id_seq OWNER TO postgres;

--
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movies_id_seq OWNED BY public.movies.id;


--
-- Name: directors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directors ALTER COLUMN id SET DEFAULT nextval('public.directors_id_seq'::regclass);


--
-- Name: movies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);


--
-- Data for Name: directors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directors (id, full_name, birth_date, movies_count, is_deleted, deleted_at) FROM stdin;
1	Кристофер Нолан	1970-07-30	17	f	\N
3	Стивен Спилберг	1946-12-18	60	f	\N
2	Джеймс Кэмерон	1954-08-16	28	f	\N
\.


--
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movies (id, title, director_id, release_date, duration_minutes, rating, is_deleted, deleted_at, description) FROM stdin;
1	Начало	1	2010-07-08	148	8.70	f	\N	
2	Интерстеллар	1	2014-10-26	169	8.70	f	\N	
3	Титаник	2	1997-11-01	194	8.40	f	\N	
5	Терминал	3	2004-06-09	124	8.10	f	\N	
25	тест	2	2001-01-21	123	1.20	t	2026-05-21 01:39:58.174713	1232сорл
4	Аватар	2	2009-12-10	162	8.00	f	\N	
6	Список Шиндлера	2	1993-11-30	195	8.90	f	\N	
\.


--
-- Name: directors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directors_id_seq', 5, true);


--
-- Name: movies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movies_id_seq', 25, true);


--
-- Name: directors directors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directors
    ADD CONSTRAINT directors_pkey PRIMARY KEY (id);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: movies fk_movies_director; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT fk_movies_director FOREIGN KEY (director_id) REFERENCES public.directors(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict yialSSW2Xle8Jfsz6KQYpm12DKpxBuyFFPVk6lWIgcsPGcPe1ZkibjC5fapJBer

