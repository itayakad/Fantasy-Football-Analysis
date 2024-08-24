
-- Adv Receiving Data --
SELECT *
FROM adv_rec2018

ALTER TABLE adv_rec2018 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_rec2019 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_rec2020 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_rec2021 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_rec2022 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_rec2023 ADD COLUMN year INT AFTER Tm;

UPDATE adv_rec2018 SET year = 2018;
UPDATE adv_rec2019 SET year = 2019;
UPDATE adv_rec2020 SET year = 2020;
UPDATE adv_rec2021 SET year = 2021;
UPDATE adv_rec2022 SET year = 2022;
UPDATE adv_rec2023 SET year = 2023;

CREATE TABLE adv_rec_all
LIKE adv_rec2018;

INSERT INTO adv_rec_all SELECT * FROM adv_rec2018;
INSERT INTO adv_rec_all SELECT * FROM adv_rec2019;
INSERT INTO adv_rec_all SELECT * FROM adv_rec2020;
INSERT INTO adv_rec_all SELECT * FROM adv_rec2021;
INSERT INTO adv_rec_all SELECT * FROM adv_rec2022;
INSERT INTO adv_rec_all SELECT * FROM adv_rec2023;

UPDATE adv_rec_all
SET Player = TRIM(Player);

SELECT *
FROM adv_rec_all;

ALTER TABLE adv_rec_all
DROP COLUMN Rk;

UPDATE adv_rec_all
SET Player = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Player, '*', ''), '+', ''), ' Sr.', ''), ' Jr.', ''), ' II', ''), ' III', ''), '.', '');

SELECT CONCAT(' CHANGE COLUMN `', COLUMN_NAME, '` `rz_', COLUMN_NAME, '` ', COLUMN_TYPE, ';')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'adv_rec_all';

ALTER TABLE adv_rec_all
CHANGE COLUMN `1D` `rec_1D` int,
CHANGE COLUMN `ADOT` `rec_ADOT` double,
CHANGE COLUMN `Age` `rec_Age` int,
CHANGE COLUMN `BrkTkl` `rec_BrkTkl` int,
CHANGE COLUMN `Drop` `rec_Drop` int,
CHANGE COLUMN `Drop%` `rec_Drop%` int,
CHANGE COLUMN `G` `rec_G` int,
CHANGE COLUMN `GS` `rec_GS` int,
CHANGE COLUMN `Int` `rec_Int` int,
CHANGE COLUMN `Pos` `rec_Pos` varchar(50),
CHANGE COLUMN `Rat` `rec_Rat` double,
CHANGE COLUMN `Rec` `rec_Rec` int,
CHANGE COLUMN `Rec/Br` `rec_Rec/Br` double,
CHANGE COLUMN `TD` `rec_TD` int,
CHANGE COLUMN `Tgt` `rec_Tgt` int,
CHANGE COLUMN `YAC` `rec_YAC` int,
CHANGE COLUMN `YAC/R` `rec_YAC/R` double,
CHANGE COLUMN `YBC` `rec_YBC` int,
CHANGE COLUMN `YBC/R` `rec_YBC/R` double,
CHANGE COLUMN `Yds` `rec_Yds` int;

-- Adv Rushing Data --
SELECT *
FROM adv_rush2018

ALTER TABLE adv_rush2018 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_rush2019 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_rush2020 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_rush2021 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_rush2022 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_rush2023 ADD COLUMN year INT AFTER Tm;

UPDATE adv_rush2018 SET year = 2018;
UPDATE adv_rush2019 SET year = 2019;
UPDATE adv_rush2020 SET year = 2020;
UPDATE adv_rush2021 SET year = 2021;
UPDATE adv_rush2022 SET year = 2022;
UPDATE adv_rush2023 SET year = 2023;

CREATE TABLE adv_rush_all
LIKE adv_rush2018;

INSERT INTO adv_rush_all SELECT * FROM adv_rush2018;
INSERT INTO adv_rush_all SELECT * FROM adv_rush2019;
INSERT INTO adv_rush_all SELECT * FROM adv_rush2020;
INSERT INTO adv_rush_all SELECT * FROM adv_rush2021;
INSERT INTO adv_rush_all SELECT * FROM adv_rush2022;
INSERT INTO adv_rush_all SELECT * FROM adv_rush2023;

