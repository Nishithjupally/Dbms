--query 1
With foo as (
  Select
	pir.id,
	person_id
  from
	person_imdbshow_rel pir,
	movie
  Where
	movie.id = pir.id
	and worked_as = 'director'
)
Select
  original_title,
  cnt
from
  imdbshow,
  (
	Select
  	id,
  	count(person_id) as cnt
	from
  	foo
	Group by
  	id
	Having
  	count(person_id) > 1
  ) as foo1
Where
  imdbshow.imdb_id = foo1.id;


  --query 2
  With zacksnyder as (
  Select
    person_id
  from
    cast_and_crew
  where
    name = 'Zack Snyder'
),
Foo as(
  Select
    movie.id,
    pir1.person_id as director_id,
    pir2.person_id as actor_id
  from
    person_imdbshow_rel pir1,
    person_imdbshow_rel pir2,
    movie
  Where
    movie.id = pir1.id
    and movie.id = pir2.id
    and pir1.worked_as = 'director'
    and pir2.worked_as = 'actor'
),
Foo1 as(
  Select
    foo.actor_id,
    foo.director_id,
    count(id) as cnt
  From
    foo,
    zacksnyder
  Group by
    foo.director_id,
    foo.actor_id
  Having
    foo.director_id != (
      select
        *
      from
        zacksnyder
    )
),
Foo2 as (
  Select
    foo.actor_id,
    foo.director_id,
    count(id) as cnt
  From
    foo,
    zacksnyder
  Group by
    foo.director_id,
    foo.actor_id
  Having
    foo.director_id = (
      select
        *
      from
        zacksnyder
    )
),
Foo3 as(
  Select
    actor_id,
    MAX(cnt)
  From
    foo1
  Group by
    actor_id
)
Select
  cc.name,
  foo2.actor_id,
  foo2.cnt
From
  cast_and_crew cc,
  foo2,
  foo3
Where
  cc.person_id = foo2.actor_id
  and foo2.actor_id = foo3.actor_id
  and foo2.cnt > foo3.max;



  --query 3
  With foo as(
  Select
    id,
    count(won) as cnt
  From
    imdbshow_nomination
  Group by
    id,
    won
  Having
    imdbshow_nomination.won = 't'
),
Foo1 as(
  Select
    foo.id,
    foo.cnt
  From
    foo
  Where
    foo.cnt > 1
)
Select
  movie.id
from
  movie,
  foo1
where
  not EXISTS (
    select
      id
    from
      foo1
    where
      foo1.id = movie.id
  );

--query 4
With Foo as(
  select
    movie.id,
    movie.rating,
    pir1.person_id as director_id,
    pir2.person_id as actor_id
  from
    movie,
    person_imdbshow_rel pir1,
    person_imdbshow_rel pir2
  where
    movie.id = pir1.id
    and movie.id = pir2.id
    and pir1.worked_as = 'director'
    and pir2.worked_as = 'actor'
),
Foo1 as(
  select
    foo.director_id,
    foo.actor_id,
    count(id) as cnt
  From
    foo
  Group by
    foo.director_id,
    foo.actor_id
),
Foo2 as (
  Select
    foo1.actor_id,
    foo1.director_id,
    foo.rating,
    foo1.cnt,
    foo.id as movie_id
  From
    foo,
    foo1
  Where
    foo1.cnt <= 2
    and foo.rating > 7
    and foo.rating is not null
    and foo.actor_id = foo1.actor_id
    and foo.director_id = foo1.director_id
)
Select
  cc1.name as actor,
  cc2.name as director,
  foo2.rating,
  foo2.cnt
From
  cast_and_crew cc1,
  cast_and_crew cc2,
  foo2
Where
  cc1.person_id = foo2.actor_id
  and cc2.person_id = foo2.director_id;

  --query 5
with foo as (
  select
    Id,
    CASE When end_year is null then 2021 - start_year Else end_year - start_year END duration
  from
    tv_series
),
Foo1 as (
  select
    foo.id,
    start_year,
    end_year,
    duration
  from
    tv_series,
    foo
  where
    case when end_year is null then (2021 - start_year) = (
      select
        max(duration)
      from
        foo
    ) else (end_year - start_year) = (
      select
        max(duration)
      from
        foo
    ) End
    And tv_series.id = foo.id
)
Select
  original_title,
  start_year,
  end_year,
  duration
from
  Imdbshow,
  foo1
Where
  imdb_id = foo1.id;

--query 6
With foo as(
  Select
    *
  from
    movie
  Where
    releaseyear = 2020
),
Foo1 as (
  Select
    id,
    foo2.min
  from
    foo,
    (
      Select
        min(runtime)
      From
        foo
      Where
        runtime > (
          select
            min(runtime)
          from
            foo
        )
    ) as foo2
  Where
    runtime = foo2.min
)
Select
  name,
  foo1.min
