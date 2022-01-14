--TABLES TO HOLD GIVEN DATA SETS
CREATE TABLE public.title_basics
(
    tconst TEXT,
    titleType TEXT,
    primaryTitle TEXT,
    originalTitle TEXT,
    isAdult BOOLEAN,
    startYear INT,
    endYear INT,
    runtimeMinutes INT,
    genres TEXT,    
    PRIMARY KEY(tconst)
);

COPY title_basics FROM '/home/nishith02/Desktop/tsvfiles/title.basics.tsv'(format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f'); --import file

CREATE TABLE public.name_basics
(
    nconst TEXT,
    primaryName TEXT,
    birthYear INT,
    deathYear INT,
    primaryProfession TEXT, 
    knownForTitles TEXT,    --
    PRIMARY KEY(nconst)
);


COPY name_basics FROM '/home/nishith02/Desktop/tsvfiles/name.basics.tsv' (format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

CREATE TABLE public.title_crew
(
    tconst TEXT,
    directors TEXT, 
    writers TEXT,   
    PRIMARY KEY(tconst)
);

COPY title_crew FROM '/home/nishith02/Desktop/tsvfiles/title.crew.tsv' (format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

CREATE TABLE public.title_akas
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

COPY title_akas FROM '/home/nishith02/Desktop/tsvfiles/title.akas.tsv' (format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

CREATE TABLE public.title_episode
(
    tconst TEXT,
    parentTconst TEXT,
    seasonNumber INTEGER,
    episodeNumber INTEGER,
    PRIMARY KEY(tconst)
);

COPY title_episode FROM '/home/nishith02/Desktop/tsvfiles/title.episode.tsv' (format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

CREATE TABLE public.title_ratings
(
    tconst TEXT,
    averageRating REAL,
    numVotes INTEGER,
    PRIMARY KEY(tconst)
);

COPY title_ratings FROM '/home/nishith02/Desktop/tsvfiles/title.ratings.tsv' (format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

CREATE TABLE public.title_principals
(
    tconst TEXT,    
    ordering TEXT,                        
    nconst TEXT,       
    category TEXT,
    job TEXT,
    characters TEXT,
    PRIMARY KEY(tconst,ordering)
);

COPY title_principals FROM '/home/nishith02/Desktop/tsvfiles/title.principals.tsv'(format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

--SCHEMA TABLES
CREATE TABLE ImdbShow
(
  imdb_ID TEXT,
  Original_Title TEXT,
  Rating TEXT,
  Budget TEXT,
  Box_office_gross TEXT,
  Anti_social TEXT,
  Plot_outline TEXT,
  PRIMARY KEY (imdb_ID)
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
  FOREIGN KEY (Country) REFERENCES Location(Country)
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

--select * from imdbshow LIMIT 10;

insert into imdbshow(id,original_title) select tconst,originalTitle from title_basics; --populate imdbshow table



-- UPDATE imdbshow
-- SET original_title = title_basics.originalTitle
-- FROM title_basics
-- WHERE title_basics.tconst = imdbshow.imdb_id;

UPDATE imdbshow --ratings column
SET rating = title_ratings.averageRating
FROM title_ratings
WHERE title_ratings.tconst = imdbshow.imdb_id;

insert into cast_and_crew(name,person_id) select primaryname,nconst from name_basics;

insert into tv_series(tvseries_id) select tconst from title_basics WHERE title_basics.titletype = 'tvSeries';

ALTER TABLE episode --change in er diagram --added episode id
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
DROP TABLE Person_ep_rel; --drop all cascading tables of episode
DROP TABLE Ep_loc_rel;
DROP TABLE Episode_Production_companies;
DROP TABLE Episode;
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
DROP TABLE ImdbShow_Genre;
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
-- DROP TABLE ImdbShow_Country_released;
-- CREATE TABLE ImdbShow_Country_released
-- (
--   ID TEXT,
--   Country_released TEXT,
--   PRIMARY KEY (Country_released, ID),
--   FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
-- );
    
-- INSERT INTO imdbshow_country_released(ID,country_released) select DISTINCT  titleId, region from title_akas WHERE title_akas.region <> '\N' CONFLICT DO NOTHING;


-- DROP TABLE ImdbShow_Languages;
-- CREATE TABLE ImdbShow_Languages
-- (
--     ID TEXT,
--   Languages TEXT,
--   PRIMARY KEY (Languages, ID)
--  -- FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
-- );

-- INSERT INTO imdbshow_languages(ID,languages) select DISTINCT  titleId, language from title_akas WHERE title_akas.language <> '\N'CONFLICT DO NOTHING;



-- DROP TABLE ImdbShow_Titles;
-- CREATE TABLE ImdbShow_Titles
-- (
--   ID TEXT,
--   Titles TEXT,
--   PRIMARY KEY (Titles, ID)
--  -- FOREIGN KEY (ID) REFERENCES ImdbShow(ID)
-- );    
-- INSERT INTO ImdbShow_Titles(ID,titles) select DISTINCT  titleId, title from title_akas WHERE title_akas.title <> '\N' ON CONFLICT DO NOTHING;
--here we insert values to mutlivalued attributes of show, since somr values present in title akas are not in title basics, to satisfy foreign key constraints we remove them
--1
DROP TABLE ImdbShow_Country_released; --populating ImdbShow_Country_released table
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

DROP TABLE Mvie_loc_rel;
DROP TABLE Movie_Production_companies;
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

DROP TABLE Tv_series_Production_Companies;
DROP TABLE TV_loc_rel;
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

ALTER TABLE tv_series
ADD constraint only_unique UNIQUE(ID);

CREATE TABLE Tv_series_Production_Companies
(
  ID TEXT,
  Production_Companies TEXT,
  PRIMARY KEY (Production_Companies, ID),
  FOREIGN KEY (ID) REFERENCES Tv_series(ID)
);


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

insert into location(country) select distinct region from title_akas; --location table

insert into person_imdbshow_rel(ID,person_id,Worked_as) select tconst, nconst, category from title_principals 
join cast_and_crew c on c.person_id = title_principals.nconst
join imdbshow i on i.imdb_ID = title_principals.tconst;

UPDATE episode --update runtime in epiosde table
SET episode_runtime = title_basics.runtimeminutes
FROM title_basics
WHERE title_basics.tconst=episode.episode_id;

UPDATE episode --update ratings in episode table
SET rating = title_ratings.averagerating
FROM title_ratings
WHERE title_ratings.tconst=episode.episode_id;

insert into mvie_loc_rel(movie_ID,region_title,country) select titleID, title,region from title_akas;

delete from mvie_loc_rel
where not EXISTS
( select id from movie where movie.id=mvie_loc_rel.movie_id
);

--insert into tv_loc_rel(tvseries_ID,country) select titleID,region from title_akas;

DROP TABLE TV_loc_rel;
 CREATE TABLE TV_loc_rel --to populate TV_loc_rel
(
  TvSeries_ID TEXT,
  Start_date TEXT,
  End_date TEXT,
  Certificate TEXT,
  Country TEXT,
 -- PRIMARY KEY (TvSeries_ID, Country),
  FOREIGN KEY (TvSeries_ID) REFERENCES Tv_series(ID),
  FOREIGN KEY (Country) REFERENCES Location(Country)
);   
alter table TV_loc_rel disable trigger all; --to avoid foreign key errors
insert into tv_loc_rel(tvseries_ID,country) select titleID,region from title_akas;

delete from tv_loc_rel
where not EXISTS
( select id from tv_series where tv_series.id=tv_loc_rel.tvseries_ID
);
alter table TV_loc_rel enable trigger all; 

DROP TABLE Ep_loc_rel; --to populate Eploc_rel
CREATE TABLE Ep_loc_rel
(
  Run_time TEXT,
  Release_date TEXT,
  Certificate TEXT,
  Country TEXT,
  Episode_no TEXT,
  TvSeries_ID TEXT,
  Episode_id TEXT,
  --PRIMARY KEY (Country, Episode_id),
  FOREIGN KEY (Country) REFERENCES Location(Country),
  FOREIGN KEY (Episode_id) REFERENCES Episode(Episode_id)
);
alter table ep_loc_rel disable trigger all; --disabling triggers to avoid foreign key errors stop populating
insert into ep_loc_rel(episode_ID,country) select titleID,region from title_akas;

delete from ep_loc_rel
where not EXISTS
( select episode_id from episode where episode.episode_id=ep_loc_rel.tvseries_ID
);
alter table ep_loc_rel enable trigger all;

ALTER TABLE cast_and_crew --adding more attributes
ADD COLUMN birth_year TEXT,
ADD COLUMN death_year TEXT;

UPDATE cast_and_crew --adding year of birth,death
SET birth_year = name_basics.birthYear 
FROM name_basics
WHERE name_basics.nconst=cast_and_crew.person_id;

UPDATE cast_and_crew
SET death_year = name_basics.deathYear 
FROM name_basics
WHERE name_basics.nconst=cast_and_crew.person_id;

CREATE TABLE primary_Profession --adding a mutilvalued attribute
(
    ID TEXT,
  Profession TEXT,
  PRIMARY KEY (Profession, ID),
 FOREIGN KEY (ID) REFERENCES cast_and_crew(person_id)
);

INSERT INTO primary_Profession(ID,Profession) --populating profession table
SELECT name_basics.nconst,
regexp_split_to_table(name_basics.primaryProfession,E',')
FROM name_basics;