UPDATE adv_rush_all
SET Player = TRIM(Player);

SELECT *
FROM adv_rush_all;

ALTER TABLE adv_rush_all
DROP COLUMN Rk;

UPDATE adv_rush_all
SET Player = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Player, '*', ''), '+', ''), ' Sr.', ''), ' Jr.', ''), ' II', ''), ' III', ''), '.', '');

SELECT CONCAT(' CHANGE COLUMN `', COLUMN_NAME, '` `rush_', COLUMN_NAME, '` ', COLUMN_TYPE, ';')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'adv_rush_all';

ALTER TABLE adv_rush_all
CHANGE COLUMN `1D` `rush_1D` int,
CHANGE COLUMN `Age` `rush_Age` int,
CHANGE COLUMN `Att` `rush_Att` int,
CHANGE COLUMN `Att/Br` `rush_Att/Br` int,
CHANGE COLUMN `BrkTkl` `rush_BrkTkl` int,
CHANGE COLUMN `G` `rush_G` int,
CHANGE COLUMN `GS` `rush_GS` int,
CHANGE COLUMN `Pos` `rush_Pos` varchar(50),
CHANGE COLUMN `TD` `rush_TD` int,
CHANGE COLUMN `YAC` `rush_YAC` int,
CHANGE COLUMN `YAC/Att` `rush_YAC/Att` int,
CHANGE COLUMN `YBC` `rush_YBC` int,
CHANGE COLUMN `YBC/Att` `rush_YBC/Att` double,
CHANGE COLUMN `Yds` `rush_Yds` int;

-- Adv Passing Data --
SELECT *
FROM adv_pass2018

ALTER TABLE adv_pass2018 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_pass2019 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_pass2020 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_pass2021 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_pass2022 ADD COLUMN year INT AFTER Tm;
ALTER TABLE adv_pass2023 ADD COLUMN year INT AFTER Tm;

UPDATE adv_pass2018 SET year = 2018;
UPDATE adv_pass2019 SET year = 2019;
UPDATE adv_pass2020 SET year = 2020;
UPDATE adv_pass2021 SET year = 2021;
UPDATE adv_pass2022 SET year = 2022;
UPDATE adv_pass2023 SET year = 2023;

CREATE TABLE adv_pass_all
LIKE adv_pass2018;

INSERT INTO adv_pass_all SELECT * FROM adv_pass2018;
INSERT INTO adv_pass_all SELECT * FROM adv_pass2019;
INSERT INTO adv_pass_all SELECT * FROM adv_pass2020;
INSERT INTO adv_pass_all SELECT * FROM adv_pass2021;
INSERT INTO adv_pass_all SELECT * FROM adv_pass2022;
INSERT INTO adv_pass_all SELECT * FROM adv_pass2023;

UPDATE adv_pass_all
SET Player = TRIM(Player);

SELECT *
FROM adv_pass_all;

ALTER TABLE adv_pass_all
DROP COLUMN Rk;

UPDATE adv_pass_all
SET Player = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Player, '*', ''), '+', ''), ' Sr.', ''), ' Jr.', ''), ' II', ''), ' III', ''), '.', '');

SELECT CONCAT(' CHANGE COLUMN `', COLUMN_NAME, '` `pass_', COLUMN_NAME, '` ', COLUMN_TYPE, ';')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'adv_pass_all';

ALTER TABLE adv_pass_all
CHANGE COLUMN `Age` `pass_Age` int,
CHANGE COLUMN `Att` `pass_Att` int,
CHANGE COLUMN `CAY` `pass_CAY` int,
CHANGE COLUMN `CAY/Cmp` `pass_CAY/Cmp` double,
CHANGE COLUMN `CAY/PA` `pass_CAY/PA` double,
CHANGE COLUMN `Cmp` `pass_Cmp` int,
CHANGE COLUMN `G` `pass_G` int,
CHANGE COLUMN `GS` `pass_GS` int,
CHANGE COLUMN `IAY` `pass_IAY` int,
CHANGE COLUMN `IAY/PA` `pass_IAY/PA` double,
CHANGE COLUMN `Pos` `pass_Pos` varchar(50),
CHANGE COLUMN `Tm` `pass_Tm` varchar(50),
CHANGE COLUMN `YAC` `pass_YAC` int,
CHANGE COLUMN `YAC/Cmp` `pass_YAC/Cmp` double,
CHANGE COLUMN `Yds` `pass_Yds` int;

