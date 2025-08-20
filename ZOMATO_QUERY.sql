CREATE DATABASE zomato_db;
SHOW DATABASES;
USE zomato_db;

CREATE TABLE Restaurants (
  RestaurantID INT,
  RestaurantName VARCHAR(255),
  CountryCode INT,
  City VARCHAR(100),
  Address TEXT,
  Locality VARCHAR(100),
  LocalityVerbose VARCHAR(100),
  Longitude FLOAT,
  Latitude FLOAT,
  Cuisines VARCHAR(255),
  Currency VARCHAR(100),
  Has_Table_booking VARCHAR(10),
  Has_Online_delivery VARCHAR(10),
  Is_delivering_now VARCHAR(10),
  Switch_to_order_menu VARCHAR(10),
  Price_range INT,
  Votes INT,
  Average_Cost_for_two INT,
  Rating FLOAT,
  Datekey_Opening VARCHAR(20)
);
SHOW TABLES;
SELECT COUNT(*) FROM Restaurants;
SELECT * FROM Restaurants LIMIT 10;
DESCRIBE Restaurants;

SELECT * FROM Restaurants
WHERE RestaurantName IS NULL OR CountryCode IS NULL;
-------------------------------------------------------------------

#1. Build a Country Map Table
CREATE TABLE CountryMap (
    CountryCode INT PRIMARY KEY,
    CountryName VARCHAR(100)
);

INSERT INTO CountryMap (CountryCode, CountryName)
VALUES
    (1, 'India'),
    (14, 'Australia'),
    (30, 'Brazil'),
    (37, 'Canada'),
    (94, 'Indonesia'),
    (148, 'New Zealand'),
    (162, 'Philippines'),
    (166, 'Qatar'),
    (184, 'Singapore'),
    (189, 'South Africa'),
    (191, 'Sri Lanka'),
    (208, 'Turkey'),
    (214, 'United Arab Emirates'),
    (215, 'England'),
    (216, 'United States');
##SQL: Join CountryMap with Restaurants
SHOW TABLES;
DESCRIBE restaurants;

ALTER TABLE restaurants
CHANGE COLUMN `ï»¿RestaurantID` RestaurantID INT;

SELECT
    r.RestaurantID,
    r.RestaurantName,
    r.City,
    r.Locality,
    r.Cuisines,
    r.Price_range,
    r.Rating,
    r.Votes,
    r.Average_Cost_for_two,
    c.CountryName
FROM
    restaurants r
JOIN
    CountryMap c
ON
    r.CountryCode = c.CountryCode;
  
#2. Create the CalendarTable
CREATE TABLE CalendarTable (
    DateValue DATE,
    Year INT,
    MonthNo INT,
    MonthFullName VARCHAR(15),
    Quarter VARCHAR(2),
    YearMonth VARCHAR(10),
    WeekdayNo INT,
    WeekdayName VARCHAR(10),
    FinancialMonth VARCHAR(5),
    FinancialQuarter VARCHAR(3)
);

## Insert Data with All Calculated Columns
INSERT INTO CalendarTable (DateValue, Year, MonthNo, MonthFullName, Quarter, YearMonth, WeekdayNo, WeekdayName, FinancialMonth, FinancialQuarter)
SELECT
    STR_TO_DATE(Datekey_Opening, '%Y_%c_%e') AS DateValue,
    YEAR(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) AS Year,
    MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) AS MonthFullName,
    CONCAT('Q', QUARTER(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e'))) AS Quarter,
    DATE_FORMAT(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e'), '%Y-%b') AS YearMonth,
    DAYOFWEEK(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) AS WeekdayNo,
    DAYNAME(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) AS WeekdayName,
    
    -- Financial Month: April = FM1 ... March = FM12
    CASE 
        WHEN MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) >= 4 THEN CONCAT('FM', MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) - 3)
        ELSE CONCAT('FM', MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) + 9)
    END AS FinancialMonth,

    -- Financial Quarter based on Financial Month
    CASE 
        WHEN MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) BETWEEN 10 AND 12 THEN 'FQ3'
        ELSE 'FQ4'
    END AS FinancialQuarter

FROM
    restaurants;

