/*Use Computer DB
1. Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
Result set: model, speed, hd.*/
SELECT model, speed, hd
FROM PC
WHERE price < 500;

/*2. List all printer makers. Result set: maker.*/
SELECT DISTINCT maker
FROM product
WHERE type = 'printer';

/*3. Find the model number, RAM and screen size of the laptops with prices over $1000.*/
SELECT model, ram, screen
FROM laptop
WHERE price > 1000;

/*4. Find all records from the Printer table containing data about color printers.*/
SELECT *
FROM printer
WHERE color = 'Y';

/*5. Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.*/
SELECT model, speed, hd
FROM PC
WHERE price < 600 AND (cd = '12x' OR cd = '24x');

/*6. For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed.*/
SELECT DISTINCT p.maker, l.speed
FROM laptop l 
INNER JOIN product p
ON p.model = l.model
WHERE l.hd >= '10' AND p.type = 'laptop';

/* 7. Get the models and prices for all commercially available products (of any type) produced by maker B.*/
SELECT DISTINCT model, price
FROM PC
WHERE model IN (SELECT model 
FROM product
WHERE maker = 'B')
UNION ALL
SELECT DISTINCT model, price
FROM laptop
WHERE model IN (SELECT model
FROM product
WHERE maker = 'B')
UNION ALL 
SELECT DISTINCT model, price 
FROM printer
WHERE model IN (SELECT model
from product
WHERE maker = 'B');

/* 8. Find the makers producing PCs but not laptops.*/
SELECT  DISTINCT maker
FROM product
WHERE type = 'PC'
EXCEPT
SELECT maker
FROM product 
WHERE type = 'laptop';

/*9. Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.*/
SELECT DISTINCT maker 
FROM product
WHERE model in 
(SELECT model 
FROM PC
WHERE speed >=450);

/*10. Find the printer models having the highest price. Result set: model, price.*/
SELECT DISTINCT model, price
FROM printer
WHERE price = (SELECT MAX(price)
FROM printer);

/*11. Find out the average speed of PCs.*/
SELECT AVG(speed)
FROM pc;

/*12. Find out the average speed of the laptops priced over $1000.*/
SELECT AVG(speed)
FROM laptop
WHERE price > 1000;

/*13. Find out the average speed of the PCs produced by maker A.*/
SELECT AVG(speed)
FROM PC
WHERE model IN 
(SELECT model 
FROM product
WHERE maker = 'A');

/*14. Get the makers who produce only one product type and more than one model. Output: maker, type.*/
SELECT DISTINCT m.maker, p.type
FROM 
(SELECT maker, COUNT(DISTINCT type) as num_type, COUNT(model) AS model
FROM product 
GROUP BY maker
HAVING COUNT(DISTINCT type) = 1
AND COUNT(model) > 1) m
INNER JOIN Product p
ON m.maker = p.maker

/*15. Get hard drive capacities that are identical for two or more PCs. 
Result set: hd.*/
SELECT hd
FROM pc 
GROUP BY hd
HAVING COUNT(hd) >=2;

SELECT DISTINCT hd
FROM pc 
WHERE 
(SELECT COUNT(hd)
FROM pc v
WHERE pc.hd = v.hd) > 1;

/*16. Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i). 
Result set: model with the bigger number, model with the smaller number, speed, and RAM.*/
SELECT DISTINCT pc.model, v.model, pc.speed, pc.ram
FROM pc 
INNER JOIN
pc v
ON pc.model > v.model
WHERE pc.speed = v.speed AND pc.ram=v.ram
ORDER BY pc.model, v.model;

/*17. Get the laptop models that have a speed smaller than the speed of any PC. 
Result set: type, model, speed.*/
SELECT DISTINCT p.type, l.model, l.speed
FROM product p
INNER JOIN laptop l
ON p.model = l.model
WHERE l.speed < 
(SELECT MIN(speed) 
FROM pc)

/*18. Find the makers of the cheapest color printers.
Result set: maker, price. */
SELECT DISTINCT p.maker, pr.price
FROM product p
INNER JOIN printer pr
ON p.model = pr.model
WHERE pr.price = 
(SELECT MIN(price)
FROM printer
WHERE color = 'Y')
AND color = 'Y'

/*19. For each maker having models in the Laptop table, find out the average screen size of the laptops he produces. 
Result set: maker, average screen size.
*/
SELECT p.maker, AVG(l.screen)
FROM product p
INNER JOIN
laptop l
ON p.model = l.model
GROUP BY p.maker;

/*20. Find the makers producing at least three distinct models of PCs.
Result set: maker, number of PC models.*/
SELECT maker, COUNT(DISTINCT model) num_models
FROM product 
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(DISTINCT model) >2;

/*21. Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.*/
SELECT p.maker, MAX(pc.price) max_price
FROM product p
INNER JOIN pc
ON p.model = pc.model
GROUP BY p.maker;

/*22. For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
Result set: speed, average price.*/
SELECT speed, AVG(price) avg_price
FROM pc
WHERE speed > 600
GROUP BY speed;

