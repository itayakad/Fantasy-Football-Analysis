-- Cleaning offense_yearly --
CREATE TABLE yearly_staging
LIKE offense_yearly_data;

INSERT yearly_staging
SELECT *
FROM offense_yearly_data;

SELECT *
FROM yearly_staging;
 
ALTER TABLE yearly_staging
DROP COLUMN id,
DROP COLUMN height_ft,
DROP COLUMN height_cm,
DROP COLUMN season_type,
DROP COLUMN fantasy_points,
DROP COLUMN count,
DROP COLUMN ppg,
DROP COLUMN rookie_season,
DROP COLUMN round,
DROP COLUMN overall,
DROP COLUMN forty,
DROP COLUMN bench,
DROP COLUMN vertical,
DROP COLUMN fp_ps;

UPDATE yearly_staging
SET name = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(name, '*', ''), '+', ''), ' Sr.', ''), ' Jr.', ''), ' II', ''), ' III', ''), '.', '');

UPDATE yearly_staging
SET name = TRIM(name);
-- QB Table -- 
CREATE TABLE yearly_qb
LIKE yearly_staging;

INSERT yearly_qb
SELECT *
FROM yearly_staging WHERE position = 'QB';

SELECT *
FROM yearly_qb;

ALTER TABLE yearly_qb
DROP COLUMN receptions,
DROP COLUMN targets,
DROP COLUMN receiving_yards,
DROP COLUMN receiving_tds,
DROP COLUMN receiving_fumbles,
DROP COLUMN receiving_fumbles_lost,
DROP COLUMN receiving_air_yards,
DROP COLUMN receiving_yards_after_catch,
DROP COLUMN receiving_first_downs,
DROP COLUMN receiving_2pt_conversions,
DROP COLUMN target_share,
DROP COLUMN air_yards_share,
DROP COLUMN rec_td_percentage,
DROP COLUMN rec_ypg,
DROP COLUMN ypr;

SELECT *
FROM yearly_qb;

SELECT AVG(offense_pct), AVG(ppr_fp_ps)
FROM yearly_qb
WHERE ppr_ppg > 10; # o_pct = 0.92; fp_ps = 0.27

UPDATE yearly_qb
SET offense_pct = CASE # Giving players with more than 10 PPG the average offense_pct; Otherwise, 0
	WHEN ppr_ppg > 10 THEN 0.92
	ELSE 0
END
WHERE offense_pct IS NULL;

UPDATE yearly_qb
SET ppr_fp_ps = CASE # Giving players with more than 10 PPG the average ppr_fp_ps; Otherwise, 0
	WHEN ppr_ppg > 10 THEN 0.27
	ELSE 0
END
WHERE ppr_fp_ps like '%inf%';

-- Flex Table --
CREATE TABLE yearly_flex
LIKE yearly_staging;

SELECT DISTINCT position
FROM yearly_staging;

INSERT yearly_flex
SELECT *
FROM yearly_staging
WHERE position != 'QB';

SELECT *
FROM yearly_flex;

ALTER TABLE yearly_flex
DROP COLUMN completions,
DROP COLUMN attempts,
DROP COLUMN passing_yards,
DROP COLUMN passing_tds,
DROP COLUMN interceptions,
DROP COLUMN sacks,
DROP COLUMN sack_yards,
DROP COLUMN sack_fumbles,
DROP COLUMN sack_fumbles_lost,
DROP COLUMN passing_air_yards,
DROP COLUMN passing_yards_after_catch,
DROP COLUMN passing_first_downs,
DROP COLUMN passing_2pt_conversions,
DROP COLUMN comp_percentage,
DROP COLUMN pass_td_percentage,
DROP COLUMN int_percentage,
DROP COLUMN pass_ypg,
DROP COLUMN pr;

SELECT *
FROM yearly_flex
WHERE name LIKE '%Odell%';

SELECT AVG(offense_pct), AVG(ppr_fp_ps), AVG(yps)
FROM yearly_flex
WHERE ppr_ppg > 10; # o_pct = 0.70; fp_ps = 0.30, yps = 1.5

UPDATE yearly_flex
SET offense_pct = CASE # Giving players with more than 10 PPG the average offense_pct; Otherwise, 0
	WHEN ppr_ppg > 10 THEN 0.70
	ELSE 0
END
WHERE offense_pct IS NULL;

UPDATE yearly_flex
SET ppr_fp_ps = CASE # Giving players with more than 10 PPG the average ppr_fp_ps; Otherwise, 0
	WHEN ppr_ppg > 10 THEN 0.30
	ELSE 0
END
WHERE ppr_fp_ps like '%inf%';

