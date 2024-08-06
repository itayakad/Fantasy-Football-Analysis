-- Making the staging tables --
CREATE TABLE ow_staging
LIKE offense_weekly_data;

INSERT ow_staging
SELECT *
FROM offense_weekly_data;

SELECT *
FROM ow_staging;

CREATE TABLE oy_staging
LIKE offense_yearly_data;

INSERT oy_staging
SELECT *
FROM offense_yearly_data;

SELECT *
FROM oy_staging;

-- Cleaning offense yearly stats --
SELECT *
FROM oy_staging;

# Dropping unwanted columns
ALTER TABLE oy_staging
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

# Creating qb table
CREATE TABLE oy_qb
LIKE oy_staging;

INSERT oy_qb
SELECT *
FROM oy_staging
WHERE position = 'QB';

SELECT *
FROM oy_qb;

ALTER TABLE oy_qb
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
FROM oy_qb
WHERE offense_pct IS NULL;
# Getting rid of rows with significant missing data
SELECT name, offense_snaps, teams_offense_snaps, offense_pct, years_played, passing_yards, season
FROM oy_qb
WHERE offense_snaps IS NULL OR teams_offense_snaps IS NULL OR offense_pct IS NULL OR years_played IS NULL;

DELETE FROM oy_qb
WHERE offense_snaps IS NULL OR teams_offense_snaps IS NULL OR offense_pct IS NULL OR years_played IS NULL;

# Creating wr/rb/te table
CREATE TABLE oy_flex
LIKE oy_staging;

INSERT oy_flex
SELECT *
FROM oy_staging
WHERE position != 'QB';

SELECT *
FROM oy_flex;

ALTER TABLE oy_flex
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

# Getting rid of rows with null values
SELECT *
FROM oy_flex;
WHERE offense_pct IS NULL;

DELETE FROM oy_flex
WHERE offense_pct IS NULL;

-- Joining team data --
SELECT *
from team_stats;

CREATE TABLE team_data
LIKE team_stats;

SELECT *
FROM team_data;

INSERT team_data
SELECT *
FROM team_stats;

UPDATE team_data
SET team = CASE
    WHEN team = 'Arizona Cardinals' THEN 'ARI'
    WHEN team = 'Atlanta Falcons' THEN 'ATL'
    WHEN team = 'Baltimore Ravens' THEN 'BAL'
    WHEN team = 'Buffalo Bills' THEN 'BUF'
    WHEN team = 'Carolina Panthers' THEN 'CAR'
    WHEN team = 'Chicago Bears' THEN 'CHI'
    WHEN team = 'Cincinnati Bengals' THEN 'CIN'
    WHEN team = 'Cleveland Browns' THEN 'CLE'
    WHEN team = 'Dallas Cowboys' THEN 'DAL'
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
    ELSE team
END;

UPDATE team_data
SET team = CASE
	WHEN team = 'San Diego Chargers' THEN 'LAC'
	WHEN team = 'Oakland Raiders' THEN 'LV'
	WHEN team = 'Washington Redskins' THEN 'WAS'
	WHEN team = 'St. Louis Rams' THEN 'LAR'
	WHEN team = 'Washington Football Team' THEN 'WAS'
	ELSE team
END

SELECT team
FROM team_data
ORDER BY LENGTH(team) DESC;

CREATE TABLE flex_team
LIKE oy_flex;

INSERT flex_team
SELECT *
FROM oy_flex;

SELECT *
FROM flex_team;

SELECT *
FROM flex_team AS f
JOIN team_data AS t
ON f.team = t.team AND f.season = t.year;

SELECT *
FROM flexplayer_team;

CREATE TABLE qb_team
LIKE oy_qb;

INSERT qb_team
SELECT *
FROM oy_qb;

SELECT *
FROM qb_team;

SELECT *
FROM qb_team AS q
JOIN team_data AS t
ON q.team = t.team AND q.season = t.year;
-- EDA --
SELECT *
FROM oy_flex
WHERE position = 'TE';