/*23. Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher. 
Result set: maker*/
SELECT DISTINCT p.maker
FROM product p
INNER JOIN pc
ON p.model = pc.model
WHERE pc.speed >= 750
INTERSECT
SELECT DISTINCT p.maker
FROM product p
INNER JOIN Laptop l
ON p.model = l.model
WHERE l.speed >= 750;

/*24. List the models of any type having the highest price of all products present in the database.*/
SELECT model
FROM (select model, price 
FROM pc
UNION ALL
SELECT model, price
FROM laptop
UNION ALL 
SELECT model, price
FROM printer) as model1
WHERE price = (select max(price) as max_price from
(SELECT price
FROM pc
UNION ALL
SELECT price
FROM laptop
UNION ALL 
SELECT price 
FROM printer) as cost);

/*Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity. 
Result set: maker.*/
SELECT DISTINCT one.maker AS maker
FROM (SELECT maker, model, type
FROM product) one
INNER JOIN product two
ON one.maker = two.maker
INNER JOIN 
(SELECT model, ram, speed
FROM pc
WHERE ram = 
(SELECT MIN(ram)
FROM pc)
AND speed =
(SELECT MAX(speed)
FROM pc
WHERE ram = 
(SELECT MIN(ram)
FROM pc))) AS pc
ON one.model = pc.model
WHERE (one.type = 'PC' AND two.type = 'Printer');

/*26. Find out the average price of PCs and laptops produced by maker A.
Result set: one overall average price for all items. */
SELECT AVG(pc_lp.price) 
FROM (SELECT model, price
FROM pc
UNION ALL
SELECT model, price 
FROM laptop) pc_lp
INNER JOIN product p
ON p.model = pc_lp.model
WHERE p.maker = 'A';

/* 27. Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
Result set: maker, average HDD capacity. */
SELECT DISTINCT one.maker AS maker, AVG(pc.hd)
FROM (SELECT maker, model, type
FROM product) one
INNER JOIN product two
ON one.maker = two.maker
INNER JOIN 
(SELECT model, hd 
FROM pc) AS pc
ON one.model = pc.model
WHERE one.type = 'PC' AND two.type = 'Printer'
GROUP BY one.maker;

/*28. Using Product table, find out the number of makers who produce only one model.*/
SELECT COUNT(DISTINCT p.maker) AS num_makers
FROM product p
INNER JOIN (SELECT COUNT(DISTINCT model) AS num_models, maker
FROM product
GROUP BY maker) prod
ON prod.maker = p.maker
WHERE prod.num_models = 1;

/*Use Income & Outcome DB
29. Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each collection point [i.e. the primary key consists of (point, date)], write a query displaying cash flow data (point, date, income, expense). 
Use Income_o and Outcome_o tables. */
SELECT i.point, i.date, i.inc, o.out
FROM income_o i
LEFT OUTER JOIN
outcome_o o
ON i.point = o.point
AND i.date = o.date
UNION
SELECT o.point, o.date, i.inc, o.out
FROM income_o i
RIGHT OUTER JOIN
outcome_o o
ON i.point = o.point
AND i.date = o.date;

/* 30. Under the assumption that receipts of money (inc) and payouts (out) can be registered any number of times a day for each collection point [i.e. the code column is the primary key], display a table with one corresponding row for each operating date of each collection point.
Result set: point, date, total payout per day (out), total money intake per day (inc). 
Missing values are considered to be NULL.*/
SELECT o.point, o.date, o.outcome, i.income
FROM (SELECT point, date, SUM(out) AS outcome
FROM outcome
GROUP BY point, date) o 
LEFT OUTER JOIN
(SELECT point, date, SUM(inc) AS income
FROM income
GROUP BY point, date) i 
ON i.point = o.point
AND i.date = o.date
UNION 
SELECT i.point, i.date, o.outcome, i.income
FROM (SELECT point, date, SUM(inc) AS income
FROM income
GROUP BY point, date) i
LEFT OUTER JOIN
(SELECT point, date, SUM(out) AS outcome
FROM outcome
GROUP BY point, date) o
ON i.point = o.point
AND i.date = o.date;

/* USE SHIPS DB 
31. For ship classes with a gun caliber of 16 in. or more, display the class and the country.*/
SELECT class, country
FROM classes
WHERE bore >=16;

/*32. One of the characteristics of a ship is one-half the cube of the calibre of its main guns (mw). 
Determine the average ship mw with an accuracy of two decimal places for each country having ships in the database.*/SELECT main.country, CAST(AVG(POWER(main.bore, 3)/2) AS NUMERIC(6,2))
FROM (SELECT cl.country, cl.bore, sh.name as ship
FROM classes cl
INNER JOIN ships sh
ON cl.class = sh.class
WHERE cl.bore IS NOT NULL
UNION
SELECT cl.country, cl.bore, o.ship
FROM classes cl
INNER JOIN outcomes o
ON cl.class = o.ship
WHERE NOT EXISTS (SELECT 1 from
ships
WHERE name = o.ship)
AND cl.bore IS NOT NULL) AS main
GROUP BY main.country;

