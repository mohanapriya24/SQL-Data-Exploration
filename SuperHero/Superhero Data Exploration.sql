USE Superhero_DB;

--The superheros who do not have any gender (i.e. N/A).
SELECT superhero_name 
FROM dbo.superhero 
JOIN dbo.gender ON (dbo.superhero.gender_id=dbo.gender.id)
where dbo.gender.gender='N/A';

--The count of superheroes by alignment.
SELECT COUNT(superhero_name) as count, alignment
FROM dbo.superhero
JOIN dbo.alignment
ON (dbo.superhero.alignment_id = dbo.alignment.id)
GROUP BY alignment_id,alignment;

--The name of all the superheroes who do not have any publisher.
SELECT superhero_name
FROM dbo.superhero 
WHERE publisher_id IS NULL;

--All superheroes played by the same person
--output : superhero_name | Full_name
SELECT DISTINCT(A.superhero_name),B.full_name
FROM  dbo.superhero A, dbo.superhero B
WHERE 
A.id<>B.id AND
A.full_name=B.full_name
ORDER BY B.full_name desc;

SELECT STRING_AGG(superhero_name,',') AS SUPERHERO, full_name
FROM dbo.superhero 
GROUP BY full_name;

--Show top 20 heaviest superheroes.
SELECT TOP 20 * FROM dbo.superhero ORDER BY weight_kg DESC;

--All female superheroes whose publisher is 'Marvel Comics' and race is 'Mutant'.
SELECT * 
FROM dbo.superhero 
JOIN dbo.gender ON (dbo.superhero.gender_id=dbo.gender.id)
JOIN dbo.publisher ON (dbo.superhero.publisher_id = dbo.publisher.id)
where dbo.gender.gender='Female'
AND (dbo.publisher.publisher_name='Marvel Comics' OR dbo.publisher.publisher_name='Mutant')
;


--Top 5 superheroes who have highest number of powers.
--Superhero_name | Full_name | Publisher | Race | Power_Count

select top 5(superhero_name),full_name,publisher_name,race,count(power_id) as power_count from superhero
LEFT JOIN superpower on superpower.id=superhero.id 
LEFT JOIN publisher on publisher.id=superhero.publisher_id
LEFT JOIN race on race.id=superhero.race_id
LEFT JOIN hero_power on hero_power.hero_id=superhero.id 
GROUP BY superhero_name,full_name,publisher_name,race
ORDER BY power_count DESC;

--All of the superheroes and the sum of their attributes, including those with no attributes.
--id | superhero_name | publisher_name | total_attributes

SELECT dbo.superhero.id,Superhero_Name, Full_Name, publisher_name, count(attribute_id) total_attributes
FROM dbo.superhero 
LEFT JOIN dbo.publisher ON (dbo.superhero.publisher_id = dbo.publisher.id)
LEFT JOIN dbo.hero_attribute ON (dbo.superhero.id = dbo.hero_attribute.hero_id)
GROUP BY dbo.superhero.id,Superhero_Name, Full_Name, publisher_name
ORDER BY total_attributes;


--All the superheroes who have all the attributes arrange by Publishers
--superhero_name | Full_name | Publisher | Power_name | attribute_name

SELECT Superhero_Name, Full_Name, publisher_name Publisher, count(attribute_id) total_attributes
FROM dbo.superhero 
LEFT JOIN dbo.publisher ON (dbo.superhero.publisher_id = dbo.publisher.id)
LEFT JOIN dbo.hero_attribute ON (dbo.superhero.id = dbo.hero_attribute.hero_id)
GROUP BY Superhero_Name, Full_Name, publisher_name
ORDER BY Publisher DESC;

--View to show below fields:
--Superhero_Name | Full_Name | Publisher | Gender | Race | Alignment | Power | Attribute

CREATE VIEW dbo.superhero_details AS
SELECT Superhero_Name, Full_Name, publisher_name Publisher, Gender, Race, Alignment, STRING_AGG(power_name,',') Power, STRING_AGG(attribute_name,',') Attribute 
FROM dbo.superhero 
LEFT JOIN dbo.race ON (dbo.superhero.race_id=dbo.race.id)
LEFT JOIN dbo.publisher ON (dbo.superhero.publisher_id = dbo.publisher.id)
LEFT JOIN dbo.gender ON (dbo.superhero.gender_id = dbo.gender.id)
LEFT JOIN dbo.alignment ON (dbo.superhero.alignment_id = dbo.alignment.id)
LEFT JOIN dbo.hero_attribute ON (dbo.superhero.id = dbo.hero_attribute.hero_id)
LEFT JOIN dbo.attribute ON (dbo.hero_attribute.attribute_id = dbo.attribute.id)
LEFT JOIN dbo.hero_power ON (dbo.superhero.id = dbo.hero_power.hero_id)
LEFT JOIN dbo.superpower ON (dbo.hero_power.power_id = dbo.superpower.id)
GROUP BY Superhero_Name, Full_Name, publisher_name, Gender, Race, Alignment;
