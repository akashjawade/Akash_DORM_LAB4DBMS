-- Creating the database --
CREATE DATABASE IF NOT EXISTS ecommerce_store;

-- Using the created Database --
USE ecommerce_store;

-- 1) CREATE TABLES --

-- Creating table Supplier --
CREATE TABLE IF NOT EXISTS supplier(
    SUPP_ID INT UNSIGNED PRIMARY KEY,
    SUPP_NAME VARCHAR(50) NOT NULL,
    SUPP_CITY VARCHAR(50) NOT NULL,
    SUPP_PHONE VARCHAR(50) NOT NULL
);

-- Creating table customer --
CREATE TABLE IF NOT EXISTS customer(
    CUS_ID INT UNSIGNED PRIMARY KEY,
    CUS_NAME VARCHAR(20) NOT NULL,
    CUS_PHONE VARCHAR(15) NOT NULL,
    CUS_CITY VARCHAR(30) NOT NULL,
    CUS_GENDER ENUM('M','F') NOT NULL
);

-- Creating table Catogory --
CREATE TABLE IF NOT EXISTS category(
    CAT_ID INT UNSIGNED PRIMARY KEY,
    CAT_NAME VARCHAR(20) NOT NULL
);

-- Creating table product -- 
CREATE TABLE IF NOT EXISTS product(
    PRO_ID INT UNSIGNED PRIMARY KEY,
    PRO_NAME VARCHAR(20) NOT NULL DEFAULT "dummy",
    PRO_DESC VARCHAR(100) NOT NULL,
    CAT_ID INT UNSIGNED NOT NULL,
    FOREIGN KEY(CAT_ID) REFERENCES category(CAT_ID)
);

-- Creating table supplier_pricing --
CREATE TABLE IF NOT EXISTS supplier_pricing(
    PRICING_ID INT UNSIGNED PRIMARY KEY,
    PRO_ID INT UNSIGNED NOT NULL,
    FOREIGN KEY(PRO_ID) REFERENCES product(PRO_ID),
    SUPP_ID INT UNSIGNED NOT NULL,
    FOREIGN KEY(SUPP_ID) REFERENCES supplier(SUPP_ID),
    SUPP_PRICE INT UNSIGNED NOT NULL DEFAULT 0
);

-- Creating table order --    
CREATE TABLE IF NOT EXISTS `order`(
    ORD_ID INT UNSIGNED PRIMARY KEY,
    ORD_AMOUNT INT NOT NULL,
    ORD_DATE DATE NOT NULL,
    CUS_ID INT UNSIGNED NOT NULL,
    FOREIGN KEY(CUS_ID) REFERENCES customer(CUS_ID),
    PRICING_ID INT UNSIGNED NOT NULL,
    FOREIGN KEY(PRICING_ID) REFERENCES supplier_pricing(PRICING_ID)
);

-- Creating table rating --
CREATE TABLE IF NOT EXISTS rating(
    RAT_ID INT UNSIGNED PRIMARY KEY,
    ORD_ID INT UNSIGNED NOT NULL,
    FOREIGN KEY(ORD_ID) REFERENCES `order`(ORD_ID),
    RAT_STARS INT NOT NULL
);

-- 2) INSERT DATA --
INSERT INTO Supplier 
VALUES
(1,"Rajesh Retails","Delhi",'1234567890'),
(2,"Appario Ltd.","Mumbai",'2589631470'),
(3,"Knome products","Banglore",'9785462315'),
(4,"Bansal Retails","Kochi",'8975463285'),
(5,"Mittal Ltd.","Lucknow",'7898456532');

INSERT INTO customer 
VALUES
(1,"AAKASH",'9999999999',"DELHI",'M'),
(2,"AMAN",'9785463215',"NOIDA",'M'),
(3,"NEHA",'9999999999',"MUMBAI",'F'),
(4,"MEGHA",'9994562399', "KOLKATA",'F'),
(5,"PULKIT",'7895999999',"LUCKNOW",'M');

INSERT INTO category
VALUES
( 1,"BOOKS"),
(2,"GAMES"),
(3,"GROCERIES"),
(4,"ELECTRONICS"),
(5,"CLOTHES");

INSERT INTO product
VALUES
(1,"GTA V","Windows 7 and above with i5 processor and 8GB RAM",2),
(2,"TSHIRT","SIZE-L with Black, Blue and White variations",5),
(3,"ROG LAPTOP","Windows 10 with 15inch screen, i7 processor, 1TB SSD",4),
(4,"OATS","Highly Nutritious from Nestle",3),
(5,"HARRY POTTER","Best Collection of all time by J.K Rowling",1),
(6,"MILK","1L Toned MIlk",3),
(7,"Boat EarPhones","1.5Meter long Dolby Atmos",4),
(8,"Jeans","Stretchable Denim Jeans with various sizes and color",5),
(9,"Project IGI","compatible with windows 7 and above",2),
(10,"Hoodie","Black GUCCI for 13 yrs and above",5),
(11,"Rich Dad Poor Dad","Written by RObert Kiyosaki",1),
(12,"Train Your Brain","By Shireen Stephen",1);

