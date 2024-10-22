/* 

os arquivos estão sendo guardados no diretorio
C:\ProgramData\MySQL\MySQL Server 8.0\Data\kassandr


*/

USE KASSANDR;

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',1),',',-1) AS UserId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',2),',',-1) AS OfferId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',3),',',-1) AS OfferViewId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',4),',',-1) AS CountryCode,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',5),',',-1) AS Category,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',6),',',-1) AS Source,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',7),',',-1) AS UtcDate,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',8),',',-1) AS Keywords,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',9),',',-1) AS OfferTitle
FROM de_1
INTO OUTFILE 'clicks_de_2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

DROP TABLE DE;

CREATE TABLE DE (
	UserId varchar(250),
    OfferId varchar(250),
    OfferViewId varchar(250),
    CountryCode varchar(2),
    Category int,
    Source varchar(250),
    UtcDate varchar(21),
    Keywords varchar(500),
    OfferTitle varchar(500)
);
load data infile 'clicks_de_2.csv' into table DE 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 LINES;

DROP TABLE DE_1;

/* CRIANDO SELEÇTION FRANÇA */

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',1),',',-1) AS UserId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',2),',',-1) AS OfferId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',3),',',-1) AS OfferViewId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',4),',',-1) AS CountryCode,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',5),',',-1) AS Category,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',6),',',-1) AS Source,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',7),',',-1) AS UtcDate,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',8),',',-1) AS Keywords,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',9),',',-1) AS OfferTitle
FROM fr_1
INTO OUTFILE 'clicks_fr_2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

/* IMPORTANDO CSV EM TABELA */

DROP TABLE FR;

CREATE TABLE FR (
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
load data infile 'clicks_fr_2.csv' into table FR 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 LINES;

DROP TABLE FR_1;
/*--------------------------------------------------------------------------------------*/
/* ITALIA */

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',1),',',-1) AS UserId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',2),',',-1) AS OfferId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',3),',',-1) AS OfferViewId,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',4),',',-1) AS CountryCode,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',5),',',-1) AS Category,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',6),',',-1) AS Source,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',7),',',-1) AS UtcDate,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',8),',',-1) AS Keywords,
SUBSTRING_INDEX(SUBSTRING_INDEX(ROW1,',',9),',',-1) AS OfferTitle
FROM it_1
INTO OUTFILE 'clicks_it_2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

/* IMPORTANDO CSV EM TABELA */

DROP TABLE FR;

CREATE TABLE IT (
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
load data infile 'clicks_it_2.csv' into table IT
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 LINES;

DROP TABLE IT_1;

/* ---------------------------------------------------------------
criando a seleção para mudança da sample dos paises
objetivo: criar uma sample com pessoas que clicaram mais que 40 vezes
------------------------------------------------------------------ */

SELECT
  UserId,
  COUNT(*) AS `User_clicks`
FROM
  de
GROUP BY
  UserId
INTO OUTFILE 'user_de_clicks.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
  
CREATE TABLE DE_CLICKS(
	UserId varchar(250),
    clicks INT
);
  
load data infile 'user_de_clicks.csv' into table DE_CLICKS
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* ------------------------- thr 40 no de_clicks ----------------
mudando tudo para para que tenham somente usuario com mais de 40 clicks
*/


select * from de_clicks where clicks > 40
INTO OUTFILE 'user_de_clicks_40.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

DROP TABLE DE_CLICKS_40;

CREATE TABLE DE_CLICKS_40(
	UserId varchar(250),
    clicks INT
);

load data infile 'user_de_clicks_40.csv' into table DE_CLICKS_40
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

select * from de_clicks_40;

select * from de
where exists(
select UserId from de_clicks_40
);

/* Agora vou jogar para python para analisar os dados*/

select * from de
where exists(
select UserId from de_clicks_40
)
INTO OUTFILE 'new_sample_de.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';




