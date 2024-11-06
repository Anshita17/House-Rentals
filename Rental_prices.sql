SELECT * FROM Houses.rental_prices;
use Houses;



-- Count Nulls --
select count(*) - count(house_type) AS count from rental_prices;
select count(*) - count(locality) AS count from rental_prices ;
select count(*) - count(city) AS count from rental_prices ;
select count(*) - count(area)  AS count from rental_prices ;
select count(*) - count(beds)  AS count from rental_prices ;
select count(*) - count(bathrooms) AS count from rental_prices;
select count(*) - count(balconies) AS count from rental_prices;
select count(*) - count(furnishing) AS count from rental_prices AS count;
select count(*) - count(area_rate) AS count from rental_prices AS count;
select count(*) - count(rent) AS count from rental_prices AS count;

-- Check Duplicates --
SELECT 
    house_type, locality, city, area, beds, bathrooms, balconies, furnishing, area_rate, rent, 
    COUNT(*) as duplicate_count
FROM 
    rental_prices
GROUP BY 
    house_type,locality, city, area, beds, bathrooms, balconies, furnishing, area_rate, rent
HAVING 
    COUNT(*) > 1;

SELECT * FROM Houses.rental_prices;
use Houses;

SELECT house_type, count(house_type) AS Count from rental_prices
GROUP BY house_type
ORDER BY Count DESC;

select count(house_type) from rental_prices;

SELECT house_type,city, count(house_type) AS Count from rental_prices
GROUP BY house_type, city
ORDER BY Count DESC;


select city,count(house_type) from rental_prices
group by city;

SELECT house_type,city, count(house_type) AS Count from rental_prices
GROUP BY house_type, city
ORDER BY city,Count DESC;



WITH total AS (
    SELECT 
        house_type,
        city,
        locality,
        COUNT(house_type) AS Count
    FROM 
        rental_prices
    GROUP BY 
        house_type, city, locality
)
SELECT 
    house_type,
    city,
    locality,
    Count,
    RANK() OVER (PARTITION BY house_type,city,locality ORDER BY Count DESC ) AS Position
FROM 
    total

ORDER BY 
    city,
    Count DESC;
    
    use Houses;
    
    
    ---------------------------
    SELECT house_type, count(house_type) AS Count from rental_prices
GROUP BY house_type
ORDER BY Count DESC;


SELECT house_type,city, count(house_type) AS Count from rental_prices
GROUP BY house_type, city
ORDER BY Count DESC;


select city,count(house_type) from rental_prices
group by city;

SELECT house_type,city, count(house_type) AS Count from rental_prices
GROUP BY house_type, city
ORDER BY city,Count DESC;



WITH total AS (
    SELECT 
        house_type,
        city,
        locality,
        COUNT(house_type) AS Count
    FROM 
        rental_prices
    GROUP BY 
        house_type, city, locality
)
SELECT 
    house_type,
    city,
    locality,
    Count,
    RANK() OVER (PARTITION BY house_type,city,locality ORDER BY Count DESC ) AS Position
FROM 
    total

ORDER BY 
    city,
    Count DESC;
    
      
select max(area) as Area , city from rental_prices
    group by city
    order by area desc;




SELECT 
    MAX(area) AS Area,
    city,
    RANK() OVER (ORDER BY MAX(area) DESC) AS position
FROM 
    rental_prices
GROUP BY 
    city
ORDER BY 
    Area DESC;
    
    
    
SELECT
    house_type, 
    city,
    beds,
    bathrooms,
    balconies,
    AVG(rent) AS average_rent,
    RANK() OVER (ORDER BY AVG(rent) DESC) AS rent_rank
FROM 
    rental_prices
GROUP BY 
    city,house_type, beds, bathrooms, balconies
ORDER BY 
     average_rent desc;
     
     
     
     
     SELECT 
    house_type,beds,
    AVG(rent) AS average_rent
FROM 
    rental_prices
GROUP BY 
    house_type,beds
ORDER BY 
    average_rent DESC
LIMIT 1;  -- Limits the result to the top entry



