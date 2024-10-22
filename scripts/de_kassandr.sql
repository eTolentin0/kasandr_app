/*IMPORTANDO ALEMANHA
C:\ProgramData\MySQL\MySQL Server 8.0\Data
*/

CREATE DATABASE DE_KASSANDR;
USE DE_KASSANDR;


CREATE TABLE DE_1_ROW (
	row1 varchar(15000)
);

load data infile 'Click_de.csv' into table DE_1_ROW LINES TERMINATED BY '\n';

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',1),',',-1) AS UserId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',2),',',-1) AS OfferId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',3),',',-1) AS OfferViewId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',4),',',-1) AS CountryCode,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',5),',',-1) AS Category,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',6),',',-1) AS Source,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',7),',',-1) AS UtcDate,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',8),',',-1) AS Keywords,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',9),',',-1) AS OfferTitle
FROM de_1_row;
INTO OUTFILE 'clicks_de_2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',1),',',-1) AS UserId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',2),',',-1) AS OfferId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',3),',',-1) AS OfferViewId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',4),',',-1) AS CountryCode,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',5),',',-1) AS Category,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',6),',',-1) AS Source,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',7),',',-1) AS UtcDate,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',8),',',-1) AS Keywords,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',15),',',-1) AS OfferTitle
FROM de_1_row
INTO OUTFILE 'clicks_de_2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

CREATE TABLE DE (
	UserId varchar(250),
    OfferId varchar(250),
    OfferViewId varchar(250),
    CountryCode varchar(2),
    Category int,
    Source varchar(250),
    UtcDate varchar(21),
    Keywords varchar(1000),
    OfferTitle varchar(5000)
);

load data infile 'clicks_de_2.csv' into table DE
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- SELECT * FROM DE;

SELECT
  UserId,
  COUNT(UserId) AS `user_clicks`
FROM
  DE
GROUP BY
  UserId
INTO OUTFILE 'de_user_clicks.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

CREATE TABLE de_user_clicks(
	UserId varchar(250),
    clicks INT
);

load data infile 'de_user_clicks.csv' into table de_user_clicks
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

/*CRIANDO UM DATABASE SÓ COM USUARIO THR 10*/

-- select com os mais clicados
select * from de_user_clicks where clicks > 10;

select * from de
where UserId in (
select UserId from de_user_clicks where clicks > 10
)
INTO OUTFILE 'new_sample_de_userthr10.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'; 

/*tabela cortada com usuarios que clicaram + de 10 vezes*/

CREATE TABLE DE_clicks_thr10 (
	UserId varchar(250),
    OfferId varchar(250),
    OfferViewId varchar(250),
    CountryCode varchar(2),
    Category int,
    Source varchar(250),
    UtcDate varchar(21),
    Keywords varchar(500),
    OfferTitle varchar(5000)
);

load data infile 'new_sample_de.csv' into table DE_clicks_thr10
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


/*OFERTAS*/

SELECT
  OfferId,
  COUNT(*) AS `Offer_clicks`
FROM
  DE
GROUP BY
  OfferId
INTO OUTFILE 'de_offer_clicks.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

CREATE TABLE de_offer_clicks(
	OfferId varchar(250),
    clicks INT
);

load data infile 'de_offer_clicks.csv' into table de_offer_clicks
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

/*CRIANDO UM DATABASE SÓ COM OFERTAS CORTES 10*/

select * from de
where OfferId in (
select OfferId from de_offer_clicks where clicks > 10
)
INTO OUTFILE 'new_sample_de_offerthr10.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'; 



/*AQUI EU FAÇO O CORTE DE USUARIO E OFERTA COM THR 10*/

select * from de_clicks_thr10;

select * from de_clicks_thr10
where OfferId in (
select OfferId from de_offer_clicks where clicks > 10
)
INTO OUTFILE 'new_sample_de_user_offer_thr10.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'; 


USE DE_KASSANDR;

CREATE TABLE DE_WEEK(
	UserId varchar(250),
    WeekNumber int
);

select UserId, week(UtcDate) WeekNumber from de
order by week(UtcDate)
INTO OUTFILE 'de_weeknumber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


load data infile 'de_weeknumber.csv' into table DE_WEEK
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

select * from de
where UserId in (
select UserId from DE_WEEK where WEEKNUMBER = 22
)
INTO OUTFILE 'alemanha_week_22.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

select * from de
where UserId in (
select UserId from DE_WEEK where WEEKNUMBER = 23
)
INTO OUTFILE 'alemanha_week_23.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

select * from de
where UserId in (
select UserId from DE_WEEK where WEEKNUMBER = 24
)
INTO OUTFILE 'alemanha_week_24.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

select * from de
where UserId in (
select UserId from DE_WEEK where WEEKNUMBER = 25
)
INTO OUTFILE 'alemanha_week_25.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

select * from de
where UserId in (
select UserId from DE_WEEK where WEEKNUMBER = 26
)
INTO OUTFILE 'alemanha_week_26.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

select * from DE_WEEK WHERE WEEKNUMBER = 27;

select OfferId, Category from de
group by OfferId
INTO OUTFILE 'alemanha_offers_categories.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

use de_kassandr;

select UserId from de
group by UserId;

select UserId from de;

select Category, count(*) as 'countador' from de
group by Category
order by 'countador' Desc;