SELECT *
FROM adv_pass_all;

-- Redzone RB Data --
SELECT *
FROM rz_rb2018;

ALTER TABLE rz_rb2018 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_rb2019 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_rb2020 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_rb2021 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_rb2022 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_rb2023 ADD COLUMN year INT AFTER Player;

UPDATE rz_rb2018 SET year = 2018;
UPDATE rz_rb2019 SET year = 2019;
UPDATE rz_rb2020 SET year = 2020;
UPDATE rz_rb2021 SET year = 2021;
UPDATE rz_rb2022 SET year = 2022;
UPDATE rz_rb2023 SET year = 2023;

CREATE TABLE rz_rb_all
LIKE rz_rb2018;

INSERT INTO rz_rb_all SELECT * FROM rz_rb2018;
INSERT INTO rz_rb_all SELECT * FROM rz_rb2019;
INSERT INTO rz_rb_all SELECT * FROM rz_rb2020;
INSERT INTO rz_rb_all SELECT * FROM rz_rb2021;
INSERT INTO rz_rb_all SELECT * FROM rz_rb2022;
INSERT INTO rz_rb_all SELECT * FROM rz_rb2023;

SELECT *
FROM rz_rb_all;

UPDATE rz_rb_all
SET Player = TRIM(SUBSTRING_INDEX(Player, '(', 1));

UPDATE rz_rb_all
SET Player = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Player, '*', ''), '+', ''), ' Sr.', ''), ' Jr.', ''), ' II', ''), ' III', ''), '.', '');

SELECT CONCAT(' CHANGE COLUMN `', COLUMN_NAME, '` `rz_', COLUMN_NAME, '` ', COLUMN_TYPE, ';')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'rz_rb_all';

ALTER TABLE rz_rb_all
CHANGE COLUMN `ATT` `rz_ATT` int,
CHANGE COLUMN `FL` `rz_FL` int,
CHANGE COLUMN `FPTS` `rz_FPTS` double,
CHANGE COLUMN `FPTS/G` `rz_FPTS/G` double,
CHANGE COLUMN `G` `rz_G` int,
CHANGE COLUMN `PCT` `rz_PCT` varchar(50),
CHANGE COLUMN `Rank` `rz_Rank` int,
CHANGE COLUMN `REC` `rz_REC` int,
CHANGE COLUMN `REC PCT` `rz_REC PCT` varchar(50),
CHANGE COLUMN `ROST %` `rz_ROST %` varchar(50),
CHANGE COLUMN `TD` `rz_TD_rush` int,
CHANGE COLUMN `TD_1` `rz_TD_rec` int,
CHANGE COLUMN `TGT` `rz_TGT` int,
CHANGE COLUMN `TGT PCT` `rz_TGT PCT` varchar(50),
CHANGE COLUMN `Y/A` `rz_Y/A` double,
CHANGE COLUMN `Y/R` `rz_Y/R` double,
CHANGE COLUMN `YDS` `rz_YDS_rush` int,
CHANGE COLUMN `YDS_1` `rz_YDS_rec` int;

ALTER TABLE rz_rb_all
ADD COLUMN rz_TD_total INT,
ADD COLUMN rz_YDS_total INT;

ALTER TABLE rz_rb_all
DROP COLUMN rz_Rank;

DELETE FROM rz_rb_all
WHERE Player IS NULL;

UPDATE rz_rb_all
SET rz_TD_total = rz_TD_rush + rz_TD_rec;

UPDATE rz_rb_all
SET rz_YDS_total = rz_YDS_rush + rz_YDS_rec;

-- Redzone TE Data --
SELECT *
FROM rz_te2018;