from
  Cast_and_crew cc,
  foo1,
  (
    Select
      person_id
    from
      person_imdbshow_rel,
      foo1
    Where
      person_imdbshow_rel.id = foo1.id AND
      person_imdbshow_rel.worked_as = 'director'
  ) as foo3
Where
  foo3.person_id = cc.person_id;

--query 7
--for movie
With foo as(
  Select
    imdb_id,
    movie.rating
  from
    imdbshow,
    movie
  Where
    imdbshow.isadult = true
    AND imdbshow.imdb_id = movie.id
)
Select
  imdbshow.original_title,
  foo.rating
from
  imdbshow,
  foo,
  (
    Select
      foo.imdb_id
    from
      foo
    where
      foo.rating = (
        select
          min(rating)
        from
          foo
      )
  ) as foo1
Where
  foo1.imdb_id = foo.imdb_id
  and foo.imdb_id = imdbshow.imdb_id;
--for tv series
With foo as(
  Select
    imdb_id,
    tv_series.rating
  from
    imdbshow,
    tv_series
  Where
    imdbshow.isadult = true
    AND imdbshow.imdb_id = tv_series.id
)
Select
  imdbshow.original_title,
  foo.rating
from
  imdbshow,
  foo,
  (
    Select
      foo.imdb_id
    from
      foo
    where
      foo.rating = (
        select
          min(rating)
        from
          foo
      )
  ) as foo1
Where
  foo1.imdb_id = foo.imdb_id
  and foo.imdb_id = imdbshow.imdb_id;

 --query 8
With foo as(
  Select
    *
  from
    movie mv,
    person_imdbshow_rel pir
  Where
    mv.id = pir.id
    and pir.worked_as = 'director'
    and rating is not null
),
Foo1 as(
  select
    person_id,
    AVG(rating) AS avg_rating
  from
    foo
  group by
    person_id
),
Foo2 as(
  Select
    *
  from
    foo1
  where
    Avg_rating in (
      select
        distinct avg_rating
      from
        foo1
      order by
        avg_rating desc
      limit
        5
    )
)
Select
  name,
  avg_rating
from
  cast_and_crew cc,
  foo2
Where
  cc.person_id = foo2.person_id
order by
  avg_rating desc;

--query 9
With foo as(
  Select
    id,
    production_companies as pc,
    country
  From
    tv_series_production_companies,
    tv_loc_rel
  Where
    id = tvseries_id
)
Select
  original_title
from
  imdbshow,
  (
    Select
      foo.id
    From
      foo
    Group by
      foo.id
    Having
      count(country) > 2
      and count(foo.pc) > 1
  ) as foo1
Where
  imdbshow.imdb_id = foo1.id;

  --query 10
  Select
  name,
  foo.year
	from
	  cast_and_crew cc,
	  (
	    Select
	      person_id,
	      year
	    from
	      person_nomination,
	      award
	    where
	      Award_name = 'oscar'
	      and category = 'actor'
	      and award.award_id = person_nomination.award_id
	      and won = 't'
	  ) as foo
	Where
	  cc.person_id = foo.person_id
	Order by
	  year desc;

--query 11

With foo as (
  select
    movie.id,
    pir.person_id,
    movie.rating,
    pir.worked_as
  from
    movie,
    person_imdbshow_rel as pir
  Where
    movie.id = pir.id
    and (
      pir.worked_as = 'director'
      or pir.worked_as = 'assistant_director'
    )
    and rating is not null
),
Foo1 as(
  SELECT
    person_id,
    0.3 * count(id) as cnt
  from
    foo
  Group by
    person_id
),
Foo2 as(
  Select
    person_id,
    0.7 * 0.8 * AVG(rating) as avg_rating
  from
    foo
  Group by
    person_id,
    worked_as
  Having
    worked_As = 'director'
),
Foo3 as(
  Select
    person_id,
    Case When worked_as = 'assistant_director' then 0.7 * 0.2 * AVG(rating) Else 0 END avg_rating
  from
    foo
  Group by
    person_id,
    worked_as
)
Select
  cc.name,
  foo1.person_id,
  foo1.cnt + foo2.avg_rating + foo3.avg_rating as score
From
  foo1,
  foo2,
  foo3,
  cast_and_crew cc
Where
  foo1.person_id = foo2.person_id
  and foo1.person_id = foo3.person_id
  and cc.person_id = foo1.person_id
Order by
  score DESC;

--query 12
With foo as(
  Select
    imdb_id as mvid,
    genre,
    (box_office_gross - budget) as earnings,
    box_office_gross,
    budget
  From
    imdbshow,
    imdbshow_genre
  Where
    imdb_id = imdbshow_genre.id
    and box_office_gross != 0
    and budget != 0
),
Foo1 as(
  Select
    *
  from
    (
      Select
        mvid,
        genre,
        earnings,
        row_number() over (
          partition by genre
          order by
            earnings desc
        ) as rank
      From
        foo
    ) foo2
  Where
    rank <= 5
)
Select
  imdbshow.original_title,
  cc.name as director_name,
  foo1.genre,
  foo1.earnings,
  foo1.rank