INSERT INTO supplier_pricing
VALUES
(1,1,2,1500),
(2,3,5,30000),
(3,5,1,3000),
(4,2,3,2500),
(5,4,1,1000),
(6,12,2,780),
(7,12,4,789),
(8,3,1,31000),
(9,1,5,1450),
(10,4,2,999),
(11,7,3,549),
(12,7,4,529),
(13,6,2,105),
(14,6,1,99),
(15,2,5,2999),
(16,5,2,2999);

INSERT INTO `order`
VALUES
(101,1500,"2021-10-06",2,1),
(102,1000,"2021-10-12",3,5),
(103,30000,"2021-09-16",5,3),
(104,1500,"2021-10-05",1,1),
(105,3000,"2021-08-16",4,3),
(106,1450,"2021-08-18",1,9),
(107,789,"2021-09-01",3,7),
(108,780,"2021-09-07",5,6),
(109,3000,"2021-09-10",5,3),
(110,2500,"2021-09-10",2,4),
(111,1000,"2021-09-15",4,5),
(112,789,"2021-09-16",4,7),
(113,31000,"2021-09-16",1,8),
(114,1000,"2021-09-16",3,5),
(115,3000,"2021-09-16",5,3),
(116,99,"2021-09-17",2,14);

INSERT INTO rating
VALUES
(1,101,4),
(2,102,3),
(3,103,1),
(4,104,2),
(5,105,4),
(6,106,3),
(7,107,4),
(8,108,4),
(9,109,3),
(10,110,5),
(11,111,3),
(12,112,4),
(13,113,2),
(14,114,1),
(15,115,1),
(16,116,0);

-- 3)   Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
SELECT COUNT(t2.CUS_GENDER) AS NoOfCustomers, t2.CUS_GENDER FROM
(SELECT t1.CUS_ID, t1.CUS_GENDER, t1.ORD_AMOUNT, t1.CUS_NAME FROM
(SELECT `order`.*, customer.CUS_GENDER,customer.CUS_NAME FROM `order`
INNER JOIN customer WHERE `order`.CUS_ID=customer.CUS_ID HAVING
`order`.ORD_AMOUNT>=3000)
AS t1 GROUP BY T1.CUS_ID) AS T2 GROUP BY T2.CUS_GENDER;

-- 4)   Display all the orders along with product name ordered by a customer having Customer_Id=2.
SELECT PRO_NAME, `order`. * FROM `order`,product,supplier_pricing WHERE 
CUS_ID=2 AND 
`order`.PRICING_ID=supplier_pricing.PRICING_ID AND 
supplier_pricing.PRO_ID=product.PRO_ID;


-- 5)   Display the Supplier details who can supply more than one product.
SELECT supplier.* FROM supplier WHERE supplier.SUPP_ID IN
(SELECT SUPP_ID FROM supplier_pricing GROUP BY SUPP_ID HAVING COUNT(SUPP_ID)>1) 
GROUP BY supplier.SUPP_ID;

-- 6)   Find the least expensive product from each category and print the table with category id, name, product name and price of the product
SELECT c.CAT_ID, c.CAT_NAME, p.PRO_NAME, MIN(s.SUPP_PRICE) FROM
category AS c, product AS p, supplier_pricing AS s WHERE
c.CAT_ID = p.CAT_ID and s.PRO_ID = p.PRO_ID GROUP BY c.CAT_ID ORDER BY  c.CAT_ID ASC;

-- 7)   Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT p.PRO_ID, p.PRO_NAME, o.ORD_DATE
FROM product AS p, supplier_pricing AS s, `order` AS o 
WHERE s.PRO_ID = p.PRO_ID AND o.PRICING_ID = s.PRICING_ID AND o.ORD_DATE > '2021-10-05';

-- 8)   Display customer name and gender whose names start or end with character 'A'.
SELECT CUS_NAME AS Customer_Name, CUS_GENDER AS Customer_Gender FROM customer WHERE CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A';

-- 9)   Create a stored procedure to display supplier id, name, rating and Type_of_Service. 
-- For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, 
-- If rating >2 print “Average Service” else print “Poor Service”.
DELIMITER &&
CREATE PROCEDURE TypeOfService()
BEGIN
SELECT SUP.SUPP_ID AS Supplier_ID , SUP.SUPP_NAME AS Supplier_Name , AVG(R.RAT_STARS) AS Rating,
CASE
WHEN AVG(R.RAT_STARS) = 5 THEN 'Excellent Service'
WHEN AVG(R.RAT_STARS) > 4 THEN 'Good Service'
WHEN AVG(R.RAT_STARS) > 2 THEN 'Average Service'
ELSE 'Poor Service'
END AS Type_of_Service
FROM supplier AS SUP, rating AS R, supplier_pricing AS SP, `order` AS O 
WHERE R.ORD_ID = O.ORD_ID AND O.PRICING_ID = SP.PRICING_ID AND SP.SUPP_ID = SUP.SUPP_ID
GROUP BY SUP.SUPP_ID 
ORDER BY SUP.SUPP_ID ASC;
END&&
DELIMITER ;

CALL TypeOfService();