/*33. Get the ships sunk in the North Atlantic battle. 
Result set: ship. */
SELECT ship
FROM outcomes
WHERE battle = 'North Atlantic'
AND result = 'sunk';

/*34. In accordance with the Washington Naval Treaty concluded in the beginning of 1922, it was prohibited to build battle ships with a displacement of more than 35 thousand tons. 
Get the ships violating this treaty (only consider ships for which the year of launch is known). 
List the names of the ships.*/
SELECT sh.name
FROM ships sh
INNER JOIN classes cl
ON cl.class = sh.class
WHERE (sh.launched > 1921
AND cl.displacement > 35000)
AND type = 'bb';

/* USE COMPUTER DB
35. Find models in the Product table consisting either of digits only or Latin letters (A-Z, case insensitive) only.
Result set: model, type. */
SELECT model, type
FROM product
WHERE model NOT LIKE '%[^0-9]%' OR model NOT LIKE '%[^a-z]%';

/*USE SHIPS DB
36. List the names of lead ships in the database (including the Outcomes table).*/
SELECT main.name
FROM 
(SELECT sh.name AS name
FROM ships sh
INNER JOIN classes cl 
ON cl.class = sh.name
UNION
SELECT o.ship AS name
FROM outcomes o
INNER JOIN classes cl
ON cl.class = o.ship) AS main;

/*37. Find classes for which only one ship exists in the database (including the Outcomes table).*/
SELECT prim.class 
FROM (SELECT main.class AS class, COUNT(main.name) AS name
FROM (SELECT cl.class AS class, sh.name AS name
FROM ships sh
INNER JOIN classes cl 
ON cl.class = sh.class
UNION
SELECT cl.class AS class, o.ship AS name
FROM outcomes o
INNER JOIN classes cl
ON cl.class = o.ship) AS main
GROUP by main.class
HAVING COUNT(main.name) =1) AS prim;

/*38. Find countries that ever had classes of both battleships (‘bb’) and cruisers (‘bc’).*/
SELECT DISTINCT c1.country
FROM (SELECT country 
FROM classes
WHERE type = 'bb') c1
INNER JOIN (SELECT country
FROM classes
WHERE type = 'bc') c2
ON c1.country = c2.country;

/*39. Find the ships that `survived for future battles`; that is, after being damaged in a battle, they participated in another one, which occurred later.*/
SELECT DISTINCT two.ship
FROM (SELECT o.ship, b.date from outcomes o INNER JOIN battles b
ON b.name = o.battle) one
INNER JOIN (SELECT o.ship, o.result, b.date from outcomes o INNER JOIN battles b
ON b.name = o.battle
WHERE o.result = 'damaged') two
ON one.ship = two.ship 
AND one.date > two.date;

/*40.For the ships in the Ships table that have at least 10 guns, get the class, name, and country.*/
SELECT c.class, s.name, c.country
FROM classes c INNER JOIN ships s
ON c.class = s.class
WHERE c.numGuns >=10;

/* USE COMPUTER DB
41. For the PC in the PC table with the maximum code value, obtain all its characteristics (except for the code) and display them in two columns:
- name of the characteristic (title of the corresponding column in the PC table);
- its respective value.*/
SELECT main.chr, main.value 
FROM (SELECT 1 AS num, 'model' as chr, model as value 
FROM pc 
WHERE code = (SELECT max(code) FROM pc)
UNION
SELECT 2 AS num, 'speed' as chr, cast(speed as varchar)  as value 
FROM pc 
WHERE code = (SELECT max(code) FROM pc)
UNION
SELECT 3 AS num, 'ram' as chr, cast(ram as varchar) as value 
FROM pc 
WHERE code = (SELECT max(code) FROM pc)
UNION
SELECT 4 AS num, 'hd' as chr, cast(hd as varchar)  as value 
FROM pc 
WHERE code = (SELECT max(code) FROM pc)
UNION
SELECT 5 AS num, 'cd' as chr, cd as value 
FROM pc 
WHERE code = (SELECT max(code) FROM pc)
UNION
SELECT 6 AS num, 'price' as chr, cast(price as varchar)  as value 
FROM pc 
WHERE code = (SELECT max(code) FROM pc)) main
ORDER BY main.num;

/*USE SHIPS DB
42. Find the names of ships sunk at battles, along with the names of the corresponding battles.*/
SELECT ship, battle
FROM outcomes
WHERE result = 'sunk';

/*43. Get the battles that occurred in years when no ships were launched into water.*/
SELECT b.name FROM 
(SELECT name, DATEPART(year, date) AS year
FROM battles) b
WHERE NOT EXISTS (SELECT DISTINCT launched FROM ships
WHERE launched = b.year);

/*44. Find all ship names beginning with the letter R.*/
SELECT sh.ship
FROM 
(SELECT name AS ship
FROM ships
UNION
SELECT ship
FROM outcomes) sh
WHERE sh.ship LIKE 'R%';

/*

