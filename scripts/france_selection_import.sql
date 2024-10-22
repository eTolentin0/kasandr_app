USER KASSANDR;

/* ---------------------------------------------------------------
criando a seleção para mudança da sample dos paises
objetivo: criar uma sample com pessoas que clicaram mais que 40 vezes
------------------------------------------------------------------ */

/* FRANÇA */

SELECT
  UserId,
  COUNT(*) AS `User_clicks`
FROM
  fr
GROUP BY
  UserId
INTO OUTFILE 'user_fr_clicks.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
  
CREATE TABLE fr_clicks(
	UserId varchar(250),
    clicks INT
);
  
load data infile 'user_fr_clicks.csv' into table fr_clicks
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* ------------------------- thr 40 no de_clicks ----------------
mudando tudo para para que tenham somente usuario com mais de 40 clicks
*/


select * from fr_clicks where clicks > 40
INTO OUTFILE 'user_fr_clicks_40.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


CREATE TABLE fr_CLICKS_40(
	UserId varchar(250),
    clicks INT
);

load data infile 'user_fr_clicks_40.csv' into table fr_CLICKS_40
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

select * from fr
where exists(
select UserId from fr_clicks_40
);

/* Agora vou jogar para python para analisar os dados*/

select * from fr
where exists(
select UserId from fr_clicks_40
)
INTO OUTFILE 'new_sample_fr.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';