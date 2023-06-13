USE University_DB;
--Count of universities by year and ranking system
--output - Ranking System | Year | Count of Universities
SELECT system_name as 'Ranking System', year, COUNT(university.id) 'Count of Universities'
FROM 
dbo.university
JOIN dbo.university_ranking_year ON (dbo.university.id=dbo.university_ranking_year.university_id)
JOIN dbo.ranking_criteria ON (dbo.university_ranking_year.ranking_criteria_id=dbo.ranking_criteria.id)
JOIN dbo.ranking_system ON (dbo.ranking_criteria.ranking_system_id=dbo.ranking_system.id)
group by year, system_name
;


--The university having second least numbers of students by year without using TOP, LIMIT and other similar keywords
--output - Year | University | Number of Students
SELECT  year, university_name, num_students
FROM dbo.university
JOIN dbo.university_year ON (dbo.university.id=dbo.university_year.university_id)
WHERE 
num_students = (SELECT MIN(num_students) FROM dbo.university_year
				WHERE  num_students > (SELECT MIN(num_students) FROM dbo.university_year));

--All top ranking universities by year and ranking criteria
--output - Year | Ranking Criteria | University

SELECT DISTINCT year, criteria_name 'Ranking Criteria', university_name 'University'
FROM 
(SELECT year, criteria_name,university_name, ranking_criteria.id id,
RANK() OVER(PARTITION BY year,ranking_criteria.id order by score desc) as rnk
FROM dbo.university
JOIN dbo.university_ranking_year ON (dbo.university.id=dbo.university_ranking_year.university_id)
JOIN dbo.ranking_criteria ON (dbo.university_ranking_year.ranking_criteria_id=dbo.ranking_criteria.id)
JOIN dbo.ranking_system ON (dbo.ranking_criteria.ranking_system_id=dbo.ranking_system.id)
) A 
WHERE rnk=1
order by year;


--All universities having highest numbers of students by year and country
--output - Year | Country | University

SELECT DISTINCT year, country_name 'Country', university_name 'University'
FROM 
(SELECT year, country_name,university_name,
RANK() OVER(PARTITION BY year,dbo.university.country_id order by num_students desc) as rnk
FROM dbo.university
JOIN dbo.university_year ON (dbo.university.id=dbo.university_year.university_id)
JOIN dbo.country ON (dbo.university.country_id=dbo.country.id)
) A 
WHERE rnk=1
order by year;

--Top 3 universities by country
--output - Country | University


SELECT country_name 'Country', university_name 'University'--,rnk
FROM 
(SELECT country_name,university_name,
RANK() OVER(PARTITION BY dbo.university.country_id order by score desc) as rnk
FROM dbo.university
JOIN dbo.country ON (dbo.university.country_id=dbo.country.id)
JOIN dbo.university_ranking_year ON (dbo.university.id=dbo.university_ranking_year.university_id)
) A 
WHERE rnk<4
order by country_name;


--Universities having highest percent of female students by country
--output - country | university | num of students | percent of female students
SELECT DISTINCT country_name country, university_name university, num_students,pct_female_students
FROM 
(SELECT country_name, university_name, num_students,pct_female_students,
RANK() OVER(PARTITION BY country_id order by pct_female_students desc) as rnk
FROM dbo.university
JOIN dbo.university_year ON (dbo.university.id=university_year.university_id)
JOIN dbo.country ON (dbo.university.country_id=dbo.country.id)
) A 
WHERE rnk=1;

--Universities having highest percent of international students by year and country
--output - country | Year | university | num of students | percent of International students

SELECT DISTINCT country_name, year, university_name, num_students,pct_international_students
FROM 
(SELECT country_name,year, university_name, num_students,pct_international_students,
RANK() OVER(PARTITION BY year,country_id order by pct_international_students desc) as rnk
FROM dbo.university
JOIN dbo.university_year ON (dbo.university.id=university_year.university_id)
JOIN dbo.country ON (dbo.university.country_id=dbo.country.id)
) A 
WHERE rnk=1
order by year;


--Universities having highest percent of student staff ratio by country
--output - country | university | num of students | percent of student staff ratio

SELECT DISTINCT country_name 'country', university_name 'university', num_students 'num of students', per_SSR 'percent of student staff ratio'
FROM dbo.university
JOIN dbo.university_year ON (dbo.university.id=university_year.university_id)
JOIN dbo.country ON (dbo.university.country_id=dbo.country.id)
JOIN (SELECT university_id,student_staff_ratio,
	(student_staff_ratio/COUNT(student_staff_ratio)*100) per_SSR
	FROM dbo.university_year
	group by university_id,student_staff_ratio) A ON (dbo.university.id=A.university_id);

