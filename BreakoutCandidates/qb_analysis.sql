-- QB Analysis --
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'rz_qb_all'
ORDER BY ORDINAL_POSITION;

SELECT *
FROM adv_rush_all
WHERE rush_Pos = 'QB';

CREATE TABLE qb_adp AS
SELECT 
    ap.*,
    ar.rush_Att,
    ar.rush_Yds,
    ar.rush_TD,
    ar.rush_1D,
    ar.rush_YBC,
    ar.`rush_YBC/Att`,
    ar.rush_YAC,
    ar.`rush_YAC/Att`,
    ar.rush_BrkTkl,
    ar.`rush_Att/Br`,
    rz.rz_COMP,
    rz.rz_ATT_pass,
    rz.rz_PCT_pass,
    rz.rz_YDS_pass,
    rz.`rz_Y/A`,
    rz.rz_TD_pass,
    rz.rz_INT,
    rz.rz_SACKS,
    rz.rz_ATT_rush,
    rz.rz_YDS_rush,
    rz.rz_TD_rush,
    rz.rz_PCT_rush,
    rz.rz_FL,
    rz.rz_G,
    rz.rz_FPTS,
    rz.`rz_FPTS/G`,
    rz.`rz_ROST %`,
    rz.rz_TD_total,
    rz.rz_YDS_total,
    rz.rz_ATT_total
FROM 
    adv_pass_all ap
JOIN 
    adv_rush_all ar ON ap.Player = ar.Player AND ap.year = ar.year
JOIN 
    rz_qb_all rz ON ap.Player = rz.Player AND ap.year = rz.year;

SELECT *
FROM qb_adp;

ALTER TABLE qb_adp
ADD COLUMN ADP FLOAT;

ALTER TABLE qb_adp
ADD COLUMN PPR_PTS FLOAT;

UPDATE qb_adp r
JOIN adp_all a ON r.Player = a.Player AND r.year = a.year
SET r.ADP = a.AVG;

UPDATE qb_adp r
JOIN fantasy_all f ON r.Player = f.Player AND r.year = f.year
SET r.PPR_PTS = f.PPR;

SELECT *
FROM qb_adp
WHERE ADP IS NULL
ORDER BY PPR_PTS DESC; # Certain players have a NULL ADP, the most note-wrothy of which is Geno Smith. Pretty much, all of these players were undrafted.

SELECT *
FROM adp_all
WHERE Player LIKE 'Geno%';

UPDATE qb_adp
SET ADP = 999
WHERE ADP IS NULL; # ADP of 999 essentially indicates that a player most likely went undrafted.

SELECT *
FROM qb_adp
WHERE PPR_PTS IS NULL
ORDER BY ADP ASC; # The highest drafted player with NULL PPR_PPTS is Ryan Fitzpatrick whose ADP is 182. These guys don't impact the results and can be removed for simplicity.

DELETE FROM qb_adp
WHERE PPR_PTS IS NULL;

ALTER TABLE qb_adp 
ADD COLUMN rank_total_ppr_points INT,
ADD COLUMN rank_adp INT;

# Rank players by total PPR points and ADP for each year
UPDATE qb_adp t1
JOIN (
    SELECT Player, year, PPR_PTS,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY PPR_PTS DESC) AS rank_total_ppr_points
    FROM qb_adp
) t2 ON t1.Player = t2.Player AND t1.year = t2.year
SET t1.rank_total_ppr_points = t2.rank_total_ppr_points;

UPDATE qb_adp t1
JOIN (
    SELECT Player, year, ADP,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY ADP ASC) AS rank_adp
    FROM qb_adp
) t2 ON t1.Player = t2.Player AND t1.year = t2.year
SET t1.rank_adp = t2.rank_adp;

# Creating a 'break out score' to measure if a player had a break out year (if total points greatly exceeds adp)
ALTER TABLE qb_adp 
ADD COLUMN breakout_score INT;

UPDATE qb_adp
SET breakout_score = rank_adp - rank_total_ppr_points;

SELECT *
FROM qb_adp
ORDER BY breakout_score DESC;

SELECT *
FROM qb_adp
WHERE year = 2018
ORDER BY rank_adp ASC;

CREATE TABLE qb_breakouts 
LIKE qb_adp;

SET @total_rows = 0;
SET @rank = 0; # Trying to find a good threshold for breakouts
SELECT @total_rows := COUNT(*), @rank := CEIL(COUNT(*) * 0.65)
FROM qb_adp; # 364 - 237 = 127; top 35% is the top 127 players
SELECT *
FROM qb_adp
ORDER BY breakout_score DESC
LIMIT 127; # 65th percentile of breakout score is 3

INSERT INTO qb_breakouts
SELECT *
FROM qb_adp
WHERE breakout_score > 3; # Removing names with a break out score of less than 4 (isolates the top % of breakouts)

SELECT *
FROM qb_breakouts;

# Now that I have a list of which players had breakout years, I will check their stats from the previous year to see if there's any indicators.
CREATE TABLE qb_pre_breakout
LIKE qb_breakouts;

INSERT INTO qb_pre_breakout
SELECT a.*
FROM qb_adp a
JOIN qb_breakouts b
ON a.Player = b.Player 
AND a.year = b.year - 1;

# Using python, I created a table, qb_diff, that contains the % difference in the averages of the columns of breakout players vs general average

# I also want to analyze the impact of team changes on breakout players
SELECT *
FROM qb_adp;

SELECT 
    COUNT(*) AS num_players_switched_teams
FROM 
    qb_breakouts b
JOIN 
    qb_adp a
ON 
    b.Player = a.Player
    AND a.year = b.year - 1
WHERE 
    b.pass_Tm != a.pass_Tm; 

SELECT 
    COUNT(*) AS num_players_switched_teams
FROM 
    qb_breakouts b
JOIN 
    qb_adp a
ON 
    b.Player = a.Player
    AND a.year = b.year - 1; # 30/78 (38%) breakout players switched teams

SELECT 
    SUM(num_switched) AS avg_players_switched
FROM (
    SELECT 
        COUNT(*) AS num_switched
    FROM 
        qb_adp a1
    JOIN 
        qb_adp a2
    ON 
        a1.Player = a2.Player
        AND a1.year = a2.year - 1
    WHERE 
        a1.pass_Tm != a2.pass_Tm
    GROUP BY 
        a2.year
) AS yearly_switch_counts;

SELECT 
    SUM(num_switched) AS avg_players_switched
FROM (
    SELECT 
        COUNT(*) AS num_switched
    FROM 
        qb_adp a1
    JOIN 
        qb_adp a2
    ON 
        a1.Player = a2.Player
        AND a1.year = a2.year - 1
    GROUP BY 
        a2.year
) AS yearly_switch_counts; # 61/219 (28%) players in general switched teams from one year to the next

# Unlike the other positions, breakout QBs actually switched teams much more frequently than the average. This could point towards the fact that being part of a different system heavily elevates a QBs play.

