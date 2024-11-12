
# House Rental Pricing across various cities in India
This project aims to conduct a comprehensive analysis of rental prices in residential properties, by employing data analytics techniques. The project seeks to generate insights that can inform landlords, property managers, and potential tenants about pricing dynamics in the rental market.

<img width="1437" alt="House Rental Pricing across Cities in India" src="https://github.com/user-attachments/assets/a88941e2-ce9c-48ed-9e3e-26e41e9d89a2">

# Objective
Analyze rental price trends in the housing market across various cities in India by providing insights into the dynamics of the rental market.
# Dataset Overview
The dataset has 10 feature columns namely:
house_type: Title of the property.  
locality: Locality of the property.  
city: City to with the property belong.  
area: Property area in sq ft.  
beds: Number of bedrooms in the property.  
bathrooms: Number of bathrooms in the property.  
balconies: Number of balconies in the property.  
furnishing: Furnishing status of the property.  
area_rate: Property area rate in Indian Rupees (₹)/sqft.  
rent: Monthly property rent in Indian Rupees (₹).  
# Platforms Used
* SQL
* Tableau

# Analysis

## Max Area By Each City
```
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
```
## Available Rentals by each city
```
SELECT house_type, count(house_type) AS Count from rental_prices
GROUP BY house_type
ORDER BY Count DESC;
```
## Types of houses by locality, count
```
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
```
## Rank by beds,baths,balconies
```   
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
```
# Max rent in that house type 
```
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
```
## Properties with Multiple Amenities and Higher Area Rates 
```
SELECT COUNT(*) AS num_properties,
       AVG(area_rate) AS avg_area_rate,
       SUM(CASE WHEN bathrooms >= 2 THEN 1 ELSE 0 END) AS properties_with_2_or_more_bathrooms,
       SUM(CASE WHEN balconies >= 1 THEN 1 ELSE 0 END) AS properties_with_balconies
FROM rental_prices
WHERE area_rate > (SELECT AVG(area_rate) FROM rental_prices);
```
# Average Rent Characteristics 
```

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
```

# SQL Skills
* CTE (Common Table Expressions): Utilized CTEs to break down complex queries into simpler, more manageable parts, making it easier to analyze rental pricing trends across different locations and property types.

* Window Functions: Applied window functions like ROW_NUMBER(), RANK(), and PARTITION BY to rank properties based on price, analyze pricing patterns across different time periods, and partition data by location or property type to extract insights for better decision-making.

* COUNT Function: Leveraged the COUNT() function to determine the number of rental listings in a given price range, track the number of properties per location, and count specific property features such as amenities or square footage.

* Advanced Aggregation: Combined COUNT(), AVG(), MAX(), and MIN() to analyze rental price distributions and identify trends in rental pricing across different property categories

  
# Visualisation 

## Tableau Link :   [Click Here](https://public.tableau.com/views/RentalPricingacrosscitiesinIndia/RentalPrices?:language=en-GB&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