ALTER TABLE rz_te2018 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_te2019 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_te2020 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_te2021 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_te2022 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_te2023 ADD COLUMN year INT AFTER Player;

UPDATE rz_te2018 SET year = 2018;
UPDATE rz_te2019 SET year = 2019;
UPDATE rz_te2020 SET year = 2020;
UPDATE rz_te2021 SET year = 2021;
UPDATE rz_te2022 SET year = 2022;
UPDATE rz_te2023 SET year = 2023;

CREATE TABLE rz_te_all
LIKE rz_te2018;

INSERT INTO rz_te_all SELECT * FROM rz_te2018;
INSERT INTO rz_te_all SELECT * FROM rz_te2019;
INSERT INTO rz_te_all SELECT * FROM rz_te2020;
INSERT INTO rz_te_all SELECT * FROM rz_te2021;
INSERT INTO rz_te_all SELECT * FROM rz_te2022;
INSERT INTO rz_te_all SELECT * FROM rz_te2023;

SELECT *
FROM rz_te_all;

UPDATE rz_te_all
SET Player = TRIM(SUBSTRING_INDEX(Player, '(', 1));

UPDATE rz_te_all
SET Player = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Player, '*', ''), '+', ''), ' Sr.', ''), ' Jr.', ''), ' II', ''), ' III', ''), '.', '');

SELECT CONCAT(' CHANGE COLUMN `', COLUMN_NAME, '` `rz_', COLUMN_NAME, '` ', COLUMN_TYPE, ';')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'rz_te_all';

ALTER TABLE rz_te_all
CHANGE COLUMN `ATT` `rz_ATT` int,
CHANGE COLUMN `FL` `rz_FL` int,
CHANGE COLUMN `FPTS` `rz_FPTS` double,
CHANGE COLUMN `FPTS/G` `rz_FPTS/G` double,
CHANGE COLUMN `G` `rz_G` int,
CHANGE COLUMN `PCT` `rz_PCT` varchar(50),
CHANGE COLUMN `Rank` `rz_Rank` int,
CHANGE COLUMN `REC` `rz_REC` int,
CHANGE COLUMN `REC PCT` `rz_REC PCT` varchar(50),
CHANGE COLUMN `ROST %` `rz_ROST %` varchar(50),
CHANGE COLUMN `TD` `rz_TD_rush` int,
CHANGE COLUMN `TD_1` `rz_TD_rec` int,
CHANGE COLUMN `TGT` `rz_TGT` int,
CHANGE COLUMN `TGT PCT` `rz_TGT PCT` varchar(50),
CHANGE COLUMN `Y/R` `rz_Y/R` double,
CHANGE COLUMN `YDS` `rz_YDS_rush` int,
CHANGE COLUMN `YDS_1` `rz_YDS_rec` int;

ALTER TABLE rz_te_all
ADD COLUMN rz_TD_total INT,
ADD COLUMN rz_YDS_total INT;

ALTER TABLE rz_te_all
DROP COLUMN rz_Rank;

DELETE FROM rz_te_all
WHERE Player IS NULL;

UPDATE rz_te_all
SET rz_TD_total = rz_TD_rush + rz_TD_rec;

UPDATE rz_te_all
SET rz_YDS_total = rz_YDS_rush + rz_YDS_rec;

-- Redzone QB Data --
SELECT *
FROM rz_qb2018;

ALTER TABLE rz_qb2018 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_qb2019 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_qb2020 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_qb2021 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_qb2022 ADD COLUMN year INT AFTER Player;
ALTER TABLE rz_qb2023 ADD COLUMN year INT AFTER Player;

UPDATE rz_qb2018 SET year = 2018;
UPDATE rz_qb2019 SET year = 2019;
UPDATE rz_qb2020 SET year = 2020;
UPDATE rz_qb2021 SET year = 2021;
UPDATE rz_qb2022 SET year = 2022;
UPDATE rz_qb2023 SET year = 2023;

CREATE TABLE rz_qb_all
LIKE rz_qb2018;

