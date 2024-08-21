-- RB Analysis --
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'rz_rb_all'
ORDER BY ORDINAL_POSITION;

CREATE TABLE rb_adp AS
SELECT 
    ar.*,
    re.rec_Tgt,
    re.rec_Rec,
    re.rec_Yds,
    re.rec_TD,
    re.rec_1D,
    re.rec_YBC,
    re.`rec_YBC/R`,
    re.rec_YAC,
    re.`rec_YAC/R`,
    re.rec_ADOT,
    re.rec_BrkTkl,
    re.`rec_Rec/Br`,
    re.rec_Drop,
    re.`rec_Drop%`,
    re.rec_Int,
    re.rec_Rat,
    rz.rz_ATT,
    rz.rz_YDS_rush,
    rz.`rz_Y/A`,
    rz.rz_TD_rush,
    rz.rz_PCT,
    rz.rz_REC,
    rz.rz_TGT,
    rz.`rz_REC PCT`,
    rz.rz_YDS_rec,
    rz.`rz_Y/R`,
    rz.rz_TD_rec,
    rz.`rz_TGT PCT`,
    rz.rz_TD_total,
    rz.rz_YDS_total
FROM 
    adv_rush_all ar
JOIN 
    adv_rec_all re ON ar.Player = re.Player AND ar.year = re.year
JOIN 
    rz_rb_all rz ON ar.Player = rz.Player AND ar.year = rz.year;

SELECT *
FROM rb_adp;

ALTER TABLE rb_adp
ADD COLUMN ADP FLOAT;

ALTER TABLE rb_adp
ADD COLUMN PPR_PTS FLOAT;

UPDATE rb_adp r
JOIN adp_all a ON r.Player = a.Player AND r.year = a.year
SET r.ADP = a.AVG;

UPDATE rb_adp r
JOIN fantasy_all f ON r.Player = f.Player AND r.year = f.year
SET r.PPR_PTS = f.PPR;

SELECT *
FROM rb_adp
WHERE ADP IS NULL
ORDER BY PPR_PTS DESC; # Certain players have a NULL ADP, the most note-wrothy of which is Myles Gaskin. Pretty much, all of these players were undrafted.

SELECT *
FROM adp_all
WHERE Player LIKE 'Latavi%';

UPDATE rb_adp
SET ADP = 999
WHERE ADP IS NULL; # ADP of 999 essentially indicates that a player most likely went undrafted.

SELECT *
FROM rb_adp
WHERE PPR_PTS IS NULL
ORDER BY ADP ASC; # The highest drafted player with NULL PPR_PPTS is Pharoh Cooper whose ADP is 177. These guys don't impact the results and can be removed for simplicity.

DELETE FROM rb_adp
WHERE PPR_PTS IS NULL;

SELECT DISTINCT rush_Pos
FROM rb_adp;

SELECT *
FROM rb_adp
WHERE rush_Pos = 'FB' OR rush_Pos = 'DB'
ORDER BY PPR_PTS DESC; # FB and RB are irrelvant

DELETE FROM rb_adp
WHERE rush_Pos != 'RB';

SELECT *
FROM rb_adp;

ALTER TABLE rb_adp 
ADD COLUMN rank_total_ppr_points INT,
ADD COLUMN rank_adp INT;

# Rank players by total PPR points and ADP for each year
UPDATE rb_adp t1
JOIN (
    SELECT Player, year, PPR_PTS,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY PPR_PTS DESC) AS rank_total_ppr_points
    FROM rb_adp
) t2 ON t1.Player = t2.Player AND t1.year = t2.year
SET t1.rank_total_ppr_points = t2.rank_total_ppr_points;

UPDATE rb_adp t1
JOIN (
    SELECT Player, year, ADP,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY ADP ASC) AS rank_adp
    FROM rb_adp
) t2 ON t1.Player = t2.Player AND t1.year = t2.year
SET t1.rank_adp = t2.rank_adp;

# Creating a 'break out score' to measure if a player had a break out year (if total points greatly exceeds adp)
ALTER TABLE rb_adp 
ADD COLUMN breakout_score INT;

UPDATE rb_adp
SET breakout_score = rank_adp - rank_total_ppr_points;

SELECT *
FROM rb_adp
ORDER BY breakout_score DESC;

CREATE TABLE rb_breakouts 
LIKE rb_adp;

SET @total_rows = 0;
SET @rank = 0; # Trying to find a good threshold for breakouts
SELECT @total_rows := COUNT(*), @rank := CEIL(COUNT(*) * 0.65)
FROM rb_adp; # 677 - 441 = 236; top 35% is the top 236 players
SELECT *
FROM rb_adp
ORDER BY breakout_score DESC
LIMIT 236; # 65th percentile of breakout score is 8

INSERT INTO rb_breakouts
SELECT *
FROM rb_adp
WHERE breakout_score > 7; # Removing names with a break out score of less than 8 (isolates the top % of breakouts)

SELECT *
FROM rb_breakouts;

# Now that I have a list of which players had breakout years, I will check their stats from the previous year to see if there's any indicators.
CREATE TABLE rb_pre_breakout
LIKE rb_breakouts;

INSERT INTO rb_pre_breakout
SELECT a.*
FROM rb_adp a
JOIN rb_breakouts b
ON a.Player = b.Player 
AND a.year = b.year - 1;

# Using python, I created a table, rb_diff, that contains the % difference in the averages of the columns of breakout players vs general average

# I also want to analyze the impact of team changes on breakout players
SELECT 
    COUNT(*) AS num_players_switched_teams
FROM 
    rb_breakouts b
JOIN 
    rb_adp a
ON 
    b.Player = a.Player
    AND a.year = b.year - 1
WHERE 
    b.Tm != a.Tm; 

SELECT 
    COUNT(*) AS num_players_switched_teams
FROM 
    rb_breakouts b
JOIN 
    rb_adp a
ON 
    b.Player = a.Player
    AND a.year = b.year - 1; # 42/130 (32%) breakout players switched teams

SELECT 
    SUM(num_switched) AS avg_players_switched
FROM (
    SELECT 
        COUNT(*) AS num_switched
    FROM 
        rb_adp a1
    JOIN 
        rb_adp a2
    ON 
        a1.Player = a2.Player
        AND a1.year = a2.year - 1
    WHERE 
        a1.Tm != a2.Tm
    GROUP BY 
        a2.year
) AS yearly_switch_counts;

SELECT 
    SUM(num_switched) AS avg_players_switched
FROM (
    SELECT 
        COUNT(*) AS num_switched
    FROM 
        rb_adp a1
    JOIN 
        rb_adp a2
    ON 
        a1.Player = a2.Player
        AND a1.year = a2.year - 1
    GROUP BY 
        a2.year
) AS yearly_switch_counts; # 118/397 (30%) players in general switched teams from one year to the next

# Surprsingly, break out players switched teams at roughly the same frequency as everyone else