From
  imdbshow,
  foo1,
  cast_and_crew cc,
  person_imdbshow_rel pir
Where
  foo1.mvid = imdbshow.imdb_id
  and pir.worked_as = 'director'
  and cc.person_id = pir.person_id
  and foo1.mvid = pir.id
order by
  genre,
  rank asc;

--query 13
With foo as(
  Select
    distinct pir.person_id
  from
    person_imdbshow_rel pir,
    tv_series
  Where
    pir.id = tv_series.id
    and (
      pir.worked_as = 'actor'
      or pir.worked_As = 'actress'
    )
),
Foo1 as (
  Select
    distinct pir.person_id
  from
    person_imdbshow_rel pir,
    movie
  Where
    pir.id = movie.id
    and (
      pir.worked_as = 'actor'
      or pir.worked_As = 'actress'
    )
)
select
  name
from
  cast_and_crew cc,
  (
    Select
      foo.person_id
    from
      foo,
      foo1
    where
      foo.person_id = foo1.person_id
  ) as actors
where
  cc.person_id = actors.person_id;

--query 14
With foo as (
  select
    releaseyear,
    MIN(episode_runtime)
  from
    episode
  group by
    releaseyear
),
Foo1 as(
  Select
    episode_id,
    episode.releaseyear
  from
    episode,
    foo
  Where
    foo.min = episode_runtime
    AND foo.releaseYear = episode.releaseYear
  ORDER BY
    episode.releaseYear ASC
)
Select
  imdbshow.original_title,
  foo1.releaseyear
From
  imdbshow,
  foo1
Where
  imdbshow.imdb_id = foo1.episode_id;

--query 15
With foo as(
  Select
    movie.id,
    movie.rating,
    imdbshow_genre.genre
  from
    movie,
    imdbshow_genre
  Where
    movie.id = imdbshow_genre.id
    and movie.rating is not null
),
foo2 as(
  Select
    *
  from
    (
      select
        id,
        Genre,
        Rating,
        row_number() over (
          partition by genre
          order by
            rating desc
        ) as movie_rank
      from
        foo
    ) foo1
  Where
    movie_rank <= 3
)
Select
  imdbshow.original_title,
  foo2.genre,
  foo2.rating,
  foo2.movie_rank
From
  imdbshow,
  foo2
Where
  foo2.id = imdbshow.imdb_id
order by
  genre asc;

--query 16
Select
  original_title
from
  imdbshow,
  ImdbShow_Shooting_loc
Where
  imdbshow.imdb_id = ImdbShow_Shooting_loc.id
  and Shooting_loc = 'Switzerland';

--query 17
Select
  original_title,
  country
from
  Imdbshow,
  movie,
  mvie_loc_rel
Where
  releaseyear = 1995
  and isAdult = true
  and imdbshow.imdb_id = mvie_loc_rel.movie_id
And imdbshow.imdb_id = movie.id
Order by
  Country;

--query 18
With foo as(
  Select
    cc.name,
    cc.person_id,
    pp.profession,
    cc.birth_year
  from
    cast_and_crew cc,
    primary_profession pp
  Where
    cc.person_id = pp.id
    and cc.birth_year is not null
),
Foo1 as(
  select
    profession,
    MAX(birth_year)
  from
    foo
  group by
    profession
)
Select
  foo.name,
  foo.profession,
  foo.birth_year
From
  foo1,
  foo
Where
  foo1.profession = foo.profession
  and foo1.max = foo.birth_year
  and foo.profession is not null
Order by
  profession;

--query 19
with foo as(
  select
    id,
    person_id
  from
    person_imdbshow_rel
  where
    worked_as = 'composer'
    or worked_as = 'archive_sound'
)
select
  name,
  count
from
  cast_and_crew cc,
  (
    SELECT
      count(id),
      person_id
    FROM
      foo
    GROUP BY
      person_id
    HAVING
      COUNT(id) > 4
  ) as foo1
where
  foo1.person_id = cc.person_id;

--query 20
With foo as (
  Select
    count(person_id)
  from
    person_imdbshow_rel pir,
    (
      Select
        imdb_id
      from
        imdbshow
      where
        original_title = 'Khaleja'
    ) as mvnm
  Where
    pir.id = mvnm.imdb_id
),
foo1 as(
  select
    id,
    person_id
  from
    person_imdbshow_rel
  where
    worked_as = 'actor'
    or worked_as = 'actress'
)
select
  name
from
  cast_and_crew cc,
  (
    Select
      person_id,
      count(id)
    from
      foo1,
      foo
    Group by
      person_id
    having
      count(id) in (
        select
          count
        from
          foo
      )
  ) as list
where
  cc.person_id = list.person_id;