INSERT INTO rz_qb_all SELECT * FROM rz_qb2018;
INSERT INTO rz_qb_all SELECT * FROM rz_qb2019;
INSERT INTO rz_qb_all SELECT * FROM rz_qb2020;
INSERT INTO rz_qb_all SELECT * FROM rz_qb2021;
INSERT INTO rz_qb_all SELECT * FROM rz_qb2022;
INSERT INTO rz_qb_all SELECT * FROM rz_qb2023;

SELECT *
FROM rz_qb_all;

UPDATE rz_qb_all
SET Player = TRIM(SUBSTRING_INDEX(Player, '(', 1));

UPDATE rz_qb_all
SET Player = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Player, '*', ''), '+', ''), ' Sr.', ''), ' Jr.', ''), ' II', ''), ' III', ''), '.', '');

SELECT CONCAT(' CHANGE COLUMN `', COLUMN_NAME, '` `rz_', COLUMN_NAME, '` ', COLUMN_TYPE, ';')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'rz_qb_all';

ALTER TABLE rz_qb_all
CHANGE COLUMN `ATT` `rz_ATT_pass` int,
CHANGE COLUMN `ATT_1` `rz_ATT_rush` int,
CHANGE COLUMN `COMP` `rz_COMP` int,
CHANGE COLUMN `FL` `rz_FL` int,
CHANGE COLUMN `FPTS` `rz_FPTS` double,
CHANGE COLUMN `FPTS/G` `rz_FPTS/G` double,
CHANGE COLUMN `G` `rz_G` int,
CHANGE COLUMN `INT` `rz_INT` int,
CHANGE COLUMN `PCT` `rz_PCT_pass` varchar(50),
CHANGE COLUMN `PCT_1` `rz_PCT_rush` varchar(50),
CHANGE COLUMN `Rank` `rz_Rank` int,
CHANGE COLUMN `ROST %` `rz_ROST %` varchar(50),
CHANGE COLUMN `SACKS` `rz_SACKS` int,
CHANGE COLUMN `TD` `rz_TD_pass` int,
CHANGE COLUMN `TD_1` `rz_TD_rush` int,
CHANGE COLUMN `Y/A` `rz_Y/A` double,
CHANGE COLUMN `YDS` `rz_YDS_pass` int,
CHANGE COLUMN `YDS_1` `rz_YDS_rush` int;

ALTER TABLE rz_qb_all
ADD COLUMN rz_TD_total INT,
ADD COLUMN rz_YDS_total INT,
ADD COLUMN rz_ATT_total INT;

ALTER TABLE rz_qb_all
DROP COLUMN rz_Rank;

SELECT *
FROM rz_qb_all
WHERE Player IS NULL;

DELETE FROM rz_qb_all
WHERE Player IS NULL;

UPDATE rz_qb_all
SET rz_TD_total = rz_TD_rush + rz_TD_pass;

UPDATE rz_qb_all
SET rz_YDS_total = rz_YDS_rush + rz_YDS_pass;

UPDATE rz_qb_all
SET rz_ATT_total = rz_ATT_rush + rz_ATT_pass;

-- ADP Data --
SELECT *
FROM adp2019;

ALTER TABLE adp2018 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2019 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2020 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2021 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2022 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2023 ADD COLUMN year INT AFTER Player;

UPDATE adp2018 SET year = 2018;
UPDATE adp2019 SET year = 2019;
UPDATE adp2020 SET year = 2020;
UPDATE adp2021 SET year = 2021;
UPDATE adp2022 SET year = 2022;
UPDATE adp2023 SET year = 2023;

CREATE TABLE adp_all
LIKE adp2018;

INSERT INTO adp_all SELECT * FROM adp2018;
INSERT INTO adp_all SELECT * FROM adp2019;
INSERT INTO adp_all SELECT * FROM adp2020;
INSERT INTO adp_all SELECT * FROM adp2021;
INSERT INTO adp_all SELECT * FROM adp2022;
INSERT INTO adp_all SELECT * FROM adp2023;

UPDATE adp_all
SET Player = TRIM(Player);

UPDATE adp_all
SET Bye = TRIM(Bye);

SELECT *
FROM adp_all
WHERE Team like '%O%' OR Bye like '%O%' or Bye like '%''%';