UPDATE yearly_flex
SET yps = CASE # Giving players with more than 10 PPG the average ppr_fp_ps; Otherwise, 0
	WHEN ppr_ppg > 10 THEN 1.5
	ELSE 0
END
WHERE yps like '%inf%';

-- Team Metrics --
CREATE TABLE team_staging
LIKE team_stats;

INSERT team_staging
SELECT *
FROM team_stats;

SELECT *
FROM team_staging;

UPDATE team_staging
SET team = CASE
    WHEN team = 'Arizona Cardinals' THEN 'ARI'
    WHEN team = 'Atlanta Falcons' THEN 'ATL'
    WHEN team = 'Baltimore Ravens' THEN 'BAL'
    WHEN team = 'Buffalo Bills' THEN 'BUF'
    WHEN team = 'Carolina Panthers' THEN 'CAR'
    WHEN team = 'Chicago Bears' THEN 'CHI'
    WHEN team = 'Cincinnati Bengals' THEN 'CIN'
    WHEN team = 'Cleveland Browns' THEN 'CLE'
    WHEN team = 'Dallas Cowbyearlys' THEN 'DAL'
    WHEN team = 'Denver Broncos' THEN 'DEN'
    WHEN team = 'Detroit Lions' THEN 'DET'
    WHEN team = 'Green Bay Packers' THEN 'GB'
    WHEN team = 'Houston Texans' THEN 'HOU'
    WHEN team = 'Indianapolis Colts' THEN 'IND'
    WHEN team = 'Jacksonville Jaguars' THEN 'JAX'
    WHEN team = 'Kansas City Chiefs' THEN 'KC'
    WHEN team = 'Las Vegas Raiders' THEN 'LV'
    WHEN team = 'Los Angeles Chargers' THEN 'LAC'
    WHEN team = 'Los Angeles Rams' THEN 'LAR'
    WHEN team = 'Miami Dolphins' THEN 'MIA'
    WHEN team = 'Minnesota Vikings' THEN 'MIN'
    WHEN team = 'New England Patriots' THEN 'NE'
    WHEN team = 'New Orleans Saints' THEN 'NO'
    WHEN team = 'New York Giants' THEN 'NYG'
    WHEN team = 'New York Jets' THEN 'NYJ'
    WHEN team = 'Philadelphia Eagles' THEN 'PHI'
    WHEN team = 'Pittsburgh Steelers' THEN 'PIT'
    WHEN team = 'San Francisco 49ers' THEN 'SF'
    WHEN team = 'Seattle Seahawks' THEN 'SEA'
    WHEN team = 'Tampa Bay Buccaneers' THEN 'TB'
    WHEN team = 'Tennessee Titans' THEN 'TEN'
    WHEN team = 'Washington Commanders' THEN 'WAS'
    WHEN team = 'San Diego Chargers' THEN 'LAC'
    WHEN team = 'Oakland Raiders' THEN 'LV'
    WHEN team = 'Washington Redskins' THEN 'WAS'
    WHEN team = 'St. Louis Rams' THEN 'LAR'
    WHEN team = 'Washington Football Team' THEN 'WAS'
    ELSE team
END;

ALTER TABLE team_staging
DROP COLUMN mov; # Too many null values

ALTER TABLE team_staging 
CHANGE team team_name VARCHAR(255),
CHANGE total_yards total_team_yds INT;

-- Flex, Team Only --
SELECT *
FROM yearly_flex;

CREATE TABLE flex_teamonly AS
SELECT 
    f.name,
    f.`position`,
    f.team,
    f.season,
    f.fantasy_points_ppr,
    t.*
FROM 
    yearly_flex AS f
JOIN 
    team_staging AS t
ON 
    f.season = t.year 
AND 
    f.team = t.team_name;

SELECT *
FROM flex_teamonly;

ALTER TABLE flex_teamonly
DROP COLUMN team_name,
DROP COLUMN year;

-- Flex + Team Data --
CREATE TABLE flex_team AS
SELECT 
    f.*,
    t.*
FROM 
    yearly_flex AS f
JOIN 
    team_staging AS t
ON 
    f.season = t.year 
AND 
    f.team = t.team_name;

SELECT *
FROM flex_team;

ALTER TABLE flex_team
DROP COLUMN team_name,
DROP COLUMN year;

-- QB + Team Data --
CREATE TABLE qb_team AS
SELECT 
    f.*,
    t.*
FROM 
    yearly_qb AS f
JOIN 
    team_staging AS t
ON 
    f.season = t.year 
AND 
    f.team = t.team_name;

SELECT *
FROM qb_team;

ALTER TABLE qb_team
DROP COLUMN team_name,
DROP COLUMN year;

