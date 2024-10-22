/*IMPORTANDO ALEMANHA*/

CREATE DATABASE DE_KASSANDR;
USE DE_KASSANDR;

CREATE TABLE DE (
	UserId varchar(250),
    OfferId varchar(250),
    OfferViewId varchar(250),
    CountryCode varchar(2),
    Category int,
    Source varchar(250),
    UtcDate varchar(21),
    Keywords varchar(50),
    OfferTitle varchar(250)
);

CREATE TABLE DE_1_ROW (
	row1 varchar(5000)
);

LOAD DATA INFILE 'Click_de.csv'
INTO TABLE DE_1_ROW
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';
IGNORE 1 ROWS;


SHOW GLOBAL VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile=true;
SHOW GLOBAL VARIABLES LIKE 'secure_file_priv';

select * from DE;



 drop table if exists de;
create table t(col1 varchar(20),
col2 varchar(20), 
col3 varchar(20), 
col4 varchar(20),
col5 varchar(100));

truncate table de;

DROP TABLE DE_1;

CREATE TABLE DE_1 (
	row1 varchar(10000)
);



load data infile 'Click_de.csv' into table DE_1 LINES TERMINATED BY '\n';



CREATE TABLE FR_1 (row1 varchar(10000));

load data infile 'Click_fr.csv' into table FR_1 LINES TERMINATED BY '\n';

CREATE TABLE IT_1 (row1 varchar(10000));
load data infile 'Click_it.csv' into table IT_1 LINES TERMINATED BY '\n';

SELECT * FROM DE_1;


SELECT *, LEFT(row1, locate(',',row1)-1) AS 'UserId' FROM DE_1;
SET GLOBAL interactive_timeout=16M;
SET GLOBAL connect_timeout="";

show variables like "%timeout";

