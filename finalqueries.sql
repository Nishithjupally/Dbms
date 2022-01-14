1- Write a query to find the list of movies that are directed by at least 2 directors.
Query:
select foo1.original_title from
(select id,count(id) from Person_ImdbShow_rel  where EXISTS (select id from movie where movie.id=Person_ImdbShow_rel.id) group by id having count(id) > 1 limit 10) AS foo,
imdbshow AS foo1
 WHERE foo1.imdb_ID=foo.id;



5- Find the name of the TV series which aired for the longest duration.
Query:
Select foo2.original_title from (
with foo as (
select
    id,
    CASE
        When end_year is null then 2021 - start_year
        Else end_year-start_year
    END duration
from tv_series
)
select id from tv_series
where
    case
        when end_year is null then (2021 - start_year) = (select max(duration) from foo)
        else (end_year - start_year) = (select max(duration) from foo)
    end
) as foo1,
 Imdbshow as foo2
Where foo2.imdb_id = foo1.id;

6-Find the name of the director who directed the 2nd shortest movie in the year 2020.
Query:

Select foo4.name from 
(
With foo as(
Select * from movie
Where releaseyear = 2020
),
Foo1 as (
Select min(runtime)
From foo
Where runtime > (select min(runtime) from foo)
),
Foo2 as(
Select id from foo 
Where runtime = (select * from foo1)
)
Select person_id  from person_imdbshow_rel,foo2
Where person_imdbshow_rel.id = foo2.id
)as foo3,
Cast_and_crew as foo4
Where foo3.person_id = foo4.person_id;

7-Print the adult movie and adult TV series with the lowest average rating.
Query:
--for movie
Select imdbshow.original_title from
(
With foo as(
Select imdb_id from imdbshow 
Where imdbshow.isadult = true
),
Foo1 as(
Select id,rating from movie,foo
Where movie.id = foo.imdb_id
)
Select foo1.id from foo1 
where foo1.rating = (select min(rating) from foo1)
)as foo2,
 imdbshow
Where foo2.id = imdbshow.imdb_id;

--for tv series
Select imdbshow.original_title from
(
With foo as(
Select imdb_id from imdbshow 
Where imdbshow.isadult = true
),
Foo1 as(
Select id,rating from tv_series,foo
Where tv_series.id = foo.imdb_id
)
Select foo1.id from foo1 
where foo1.rating = (select min(rating) from foo1)
)as foo2,
 imdbshow
Where foo2.id = imdbshow.imdb_id;

8- Print the Top 5 directors based on their average rating of all the movies he/she has directed.
(In case of equal print all.)
Query:
With foo as(
Select mv.id, rating, pir.worked_as,pir.person_id from movie mv, person_imdbshow_rel pir
Where mv.id = pir.id and rating is not null
),
Foo1 as(
SELECT person_id,AVG(rating) AS avg_rating
FROM foo
GROUP BY person_id order by avg_rating desc limit 5
)
Select name,avg_rating from cast_and_crew cc,foo1
Where cc.person_id = foo1.person_id;



14- Print the shortest TV episode for each year.
Query:
With foo as
 ( select releaseyear,MIN(episode_runtime)
from episode
group by releaseyear ),
Foo1 as(
Select episode_id,episode.releaseyear from episode,foo
Where foo.min=episode_runtime AND foo.releaseYear=episode.releaseYear ORDER BY episode.releaseYear ASC)
Select imdbshow.original_title, foo1.releaseyear 
From imdbshow, foo1
Where imdbshow.imdb_id = foo1.episode_id;

15- You want to suggest some good movies to your friends. Genre wise print the top 3 rated
movies.
Query:
With foo as(Select movie.id,movie.rating,imdbshow_genre.genre from movie,imdbshow_genre
Where movie.id = imdbshow_genre.id and movie.rating is not null),
foo2 as(
Select * from (
select id,
Genre,
Rating,
 row_number() over (partition by genre order by rating desc) as movie_rank
from foo) foo1
Where movie_rank<=3
)
Select imdbshow.original_title, foo2.genre, foo2.rating, foo2.movie_rank
From imdbshow, foo2
Where  foo2.id = imdbshow.imdb_id order by genre asc;

18- For each profession print the youngest one.
Query:
With foo as(Select cc.name,cc.person_id,pp.profession,cc.birth_year from cast_and_crew cc,primary_profession pp
Where cc.person_id = pp.id and cc.birth_year is not null),
Foo1 as(
select profession,MAX(birth_year)
from foo
group by profession)
Select foo.name, foo.profession, foo.birth_year
From foo1,foo
Where foo1.profession = foo.profession and foo1.max = foo.birth_year
Order by profession;
