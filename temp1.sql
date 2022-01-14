CREATE TABLE public.title_basics
(
    "tconst" text COLLATE pg_catalog."default" NOT NULL,
    "titleType" text COLLATE pg_catalog."default",
    "primaryTitle" text COLLATE pg_catalog."default",
    "originalTitle" text COLLATE pg_catalog."default",
    "isAdult" text COLLATE pg_catalog."default",
    "startYear" text COLLATE pg_catalog."default",
    "endYear" text COLLATE pg_catalog."default",
    "runtimeMinutes" text COLLATE pg_catalog."default",
    genres text COLLATE pg_catalog."default",
    CONSTRAINT title_basics_pkey PRIMARY KEY (tconst)
)

TABLESPACE pg_default;


COPY title_basics FROM '/home/nishith02/Desktop/tsvfiles/title.basics.tsv' DELIMITER E'\t'; 

CREATE TABLE public.name_basics
(
    "tconst" text COLLATE pg_catalog."default" NOT NULL,
    "nconst" text COLLATE pg_catalog."default",
    "primaryName" text COLLATE pg_catalog."default",
    "birthYear" text COLLATE pg_catalog."default",
    "deathYear" text COLLATE pg_catalog."default",
    "primaryProfession" text COLLATE pg_catalog."default",
    "knownForTitles" text COLLATE pg_catalog."default",
    CONSTRAINT name_basics_pkey PRIMARY KEY (tconst)
)

TABLESPACE pg_default;

CREATE TABLE name_basics(
    nconst TEXT,
    primaryName TEXT,
    birthYear TEXT,
    deathYear TEXT,
    primaryProfession TEXT, 
    knownForTitles TEXT,    
    PRIMARY KEY(nconst)
);

COPY name_basics FROM '/home/nishith02/Desktop/tsvfiles/name.basics.tsv' DELIMITER E'\t'; 

CREATE TABLE public.title_crew
(
    "tconst" text COLLATE pg_catalog."default" NOT NULL,
    "directors" text COLLATE pg_catalog."default",
    "writers" text COLLATE pg_catalog."default",
    CONSTRAINT title_crew_pkey PRIMARY KEY (tconst)
)

TABLESPACE pg_default;

COPY title_crew FROM '/home/nishith02/Desktop/tsvfiles/title.crew.tsv' DELIMITER E'\t' CSV HEADER quote '|';

CREATE TABLE public.title_akas
(
    titleId text COLLATE pg_catalog."default" NOT NULL,
    "ordering" text COLLATE pg_catalog."default",
    "title" text COLLATE pg_catalog."default",
    "region" text COLLATE pg_catalog."default",
    "language" text COLLATE pg_catalog."default",
    "types" text COLLATE pg_catalog."default",
    "attributes" text COLLATE pg_catalog."default",
    "isOriginalTitle" text COLLATE pg_catalog."default"
   -- CONSTRAINT title_akas_pkey PRIMARY KEY (titleId)
)

TABLESPACE pg_default;

COPY title_akas FROM '/home/nishith02/Desktop/tsvfiles/title.akas.tsv' DELIMITER E'\t' CSV HEADER quote '|';

CREATE TABLE public.title_episode
(
    "tconst" text COLLATE pg_catalog."default" NOT NULL,
    "parentTconst" text COLLATE pg_catalog."default",
    "seasonNumber" text COLLATE pg_catalog."default",
    "episodeNumber" text COLLATE pg_catalog."default",
    CONSTRAINT title_episode_pkey PRIMARY KEY (tconst)
)

TABLESPACE pg_default;

COPY title_episode FROM '/home/nishith02/Desktop/tsvfiles/title.episode.tsv' DELIMITER E'\t' CSV HEADER quote '|';

