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

COPY title_basics FROM '/home/saisrikar/title.basics.tsv'(format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f'); --import file

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


COPY name_basics FROM '/home/saisrikar/name.basics.tsv' (format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

CREATE TABLE public.title_crew
(
    tconst TEXT,
    directors TEXT, 
    writers TEXT,   
    PRIMARY KEY(tconst)
);

COPY title_crew FROM '/home/saisrikar/title.crew.tsv' (format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

CREATE TABLE public.title_akas
(
  titleId TEXT,
  ordering TEXT,
  title TEXT,
  region TEXT,
  language TEXT,
  types TEXT,
  attributes TEXT,
  isOriginalTitle TEXT
  --PRIMARY KEY (titleId)
);

COPY title_akas FROM '/home/saisrikar/title.akas.tsv' (format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

CREATE TABLE public.title_episode
(
    tconst TEXT,
    parentTconst TEXT,
    seasonNumber INTEGER,
    episodeNumber INTEGER,
    PRIMARY KEY(tconst)
);

COPY title_episode FROM '/home/saisrikar/title.episode.tsv' (format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

CREATE TABLE public.title_ratings
(
    tconst TEXT,
    averageRating REAL,
    numVotes INTEGER,
    PRIMARY KEY(tconst)
);

COPY title_ratings FROM '/home/saisrikar/title.ratings.tsv' (format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

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

COPY title_principals FROM '/home/saisrikar/title.principals.tsv'(format csv, DELIMITER E'\t', HEADER 1, NULL '\N', quote E'\f');

--schema
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
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

CREATE TABLE Tv_series
(
  Seasons TEXT,
  TvSeries_ID TEXT,
  Status TEXT,
  ID TEXT,
  PRIMARY KEY (TvSeries_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
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
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
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
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID),
  FOREIGN KEY (Award_ID) REFERENCES Award(Award_ID)
);

CREATE TABLE Sound_track_rel
(
  Sound_track TEXT,
  ID TEXT,
  Person_ID TEXT,
  PRIMARY KEY (ID, Person_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID),
  FOREIGN KEY (Person_ID) REFERENCES Cast_and_Crew(Person_ID)
);

CREATE TABLE ImdbShow_Country_released
(
  Country_released TEXT,
  ID TEXT,
  PRIMARY KEY (Country_released, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

CREATE TABLE ImdbShow_Languages
(
  Languages TEXT,
  ID TEXT,
  PRIMARY KEY (Languages, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

CREATE TABLE ImdbShow_Genre
(
  Genre TEXT,
  ID TEXT,
 -- PRIMARY KEY (Genre, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

CREATE TABLE ImdbShow_Titles
(
  Titles TEXT,
  ID TEXT,
  PRIMARY KEY (Titles, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

CREATE TABLE ImdbShow_Website
(
  Website TEXT,
  ID TEXT,
  PRIMARY KEY (Website, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

CREATE TABLE ImdbShow_Shooting_loc
(
  Shooting_loc TEXT,
  ID TEXT,
  PRIMARY KEY (Shooting_loc, ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
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

insert into imdbshow(imdb_id,original_title) select tconst,originalTitle from title_basics;

UPDATE imdbshow --ratings column
SET rating = title_ratings.averageRating
FROM title_ratings
WHERE title_ratings.tconst = imdbshow.imdb_id;

ALTER TABLE cast_and_crew --adding more attributes
ADD COLUMN birth_year TEXT,
ADD COLUMN death_year TEXT;

insert into cast_and_crew(name,person_id,birth_year,death_year) select primaryname,nconst,birthYear,deathYear from name_basics;

insert into tv_series(tvseries_id) select tconst from title_basics WHERE title_basics.titletype = 'tvSeries';

  
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

--3 -doagain
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
--;

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
  --FOREIGN KEY (Person_ID) REFERENCES Cast_and_Crew(Person_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

--do again
-- insert into location(country) select distinct region from title_akas; --location table

UPDATE episode --update runtime in epiosde table
SET episode_runtime = title_basics.runtimeminutes
FROM title_basics
WHERE title_basics.tconst=episode.episode_id;

UPDATE episode --update ratings in episode table
SET rating = title_ratings.averagerating
FROM title_ratings
WHERE title_ratings.tconst=episode.episode_id;

DROP TABLE Mvie_loc_rel;
CREATE TABLE Mvie_loc_rel
(
  Movie_ID TEXT,
  Release_date TEXT,
  Run_time TEXT,
  Certificate TEXT,
  Region_title TEXT,
  Country TEXT,
  --PRIMARY KEY (Movie_ID, Country),
  FOREIGN KEY (Movie_ID) REFERENCES Movie(ID),
  FOREIGN KEY (Country) REFERENCES Location(Country)
);
alter table Mvie_loc_rel disable trigger all;

insert into mvie_loc_rel(movie_ID,region_title,country) select titleID, title,region from title_akas;

delete from mvie_loc_rel
where not EXISTS
( select id from movie where movie.id=mvie_loc_rel.movie_id
);
alter table Mvie_loc_rel enable trigger all;


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

--do again
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
( select episode_id from episode where episode.episode_id=ep_loc_rel.episode_ID
);
alter table ep_loc_rel enable trigger all;

--done
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

-----

alter table Person_ImdbShow_rel disable trigger all;
insert into Person_ImdbShow_rel(ID,person_id) select tconst,directors from title_crew;
delete from Person_ImdbShow_rel
where not EXISTS
( select imdb_id from imdbshow where imdbshow.imdb_id=Person_ImdbShow_rel.id
);
alter table Person_ImdbShow_rel enable trigger all;

CREATE TABLE Person_ImdbShow_rel_temp
(
  ID TEXT,
  Person_ID TEXT,
  Worked_as TEXT,
--  PRIMARY KEY (Person_ID, ID,Worked_as),
  --FOREIGN KEY (Person_ID) REFERENCES Cast_and_Crew(Person_ID),
  FOREIGN KEY (ID) REFERENCES ImdbShow(imdb_ID)
);

INSERT INTO Person_ImdbShow_rel_temp(ID,Person_id) --populating profession table
SELECT Person_ImdbShow_rel.id,
regexp_split_to_table(Person_ImdbShow_rel.person_id,E',')
FROM Person_ImdbShow_rel;

DROP TABLE Person_ImdbShow_rel;
ALTER TABLE Person_ImdbShow_rel_temp
Rename to Person_ImdbShow_rel;

UPDATE Person_ImdbShow_rel
SET Worked_as = 'director';

--select id,count(id) from Person_ImdbShow_rel group by id having count(id) > 1 limit 10;

--1st
--select imdbshow.original_Title where imdb_ID
 select id,count(id) from Person_ImdbShow_rel  where EXISTS (select id from movie where movie.id=Person_ImdbShow_rel.id) group by id having count(id) > 1 limit 10 ;

-- ( select id from movie where movie.id=mvie_loc_rel.movie_id
-- );

-- select id,count(id) from Person_ImdbShow_rel --limit 10 
-- where Person_ImdbShow_rel.id in (select m.id from movie m) group by id having count(id) > 1 limit 10
-- ;


-- select imdbshow.original_title from imdbshow --limit 10 
-- where Person_ImdbShow_rel.id in (select m.id from movie m) group by id having count(id) > 1 limit 10
-- ;

-- select foo1.original_title from 
-- (select id,count(id) from Person_ImdbShow_rel  where EXISTS (select id from movie where movie.id=Person_ImdbShow_rel.id) group by id having count(id) > 1 limit 10) AS foo,
-- imdbshow AS foo1
--  WHERE foo1.imdb_ID=foo.id
-- ;
--query 1
select foo1.original_title from 
(select id,count(id) from Person_ImdbShow_rel  where EXISTS (select id from movie where movie.id=Person_ImdbShow_rel.id) group by id having count(id) > 1 limit 10) AS foo,
imdbshow AS foo1
 WHERE foo1.imdb_ID=foo.id
;

ALTER TABLE tv_series --adding more attributes
ADD COLUMN start_year TEXT,
ADD COLUMN end_year TEXT;

UPDATE episode --update runtime in epiosde table
SET episode_runtime = title_basics.runtimeminutes
FROM title_basics
WHERE title_basics.tconst=episode.episode_id;