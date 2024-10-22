/*IMPORTANDO ALEMANHA
C:\ProgramData\MySQL\MySQL Server 8.0\Data
*/

CREATE DATABASE fr_KASSANDR;
USE fr_KASSANDR;


CREATE TABLE fr_1_ROW (
	row1 varchar(15000)
);

load data infile 'Click_fr.csv' into table fr_1_ROW LINES TERMINATED BY '\n';

/* rodar a partir daqui */

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',1),',',-1) AS UserId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',2),',',-1) AS OfferId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',3),',',-1) AS OfferViewId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',4),',',-1) AS CountryCode,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',5),',',-1) AS Category,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',6),',',-1) AS Source,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',7),',',-1) AS UtcDate,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',8),',',-1) AS Keywords,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',15),',',-1) AS OfferTitle
FROM fr_1_row
INTO OUTFILE 'clicks_fr_2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

/**/

CREATE TABLE fr (
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

load data infile 'clicks_fr_2.csv' into table fr
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- SELECT * FROM fr;

SELECT
  UserId,
  COUNT(UserId) AS `user_clicks`
FROM
  fr
GROUP BY
  UserId
INTO OUTFILE 'fr_user_clicks.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

CREATE TABLE fr_user_clicks(
	UserId varchar(250),
    clicks INT
);

load data infile 'fr_user_clicks.csv' into table fr_user_clicks
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

/*CRIANDO UM DATABASE SÓ COM USUARIO THR 10*/

-- select com os mais clicados
select * from fr_user_clicks where clicks > 10;

select * from fr
where UserId in (
select UserId from fr_user_clicks where clicks > 10
)
INTO OUTFILE 'new_sample_fr_userthr10.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'; 

/*tabela cortada com usuarios que clicaram + fr 10 vezes*/

CREATE TABLE fr_clicks_thr10 (
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

load data infile 'new_sample_fr_userthr10.csv' into table fr_clicks_thr10
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


/*OFERTAS*/

SELECT
  OfferId,
  COUNT(*) AS `Offer_clicks`
FROM
  fr
GROUP BY
  OfferId
INTO OUTFILE 'fr_offer_clicks.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

CREATE TABLE fr_offer_clicks(
	OfferId varchar(250),
    clicks INT
);

load data infile 'fr_offer_clicks.csv' into table fr_offer_clicks
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

/*CRIANDO UM DATABASE SÓ COM OFERTAS CORTES 10*/

select * from fr
where OfferId in (
select OfferId from fr_offer_clicks where clicks > 10
)
INTO OUTFILE 'new_sample_fr_offerthr10.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'; 



/*AQUI EU FAÇO O CORTE DE USUARIO E OFERTA COM THR 10*/

select * from fr_clicks_thr10;

select * from fr_clicks_thr10
where OfferId in (
select OfferId from fr_offer_clicks where clicks > 10
)
INTO OUTFILE 'new_sample_fr_user_offer_thr10.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'; 

use fr_kassandr;
select OfferId, Category from fr
group by OfferId
INTO OUTFILE 'france_offers_categories.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

use fr_kassandr;
select UserId from fr;

select UserId from fr
group by UserId;

select Category, count(*) as 'countador' from fr
group by Category
order by 'countador' Desc;