CREATE TABLE public.title_ratings
(
    "tconst" text COLLATE pg_catalog."default" NOT NULL,
    "averageRating" text COLLATE pg_catalog."default",
    "numVotes" text COLLATE pg_catalog."default",
    CONSTRAINT title_ratings_pkey PRIMARY KEY (tconst)
)

TABLESPACE pg_default;


COPY title_ratings FROM '/home/nishith02/Desktop/tsvfiles/title.ratings.tsv' DELIMITER E'\t' CSV HEADER quote '|';

CREATE TABLE public.title_principals
(
    "tconst" text COLLATE pg_catalog."default" NOT NULL,
    "orderings" text COLLATE pg_catalog."default",
    "nconst" text COLLATE pg_catalog."default",
    "category" text COLLATE pg_catalog."default",
    "job" text COLLATE pg_catalog."default",
    "characters" text COLLATE pg_catalog."default"
    --CONSTRAINT title_principals_pkey PRIMARY KEY (tconst)
)

TABLESPACE pg_default;

COPY title_principals FROM '/home/nishith02/Desktop/tsvfiles/title.principals.tsv'(format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');
--er tables

CREATE TABLE ImdbShow
(
  ID TEXT,
  Original_Title TEXT,
  Rating TEXT,
  Budget TEXT,
  Box_office_gross TEXT,
  Anti_social TEXT,
  Plot_outline TEXT,
  PRIMARY KEY (ID)
);

CREATE TABLE Movie
(
  Movie_ID TEXT,
  ID TEXT,
  PRIMARY KEY (Movie_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
);

CREATE TABLE Tv_series
(
  Seasons TEXT,
  TvSeries_ID TEXT,
  Status TEXT,
  ID TEXT,
  PRIMARY KEY (TvSeries_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
);

CREATE TABLE Episode
(
  Episode_no TEXT,
  Season_no TEXT,
  Episode_runtime TEXT,
  Rating TEXT,
  Plot_outline TEXT,
  TvSeries_ID TEXT,
  PRIMARY KEY (Episode_no, TvSeries_ID),
  FOREIGN KEY (TvSeries_ID) REFERENCES Tv_series(TvSeries_ID),
  UNIQUE (Season_no)
);

CREATE TABLE Location
(
  Country TEXT,
  City TEXT,
  PRIMARY KEY (Country),
  UNIQUE (City)
);

CREATE TABLE Cast_and_Crew
(
  Name TEXT,
  Person_ID TEXT,
  PRIMARY KEY (Person_ID)
);

CREATE TABLE Award
(
  Category TEXT,
  Award_ID TEXT,
  Award_Name TEXT,
  Year TEXT,
  PRIMARY KEY (Award_ID),
  UNIQUE (Year)
);

CREATE TABLE Mvie_loc_rel
(
  Release_date TEXT,
  Run_time TEXT,
  Certificate TEXT,
  Region_title TEXT,
  Movie_ID TEXT,
  Country TEXT,
  PRIMARY KEY (Movie_ID, Country),
  FOREIGN KEY (Movie_ID) REFERENCES Movie(Movie_ID),
  FOREIGN KEY (Country) REFERENCES Location(Country)
);

CREATE TABLE Ep_loc_rel
(
  Run_time TEXT,
  Release_date TEXT,
  Certificate TEXT,
  Country TEXT,
  Episode_no TEXT,
  TvSeries_ID TEXT,
  Episode_id TEXT,
  PRIMARY KEY (Country, Episode_id),
  FOREIGN KEY (Country) REFERENCES Location(Country),
  --FOREIGN KEY (Episode_no, TvSeries_ID) REFERENCES Episode(Episode_no, TvSeries_ID)
);

CREATE TABLE TV_loc_rel
(
  Start_date TEXT,
  End_date TEXT,
  Certificate TEXT,
  TvSeries_ID TEXT,
  Country TEXT,
  PRIMARY KEY (TvSeries_ID, Country),
  FOREIGN KEY (TvSeries_ID) REFERENCES Tv_series(TvSeries_ID),
  FOREIGN KEY (Country) REFERENCES Location(Country)
);

CREATE TABLE Person_ImdbShow_rel
(
  Worked_as TEXT,
  Person_ID TEXT,
  ID TEXT,
  PRIMARY KEY (Person_ID, ID),
  FOREIGN KEY (Person_ID) REFERENCES Cast_and_Crew(Person_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
);

CREATE TABLE Person_ep_rel
(
  Worked_as TEXT,
  Person_ID TEXT,
  Episode_no TEXT,
  TvSeries_ID TEXT,
  Episode_id TEXT,
  PRIMARY KEY (Person_ID, Episode_id),
  FOREIGN KEY (Person_ID) REFERENCES Cast_and_Crew(Person_ID),
  FOREIGN KEY (Episode_id) REFERENCES Episode(Episode_id)
);

CREATE TABLE Person_nomination
(
  ImdbShow_ID TEXT,
  Won TEXT,
  Person_ID TEXT,
  Award_ID TEXT,
  PRIMARY KEY (Person_ID, Award_ID),
  FOREIGN KEY (Person_ID) REFERENCES Cast_and_Crew(Person_ID),
  FOREIGN KEY (Award_ID) REFERENCES Award(Award_ID)
);

CREATE TABLE ImdbShow_nomination
(
  Won TEXT,
  ID TEXT,
  Award_ID TEXT,
  PRIMARY KEY (ID, Award_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(ID),
  FOREIGN KEY (Award_ID) REFERENCES Award(Award_ID)
);

CREATE TABLE Sound_track_rel
(
  Sound_track TEXT,
  ID TEXT,
  Person_ID TEXT,
  PRIMARY KEY (ID, Person_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(ID),
  FOREIGN KEY (Person_ID) REFERENCES Cast_and_Crew(Person_ID)
);

CREATE TABLE ImdbShow_Country_released
(
  Country_released TEXT,
  ID TEXT,
  PRIMARY KEY (Country_released, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
);

CREATE TABLE ImdbShow_Languages
(
  Languages TEXT,
  ID TEXT,
  PRIMARY KEY (Languages, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
);

CREATE TABLE ImdbShow_Genre
(
  Genre TEXT,
  ID TEXT,
 -- PRIMARY KEY (Genre, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
);

CREATE TABLE ImdbShow_Titles
(
  Titles TEXT,
  ID TEXT,
  PRIMARY KEY (Titles, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
);

CREATE TABLE ImdbShow_Website
(
  Website TEXT,
  ID TEXT,
  PRIMARY KEY (Website, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
);

CREATE TABLE ImdbShow_Shooting_loc
(
  Shooting_loc TEXT,
  ID TEXT,
  PRIMARY KEY (Shooting_loc, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
);

CREATE TABLE Movie_Production_companies
(
  Production_companies TEXT,
  Movie_ID TEXT,
  PRIMARY KEY (Production_companies, Movie_ID),
  FOREIGN KEY (Movie_ID) REFERENCES Movie(Movie_ID)
);

CREATE TABLE Tv_series_Production_Companies
(
  Production_Companies TEXT,
  TvSeries_ID TEXT,
  PRIMARY KEY (Production_Companies, TvSeries_ID),
  FOREIGN KEY (TvSeries_ID) REFERENCES Tv_series(TvSeries_ID)
);

CREATE TABLE Episode_Production_companies
(
  Production_companies TEXT,
  Episode_no TEXT,
  TvSeries_ID TEXT,
  Episode_id TEXT,
  PRIMARY KEY (Production_companies, Episode_id),
  FOREIGN KEY (Episode_id) REFERENCES Episode(Episode_id)
);

CREATE TABLE Cast_and_Crew_Languages_acted
(
  Languages_acted TEXT,
  Person_ID TEXT,
  PRIMARY KEY (Languages_acted, Person_ID),
  FOREIGN KEY (Person_ID) REFERENCES Cast_and_Crew(Person_ID)
);

select * from show LIMIT 10;

insert into "show"(id,original_title) select tconst,originalTitle from title_basics;

ALTER TABLE "show"
RENAME TO ImdbShow;

UPDATE imdbshow
SET original_title = title_basics.originalTitle
FROM title_basics
WHERE title_basics.tconst = imdbshow.imdb_id;

UPDATE imdbshow
SET rating = title_ratings.averageRating
FROM title_ratings
WHERE title_ratings.tconst = imdbshow.imdb_id;

insert into cast_and_crew(name,person_id) select primaryname,nconst from name_basics;

insert into tv_series(tvseries_id) select tconst from title_basics WHERE title_basics.titletype = 'tvSeries';

ALTER TABLE episode --change in er diagram
ADD COLUMN episode_id TEXT;

ALTER TABLE episode DROP CONSTRAINT episode_season_no_key; --drop unq const

--drop tables
--add agaun

--ERROR:  cannot drop constraint episode_pkey on table episode because other objects depend on it
--DETAIL:  constraint ep_loc_rel_episode_no_tvseries_id_fkey on table ep_loc_rel depends on index episode_pkey
--constraint person_ep_rel_episode_no_tvseries_id_fkey on table person_ep_rel depends on index episode_pkey
--constraint episode_production_companies_episode_no_tvseries_id_fkey on table episode_production_companies depends on index episode_pkey
--HINT:  Use DROP ... CASCADE to drop the dependent objects too.
--SQL state: 2BP01

CREATE TABLE Episode
(
  Episode_id TEXT,
  TvSeries_ID TEXT,
  Episode_no TEXT,
  Season_no TEXT,
  Episode_runtime TEXT,
  Rating TEXT,
  Plot_outline TEXT,
  PRIMARY KEY (Episode_id)
--  FOREIGN KEY (TvSeries_ID) REFERENCES Tv_series(TvSeries_ID),
  --UNIQUE (Season_no)
);
--changes t episode, add episode id as primary key, removed foreign keys tv series id
insert into episode(episode_no,season_no,tvseries_id,episode_id) select episodenumber,seasonnumber,parenttconst,tconst from title_episode;

CREATE TABLE Person_ep_rel
(
  Worked_as TEXT,
  Person_ID TEXT,
  Episode_no TEXT,
  TvSeries_ID TEXT,
  Episode_id TEXT,
  PRIMARY KEY (Person_ID, Episode_id),
  FOREIGN KEY (Person_ID) REFERENCES Cast_and_Crew(Person_ID),
  FOREIGN KEY (Episode_id) REFERENCES Episode(Episode_id)
);

CREATE TABLE Ep_loc_rel
(
  Run_time TEXT,
  Release_date TEXT,
  Certificate TEXT,
  Country TEXT,
  Episode_no TEXT,
  TvSeries_ID TEXT,
  Episode_id TEXT,
  PRIMARY KEY (Country, Episode_id),
  FOREIGN KEY (Country) REFERENCES Location(Country)
  --FOREIGN KEY (Episode_no, TvSeries_ID) REFERENCES Episode(Episode_no, TvSeries_ID)
);

CREATE TABLE Episode_Production_companies
(
  Production_companies TEXT,
  Episode_no TEXT,
  TvSeries_ID TEXT,
  Episode_id TEXT,
  PRIMARY KEY (Production_companies, Episode_id),
  FOREIGN KEY (Episode_id) REFERENCES Episode(Episode_id)
);
--dropped primary key as genres are null
CREATE TABLE ImdbShow_Genre
(
  Genre TEXT,
  ID TEXT,
 -- PRIMARY KEY (Genre, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);
insert into imdbshow_genre(id,genre) select tconst,genres from title_basics; --populated
--now we succesfuly populated mutlivalued  genres
CREATE TABLE ImdbShow_Genre_temp
(
  ID TEXT,
  Genre TEXT,
 -- PRIMARY KEY (Genre, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

INSERT INTO ImdbShow_Genre_temp(ID,Genre)
SELECT ImdbShow_Genre.id,
regexp_split_to_table(ImdbShow_Genre.genre,E',')
FROM ImdbShow_Genre;

DROP TABLE ImdbShow_Genre;

ALTER TABLE ImdbShow_Genre_temp
Rename to ImdbShow_Genre;

--drop foriegn key bcz data not found in imdb show table
DROP TABLE ImdbShow_Country_released;
CREATE TABLE ImdbShow_Country_released
(
  ID TEXT,
  Country_released TEXT,
  PRIMARY KEY (Country_released, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);
    
INSERT INTO imdbshow_country_released(ID,country_released) select DISTINCT  titleId, region from title_akas WHERE title_akas.region <> '\N' CONFLICT DO NOTHING;


DROP TABLE ImdbShow_Languages;
CREATE TABLE ImdbShow_Languages
(
    ID TEXT,
  Languages TEXT,
  PRIMARY KEY (Languages, ID)
 -- FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
);

INSERT INTO imdbshow_languages(ID,languages) select DISTINCT  titleId, language from title_akas WHERE title_akas.language <> '\N'CONFLICT DO NOTHING;



DROP TABLE ImdbShow_Titles;
CREATE TABLE ImdbShow_Titles
(
  ID TEXT,
  Titles TEXT,
  PRIMARY KEY (Titles, ID)
 -- FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
);    
INSERT INTO ImdbShow_Titles(ID,titles) select DISTINCT  titleId, title from title_akas WHERE title_akas.title <> '\N' ON CONFLICT DO NOTHING;
--here we insert values to mutlivalued attributes of show, since somr values present in title akas are not in title basics, to satisfy foreign key constraints we remove them
--1
DROP TABLE ImdbShow_Country_released;
CREATE TABLE ImdbShow_Country_released
(
  ID TEXT,
  Country_released TEXT,
  PRIMARY KEY (Country_released, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);
alter table ImdbShow_Country_released disable trigger all;
INSERT INTO imdbshow_country_released(ID,country_released) select DISTINCT  titleId, region from title_akas WHERE title_akas.region <> '\N';

delete from ImdbShow_Country_released
where not EXISTS
( select imdb_id from imdbshow where imdbshow.imdb_id = ImdbShow_Country_released.id
);
alter table ImdbShow_Country_released enable trigger all;

--2
DROP TABLE ImdbShow_Languages;
CREATE TABLE ImdbShow_Languages
(
    ID TEXT,
  Languages TEXT,
  PRIMARY KEY (Languages, ID),
 FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);
alter table ImdbShow_Languages disable trigger all;
INSERT INTO imdbshow_languages(ID,languages) select DISTINCT  titleId, language from title_akas WHERE title_akas.language <> '\N';

delete from ImdbShow_Languages
where not EXISTS
( select imdb_id from imdbshow where imdbshow.imdb_id=ImdbShow_Languages.id
);
alter table ImdbShow_Languages enable trigger all;

--3
DROP TABLE ImdbShow_Titles;
CREATE TABLE ImdbShow_Titles
(
  ID TEXT,
  Titles TEXT,
  PRIMARY KEY (Titles, ID),
 FOREIGN KEY (ID) REFERENCES ImdbShow(Imdb_ID)
);   
alter table ImdbShow_Titles disable trigger all; 
INSERT INTO ImdbShow_Titles(ID,titles) select DISTINCT  titleId, title from title_akas; --WHERE title_akas.title <> '\N';
delete from ImdbShow_Titles
where not EXISTS
( select imdb_id from imdbshow where imdbshow.imdb_id=ImdbShow_titles.id
);
alter table ImdbShow_Titles enable trigger all;

DROP TABLE MOVIE;

CREATE TABLE Movie
(
  Movie_ID Serial,
  ID TEXT,
  PRIMARY KEY (Movie_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

--select * from movie limit 10;

insert into movie(id) select tconst from title_basics WHERE title_basics.titletype = 'movie';

drop table Tv_series;
CREATE TABLE Tv_series
(
  TvSeries_ID serial,
  ID text,
  Seasons TEXT,
  Status TEXT,
  PRIMARY KEY (TvSeries_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

insert into tv_series(id) select tconst from title_basics WHERE title_basics.titletype = 'tvSeries';

ALTER TABLE tv_series;
ADD constraint only_unique UNIQUE(ID);

Drop table Tv_series_Production_Companies
CREATE TABLE Tv_series_Production_Companies
(
  ID TEXT,
  Production_Companies TEXT,
  PRIMARY KEY (Production_Companies, ID),
  FOREIGN KEY (ID) REFERENCES Tv_series(ID)
);

DRop table TV_loc_rel;
CREATE TABLE TV_loc_rel
(
  TvSeries_ID TEXT,
  Start_date TEXT,
  End_date TEXT,
  Certificate TEXT,
  Country TEXT,
  PRIMARY KEY (TvSeries_ID, Country),
  FOREIGN KEY (TvSeries_ID) REFERENCES Tv_series(ID),
  FOREIGN KEY (Country) REFERENCES Location(Country)
);

ALTER TABLE movie
ADD constraint only_unique1 UNIQUE(ID);

DRop table Mvie_loc_rel;
CREATE TABLE Mvie_loc_rel
(
  Movie_ID TEXT,
  Release_date TEXT,
  Run_time TEXT,
  Certificate TEXT,
  Region_title TEXT,
  Country TEXT,
  PRIMARY KEY (Movie_ID, Country),
  FOREIGN KEY (Movie_ID) REFERENCES Movie(ID),
  FOREIGN KEY (Country) REFERENCES Location(Country)
);

DRop table Movie_Production_companies;
CREATE TABLE Movie_Production_companies
(
  Movie_ID TEXT,
  Production_companies TEXT,
  PRIMARY KEY (Production_companies, Movie_ID),
  FOREIGN KEY (Movie_ID) REFERENCES Movie(ID)
);

DROP TABLE Person_ImdbShow_rel;
CREATE TABLE Person_ImdbShow_rel
(
  ID TEXT,
  Person_ID TEXT,
  Worked_as TEXT,
--  PRIMARY KEY (Person_ID, ID,Worked_as),
  FOREIGN KEY (Person_ID) REFERENCES Cast_and_Crew(Person_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

insert into person_imdbshow_rel(ID,person_id,Worked_as) select tconst, nconst, category from title_principals 
join cast_and_crew c on c.person_id = title_principals.nconst
join imdbshow i on i.imdb_ID = title_principals.tconst;

UPDATE episode
SET episode_runtime = title_basics.runtimeminutes
FROM title_basics
WHERE title_basics.tconst=episode.episode_id;

UPDATE episode
SET rating = title_ratings.averagerating
FROM title_ratings
WHERE title_ratings.tconst=episode.episode_id;

insert into mvie_loc_rel(movie_ID,region_title,country) select titleID, title,region from title_akas;

delete from mvie_loc_rel
where not EXISTS
( select id from movie where movie.id=mvie_loc_rel.movie_id
);

insert into tv_loc_rel(tvseries_ID,country) select titleID,region from title_akas;

delete from tv_loc_rel
where not EXISTS
( select id from tv_series where tv_series.id=tv_loc_rel.tvseries_ID
);

insert into ep_loc_rel(episode_ID,country) select titleID,region from title_akas;

delete from ep_loc_rel
where not EXISTS
( select episode_id from episode where episode.episode_id=ep_loc_rel.tvseries_ID
);