# Data didn't properly translate for some names, manual fixing
UPDATE adp_all
SET Player = CASE 
    WHEN Bye = '''Veon Bell' THEN 'Le''Veon Bell'
    WHEN Bye = '''Anthony Thomas' THEN 'De''Anthony Thomas'
    WHEN Bye = '''Mon Moore' THEN 'J''Mon Moore'
    WHEN Bye = '''Leary' THEN 'Nick O''Leary'
    WHEN Bye = '''ea Stringfellow' THEN 'Damore''ea Stringfellow'
    WHEN Bye = '''Angelo Henderson Sr.' THEN 'De''Angelo Henderson Sr.'
    WHEN Bye = '''Mari Scott' THEN 'Da''Mari Scott'
    WHEN Bye = '''Lance Turner' THEN 'De''Lance Turner'
    WHEN Bye = '''Son Williams' THEN 'Ty''Son Williams'
    WHEN Bye = '''Vonte Price' THEN 'D''Vonte Price'
    WHEN Bye = '''Shaughnessy' THEN 'James O''Shaughnessy'
    ELSE Player
END;

UPDATE adp_all
SET Player = CASE
    WHEN Player = 'dell Beckham Jr.' THEN 'Odell Beckham Jr.'
    WHEN Player = 'Josh liver' THEN 'Josh Oliver'
    WHEN Player = 'Albert kwuegbunam Jr.' THEN 'Albert Okwuegbunam Jr.'
    WHEN Player = 'Willie Snead IV' THEN 'Willie Snead'
    WHEN Player IN ('William Fuller V', 'William Fuller') THEN 'Will Fuller'
    WHEN Player = 'Gabe Davis' THEN 'Gabriel Davis'
    WHEN Player = 'Joshua Palmer' THEN 'Josh Palmer'
    WHEN Player = 'Hollywood Brown' THEN 'Marquise Brown'
    WHEN Player = 'Greg lsen' THEN 'Greg Olsen'
    WHEN Player = '.J. Howard' THEN 'O.J. Howard'
    WHEN Player = 'James ''Shaughnessy' THEN 'James O''Shaughnessy'
    WHEN Player = 'Chandler' THEN 'Chandler Cox'
    ELSE Player
END;

UPDATE adp_all
SET Player = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Player, '*', ''), '+', ''), ' Sr.', ''), ' Jr.', ''), ' II', ''), ' III', ''), '.', '');

-- Fantasy Points Data --
SELECT *
FROM fantasy2018;

ALTER TABLE fantasy2018 ADD COLUMN year INT AFTER Player;
ALTER TABLE fantasy2019 ADD COLUMN year INT AFTER Player;
ALTER TABLE fantasy2020 ADD COLUMN year INT AFTER Player;
ALTER TABLE fantasy2021 ADD COLUMN year INT AFTER Player;
ALTER TABLE fantasy2022 ADD COLUMN year INT AFTER Player;
ALTER TABLE fantasy2023 ADD COLUMN year INT AFTER Player;

UPDATE fantasy2018 SET year = 2018;
UPDATE fantasy2019 SET year = 2019;
UPDATE fantasy2020 SET year = 2020;
UPDATE fantasy2021 SET year = 2021;
UPDATE fantasy2022 SET year = 2022;
UPDATE fantasy2023 SET year = 2023;

CREATE TABLE fantasy_all
LIKE fantasy2018;

INSERT INTO fantasy_all SELECT * FROM fantasy2018;
INSERT INTO fantasy_all SELECT * FROM fantasy2019;
INSERT INTO fantasy_all SELECT * FROM fantasy2020;
INSERT INTO fantasy_all SELECT * FROM fantasy2021;
INSERT INTO fantasy_all SELECT * FROM fantasy2022;
INSERT INTO fantasy_all SELECT * FROM fantasy2023;

UPDATE adv_rec_all
SET Player = TRIM(Player);

UPDATE fantasy_all
SET Player = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Player, '*', ''), '+', ''), ' Sr.', ''), ' Jr.', ''), ' II', ''), ' III', ''), '.', '');

SELECT *
FROM fantasy_all;