-- ADP --
SELECT COUNT(*)
FROM adp2017;

ALTER TABLE adp2013 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2014 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2015 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2016 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2017 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2018 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2019 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2020 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2021 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2022 ADD COLUMN year INT AFTER Player;
ALTER TABLE adp2023 ADD COLUMN year INT AFTER Player;

UPDATE adp2013 SET year = 2013;
UPDATE adp2014 SET year = 2014;
UPDATE adp2015 SET year = 2015;
UPDATE adp2016 SET year = 2016;
UPDATE adp2017 SET year = 2017;
UPDATE adp2018 SET year = 2018;
UPDATE adp2019 SET year = 2019;
UPDATE adp2020 SET year = 2020;
UPDATE adp2021 SET year = 2021;
UPDATE adp2022 SET year = 2022;
UPDATE adp2023 SET year = 2023;

CREATE TABLE adp_everything
LIKE adp2018;

SELECT *
FROM adp2013;

ALTER TABLE adp2023
DROP COLUMN Sleeper,
DROP COLUMN RTSports,
DROP COLUMN ESPN,
DROP COLUMN NFL,
DROP COLUMN FFC;

INSERT INTO adp_everything SELECT * FROM adp2013;
INSERT INTO adp_everything SELECT * FROM adp2014;
INSERT INTO adp_everything SELECT * FROM adp2015;
INSERT INTO adp_everything SELECT * FROM adp2016;
INSERT INTO adp_everything SELECT * FROM adp2017;
INSERT INTO adp_everything SELECT * FROM adp2018;
INSERT INTO adp_everything SELECT * FROM adp2019;
INSERT INTO adp_everything SELECT * FROM adp2020;
INSERT INTO adp_everything SELECT * FROM adp2021;
INSERT INTO adp_everything SELECT * FROM adp2022;
INSERT INTO adp_everything SELECT * FROM adp2023;

SELECT *
FROM adp_everything;

UPDATE adp_everything
SET Player = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Player, '*', ''), '+', ''), ' Sr.', ''), ' Jr.', ''), ' II', ''), ' III', ''), '.', '');

UPDATE adp_everything
SET Player = TRIM(Player);

SELECT *
FROM adp_everything ae 
WHERE Player like '%Aaron Jones%';

CREATE TABLE adp_flex AS
SELECT *
FROM adp_everything
WHERE POS LIKE '%WR%'
	OR POS LIKE '%TE%'
	OR POS LIKE '%RB%';
  
CREATE TABLE adp_qb AS
SELECT *
FROM adp_everything
WHERE POS LIKE '%QB%';

-- Flex Control --
CREATE TABLE control_flex (
	`rank` INT,
    player_name VARCHAR(255),
    year INT,
    position VARCHAR(255),
    points double,
    preseason_rank INT,
    postseason_rank INT
);

INSERT INTO control_flex (player_name, year, position, points)
SELECT name, season, position, fantasy_points_ppr FROM yearly_flex;

UPDATE control_flex fc
JOIN adp_flex ae
ON fc.player_name = ae.Player AND fc.year = ae.year
SET fc.`rank` = ae.`Rank`;

SELECT *
FROM control_flex;

# Players who have a NULL rank get set to undrafted
CREATE TEMPORARY TABLE temp_max_rank AS
SELECT year, MAX(`rank`) AS max_rank
FROM control_flex
GROUP BY year;

UPDATE 
    control_flex fc
JOIN 
    temp_max_rank tmr
ON 
    fc.year = tmr.year
SET 
    fc.`rank` = tmr.max_rank + 1
WHERE 
    fc.`rank` IS NULL;

DROP TEMPORARY TABLE temp_max_rank;

UPDATE control_flex t1
JOIN (
    SELECT player_name, year, points,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY points DESC) AS postseason_rank
    FROM control_flex
) t2 ON t1.player_name = t2.player_name AND t1.year = t2.year
SET t1.postseason_rank = t2.postseason_rank;

UPDATE control_flex t1
JOIN (
    SELECT player_name, year, `rank`,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY `rank`) AS preseason_rank
    FROM control_flex
) t2 ON t1.player_name = t2.player_name AND t1.year = t2.year
SET t1.preseason_rank = t2.preseason_rank;

SELECT *
FROM control_flex
WHERE `rank` IS NULL
ORDER BY points DESC;

SELECT *
FROM adp_flex ae 
WHERE Player LIKE '%Odell%'
ORDER BY year DESC;

# Accuracy Score
SELECT *
FROM control_flex
ORDER BY year DESC;

ALTER TABLE control_flex
ADD COLUMN accuracy_score INT;