##Insert Data with All Calculated Columns
INSERT INTO CalendarTable (DateValue, Year, MonthNo, MonthFullName, Quarter, YearMonth, WeekdayNo, WeekdayName, FinancialMonth, FinancialQuarter)
SELECT
    STR_TO_DATE(Datekey_Opening, '%Y_%c_%e') AS DateValue,
    YEAR(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) AS Year,
    MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) AS MonthFullName,
    CONCAT('Q', QUARTER(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e'))) AS Quarter,
    DATE_FORMAT(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e'), '%Y-%b') AS YearMonth,
    DAYOFWEEK(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) AS WeekdayNo,
    DAYNAME(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) AS WeekdayName,
    
    -- Financial Month: April = FM1 ... March = FM12
    CASE 
        WHEN MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) >= 4 THEN CONCAT('FM', MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) - 3)
        ELSE CONCAT('FM', MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) + 9)
    END AS FinancialMonth,

    -- Financial Quarter based on Financial Month
    CASE 
        WHEN MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN MONTH(STR_TO_DATE(Datekey_Opening, '%Y_%c_%e')) BETWEEN 10 AND 12 THEN 'FQ3'
        ELSE 'FQ4'
    END AS FinancialQuarter

FROM
    restaurants;

#3 Find the Numbers of Resturants based on City and Country.
SELECT
    r.City,
    c.CountryName,
    COUNT(*) AS NumberOfRestaurants
FROM
    restaurants r
JOIN
    CountryMap c
ON
    r.CountryCode = c.CountryCode
GROUP BY
    r.City, c.CountryName
ORDER BY
    NumberOfRestaurants DESC;

#4.Numbers of Resturants opening based on Year , Quarter , Month
SELECT
    YEAR(STR_TO_DATE(r.Datekey_Opening, '%Y_%c_%e')) AS OpeningYear,
    QUARTER(STR_TO_DATE(r.Datekey_Opening, '%Y_%c_%e')) AS OpeningQuarter,
    MONTH(STR_TO_DATE(r.Datekey_Opening, '%Y_%c_%e')) AS OpeningMonth,
    COUNT(*) AS NumberOfRestaurants
FROM
    restaurants r
GROUP BY
    OpeningYear, OpeningQuarter, OpeningMonth
ORDER BY
    OpeningYear, OpeningQuarter, OpeningMonth;

#5. Count of Resturants based on Average Ratings
SELECT
    Rating,
    COUNT(*) AS NumberOfRestaurants
FROM
    restaurants
GROUP BY
    Rating
ORDER BY
    Rating DESC;
#6 Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
SELECT
  CASE
    WHEN Average_Cost_for_two <= 250 THEN 'Budget'
    WHEN Average_Cost_for_two BETWEEN 251 AND 500 THEN 'Affordable'
    WHEN Average_Cost_for_two BETWEEN 501 AND 1000 THEN 'Mid-range'
    WHEN Average_Cost_for_two BETWEEN 1001 AND 2000 THEN 'Premium'
    ELSE 'Luxury'
  END AS Price_Bucket,
  COUNT(*) AS NumberOfRestaurants
FROM
  restaurants
GROUP BY
  Price_Bucket
ORDER BY
  MIN(Average_Cost_for_two);

#7 Percentage of Resturants based on "Has_Table_booking"
SELECT
  Has_Table_booking,
  COUNT(*) AS NumberOfRestaurants,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM restaurants), 2) AS Percentage
FROM
  restaurants
GROUP BY
  Has_Table_booking;
#8 Percentage of Resturants based on "Has_Online_delivery"

SELECT
  Has_Online_delivery,
  COUNT(*) AS NumberOfRestaurants,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM restaurants), 2) AS Percentage
FROM
  restaurants
GROUP BY
  Has_Online_delivery;
#9 Develop Charts based on Cusines, City, Ratings
##Cuisines: Top 10 Most Common Cuisines
SELECT
  City,
  COUNT(*) AS NumberOfRestaurants
FROM
  restaurants
GROUP BY
  City
ORDER BY
  NumberOfRestaurants DESC
LIMIT 10;

##City: Number of Restaurants per City (Top 10)
SELECT
  City,
  COUNT(*) AS NumberOfRestaurants
FROM
  restaurants
GROUP BY
  City
ORDER BY
  NumberOfRestaurants DESC
LIMIT 10;

##Ratings: Distribution of Ratings
SELECT
  Rating,
  COUNT(*) AS NumberOfRestaurants
FROM
  restaurants
GROUP BY
  Rating
ORDER BY
  Rating DESC;