-- max rent in that house_type --
     
 WITH MaxRent AS (
    SELECT 
        house_type,
        MAX(rent) AS Maximum
    FROM 
        rental_prices
    GROUP BY 
        city,house_type
)

SELECT 
    r.house_type,
    r.rent,
    r.city
FROM 
    rental_prices r
JOIN 
    MaxRent m ON r.house_type = m.house_type
WHERE 
    r.rent >= m.Maximum
    order by rent desc;
    
   -- villas -- 
    select house_type,city from rental_prices
    WHERE house_type LIKE '%villa %'
    order by city;
;



-- Furninshing vs rent --

SELECT furnishing, MIN(rent) AS minimum_rent
FROM rental_prices
GROUP BY furnishing
HAVING MIN(rent) >= (SELECT MIN(rent) FROM rental_prices);



-- beds,bathrooms,rent --
select house_type,beds,bathrooms,city, rent from rental_prices
where beds>3
order by beds desc,bathrooms desc,rent desc;

-- Which cities have the highest and lowest average rental prices? --
select city, avg(rent) from rental_prices
group by city
having avg(rent)<= (
select avg(rent) as rent from rental_prices)
order by avg(rent) desc;

select city, avg(rent) from rental_prices
group by city
having avg(rent)>= (
select avg(rent) as rent from rental_prices)
order by avg(rent) desc;

-- How does the average rent differ by locality within each city --

select city,locality, avg(rent) from rental_prices
group by city,locality
having avg(rent)>= (
select avg(rent) as rent from rental_prices)
order by city ,avg(rent) desc;

-- What is the correlation between area rate (₹/sqft) and average rent across cities?--
SELECT city,
       AVG(rent) AS avg_rent,
       AVG(area_rate) AS avg_area_rate
FROM rental_prices
GROUP BY city
order by avg_rent desc;




-- area rent vs  rent more than avg rent --
SELECT area_rate, AVG(rent) AS avg_rent, city
FROM rental_prices
GROUP BY city, area_rate
HAVING AVG(rent) >= (SELECT AVG(rent) FROM rental_prices);

-- Average Rent by Number of Bedrooms and City --
SELECT city,locality,
       beds,
       AVG(rent) AS avg_rent
FROM rental_prices
GROUP BY city, locality,beds
ORDER BY city ,avg_rent desc,beds desc;

-- Average Rent by Furnishing Type --
SELECT furnishing,
       AVG(rent) AS avg_rent
FROM rental_prices
GROUP BY furnishing
ORDER BY avg_rent DESC;

SELECT furnishing,
       Max(rent) AS max_rent
FROM rental_prices
GROUP BY furnishing
ORDER BY max_rent DESC;

-- Average Rent by Number of Bathrooms and Balconies --
SELECT city,
bathrooms,
       balconies,
       AVG(rent) AS avg_rent
FROM rental_prices
GROUP BY city,bathrooms, balconies
ORDER BY avg_rent DESC;


-- Properties with Multiple Amenities and Higher Area Rates --

SELECT COUNT(*) AS num_properties,
       AVG(area_rate) AS avg_area_rate,
       SUM(CASE WHEN bathrooms >= 2 THEN 1 ELSE 0 END) AS properties_with_2_or_more_bathrooms,
       SUM(CASE WHEN balconies >= 1 THEN 1 ELSE 0 END) AS properties_with_balconies
FROM rental_prices
WHERE area_rate > (SELECT AVG(area_rate) FROM rental_prices);



-- Comparing Rental Prices by Furnishing Status -- 




-- Average Rent Characteristics --
WITH Rent_Characteristics AS (
    SELECT city,
           locality,
           rent,
           area_rate,
           beds,
           bathrooms,
           balconies,
           furnishing,
           ROW_NUMBER() OVER (PARTITION BY city ORDER BY rent DESC) AS rent_rank_high,
           ROW_NUMBER() OVER (PARTITION BY city ORDER BY rent ASC) AS rent_rank_low
    FROM rental_prices
)

SELECT city,
       AVG(rent) AS average_rent,
       MIN(rent) AS lowest_rent,
       MAX(rent) AS highest_rent,
       COUNT(*) AS property_count
FROM Rent_Characteristics
GROUP BY city;


