UPDATE control_flex
SET accuracy_score = CASE
    WHEN preseason_rank = postseason_rank AND preseason_rank <= 20 AND postseason_rank <= 20 THEN 2
    WHEN preseason_rank <= 20 AND postseason_rank <= 20 THEN 1
    ELSE 0
END;

ALTER TABLE control_flex 
ADD COLUMN yearly_ac INT;

UPDATE control_flex fc
JOIN (
    SELECT 
        year, 
        SUM(accuracy_score) AS yearly_total
    FROM 
        control_flex
    GROUP BY 
        year
) AS yearly_totals
ON 
    fc.year = yearly_totals.year
SET 
    fc.yearly_ac = yearly_totals.yearly_total;

ALTER TABLE control_flex 
ADD COLUMN total_accuracy_score INT;

CREATE TEMPORARY TABLE temp_total_accuracy_score AS
SELECT SUM(yearly_ac) AS total_accuracy_score
FROM (
    SELECT DISTINCT year, yearly_ac
    FROM control_flex
    WHERE year <> 2013
) AS yearly_scores;

UPDATE control_flex
SET total_accuracy_score = (
    SELECT total_accuracy_score 
    FROM temp_total_accuracy_score
);

DROP TEMPORARY TABLE temp_total_accuracy_score;

-- QB Control --
CREATE TABLE control_qb (
	`rank` INT,
    player_name VARCHAR(255),
    year INT,
    position VARCHAR(255),
    points double,
    preseason_rank INT,
    postseason_rank INT
);

INSERT INTO control_qb (player_name, year, position, points)
SELECT name, season, position, fantasy_points_ppr FROM yearly_qb;

UPDATE control_qb fc
JOIN adp_qb ae
ON fc.player_name = ae.Player AND fc.year = ae.year
SET fc.`rank` = ae.`Rank`;

SELECT *
FROM control_qb;

# Players who have a NULL rank get set to undrafted
CREATE TEMPORARY TABLE temp_max_rank AS
SELECT year, MAX(`rank`) AS max_rank
FROM control_qb
GROUP BY year;

UPDATE 
    control_qb fc
JOIN 
    temp_max_rank tmr
ON 
    fc.year = tmr.year
SET 
    fc.`rank` = tmr.max_rank + 1
WHERE 
    fc.`rank` IS NULL;

DROP TEMPORARY TABLE temp_max_rank;

UPDATE control_qb t1
JOIN (
    SELECT player_name, year, points,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY points DESC) AS postseason_rank
    FROM control_qb
) t2 ON t1.player_name = t2.player_name AND t1.year = t2.year
SET t1.postseason_rank = t2.postseason_rank;

UPDATE control_qb t1
JOIN (
    SELECT player_name, year, `rank`,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY `rank`) AS preseason_rank
    FROM control_qb
) t2 ON t1.player_name = t2.player_name AND t1.year = t2.year
SET t1.preseason_rank = t2.preseason_rank;

SELECT *
FROM control_qb
WHERE `rank` IS NULL
ORDER BY points DESC;

SELECT *
FROM adp_qb ae 
WHERE Player LIKE '%Odell%'
ORDER BY year DESC;

# Accuracy Score
SELECT *
FROM control_qb;

ALTER TABLE control_qb
ADD COLUMN accuracy_score INT;

UPDATE control_qb
SET accuracy_score = CASE
    WHEN preseason_rank = postseason_rank AND preseason_rank <= 20 AND postseason_rank <= 20 THEN 2
    WHEN preseason_rank <= 20 AND postseason_rank <= 20 THEN 1
    ELSE 0
END;

ALTER TABLE control_qb 
ADD COLUMN yearly_ac INT;

UPDATE control_qb fc
JOIN (
    SELECT 
        year, 
        SUM(accuracy_score) AS yearly_total
    FROM 
        control_qb
    GROUP BY 
        year
) AS yearly_totals
ON 
    fc.year = yearly_totals.year
SET 
    fc.yearly_ac = yearly_totals.yearly_total;

ALTER TABLE control_qb 
ADD COLUMN total_accuracy_score INT;

CREATE TEMPORARY TABLE temp_total_accuracy_score AS
SELECT SUM(yearly_ac) AS total_accuracy_score
FROM (
    SELECT DISTINCT year, yearly_ac
    FROM control_qb
    WHERE year <> 2013
) AS yearly_scores;

UPDATE control_qb
SET total_accuracy_score = (
    SELECT total_accuracy_score 
    FROM temp_total_accuracy_score
);

DROP TEMPORARY TABLE temp_total_accuracy_score;

-- EDA --
SELECT *
FROM control_flex
WHERE year = 2014
ORDER BY postseason_rank ASC;

