CREATE DATABASE it_KASSANDR;
USE it_KASSANDR;


CREATE TABLE it_1_ROW (
	row1 varchar(15000)
);

load data infile 'Click_it.csv' into table it_1_ROW LINES TERMINATED BY '\n';

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',1),',',-1) AS UserId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',2),',',-1) AS OfferId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',3),',',-1) AS OfferViewId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',4),',',-1) AS CountryCode,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',5),',',-1) AS Category,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',6),',',-1) AS Source,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',7),',',-1) AS UtcDate,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',8),',',-1) AS Keywords,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',15),',',-1) AS OfferTitle
FROM it_1_row
INTO OUTFILE 'clicks_it_2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

CREATE TABLE it (
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

load data infile 'clicks_it_2.csv' into table it
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- SELECT * FROM it;
/*rodar a partir daqui qunado voltar do bras*/
SELECT
  UserId,
  COUNT(UserId) AS `user_clicks`
FROM
  it
GROUP BY
  UserId
INTO OUTFILE 'it_user_clicks.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

CREATE TABLE it_user_clicks(
	UserId varchar(250),
    clicks INT
);

load data infile 'it_user_clicks.csv' into table it_user_clicks
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

/*CRIANDO UM DATABASE SÓ COM USUARIO THR 10*/

-- select com os mais clicados
select * from it_user_clicks where clicks > 10;

select * from it
where UserId in (
select UserId from it_user_clicks where clicks > 10
)
INTO OUTFILE 'new_sample_it_userthr10.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'; 

/*tabela cortada com usuarios que clicaram + it 10 vezes*/

CREATE TABLE it_clicks_thr10 (
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

load data infile 'new_sample_it_userthr10.csv' into table it_clicks_thr10
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


/*OFERTAS*/

SELECT
  OfferId,
  COUNT(*) AS `Offer_clicks`
FROM
  it
GROUP BY
  OfferId
INTO OUTFILE 'it_offer_clicks.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

CREATE TABLE it_offer_clicks(
	OfferId varchar(250),
    clicks INT
);

load data infile 'it_offer_clicks.csv' into table it_offer_clicks
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

/*CRIANDO UM DATABASE SÓ COM OFERTAS CORTES 10*/

select * from it
where OfferId in (
select OfferId from it_offer_clicks where clicks > 10
)
INTO OUTFILE 'new_sample_it_offerthr10.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'; 



/*AQUI EU FAÇO O CORTE DE USUARIO E OFERTA COM THR 10*/

select * from it_clicks_thr10;

select * from it_clicks_thr10
where OfferId in (
select OfferId from it_offer_clicks where clicks > 10
)
INTO OUTFILE 'new_sample_it_user_offer_thr10.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'; 

use it_kassandr;
select OfferId, Category from it
group by OfferId
INTO OUTFILE 'italia_offers_categories.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


use it_kassandr;
select UserId from it;

select UserId from it
group by UserId;

select COUNT(distincT(UserId)) from it;

select Category, count(*) as 'countador' from it
group by Category
order by 'countador' Desc;