-- TE Analysis --
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'rz_te_all'
ORDER BY ORDINAL_POSITION;

CREATE TABLE te_adp AS
SELECT 
    re.*,
    rz.rz_REC,
    rz.rz_TGT,
    rz.`rz_REC PCT`,
    rz.rz_YDS_rush,
    rz.`rz_Y/R`,
    rz.rz_TD_rush,
    rz.`rz_TGT PCT`,
    rz.rz_ATT,
    rz.rz_YDS_rec,
    rz.rz_TD_rec,
    rz.rz_PCT,
    rz.rz_FL,
    rz.rz_G,
    rz.rz_FPTS,
    rz.`rz_FPTS/G`,
    rz.`rz_ROST %`,
    rz.rz_TD_total,
    rz.rz_YDS_total
FROM 
    adv_rec_all re
JOIN 
    rz_te_all rz ON re.Player = rz.Player AND re.year = rz.year;

SELECT *
FROM te_adp;

ALTER TABLE te_adp
ADD COLUMN ADP FLOAT;

ALTER TABLE te_adp
ADD COLUMN PPR_PTS FLOAT;

UPDATE te_adp r
JOIN adp_all a ON r.Player = a.Player AND r.year = a.year
SET r.ADP = a.AVG;

UPDATE te_adp r
JOIN fantasy_all f ON r.Player = f.Player AND r.year = f.year
SET r.PPR_PTS = f.PPR;

SELECT *
FROM te_adp
WHERE ADP IS NULL
ORDER BY PPR_PTS DESC; # Certain players have a NULL ADP, the most note-wrothy of which is Juwan Johnson. Pretty much, all of these players were either undrafted or went very late in drafts.

SELECT *
FROM adp_all
WHERE Player LIKE 'Juwan%';

SELECT COUNT(*)
FROM adp_all
WHERE year = 2022;

UPDATE te_adp
SET ADP = 999
WHERE ADP IS NULL; # ADP of 999 essentially indicates that a player most likely went undrafted.

SELECT *
FROM te_adp
WHERE PPR_PTS IS NULL
ORDER BY ADP ASC; # The highest drafted player with NULL PPR_PPTS is Pharoh Cooper whose ADP is 260. These guys don't impact the results and can be removed for simplicity.

DELETE FROM te_adp
WHERE PPR_PTS IS NULL;

SELECT DISTINCT rec_Pos
FROM te_adp;

SELECT *
FROM te_adp
WHERE rec_Pos != 'TE'
ORDER BY PPR_PTS DESC; # Taysom Hill is listed as both a QB and TE. Since he is he only one to be listed like this, he will not be considered as he will heavily skew the data.

DELETE FROM te_adp
WHERE rec_Pos != 'TE';

SELECT *
FROM te_adp;

ALTER TABLE te_adp 
ADD COLUMN rank_total_ppr_points INT,
ADD COLUMN rank_adp INT;

# Rank players by total PPR points and ADP for each year
UPDATE te_adp t1
JOIN (
    SELECT Player, year, PPR_PTS,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY PPR_PTS DESC) AS rank_total_ppr_points
    FROM te_adp
) t2 ON t1.Player = t2.Player AND t1.year = t2.year
SET t1.rank_total_ppr_points = t2.rank_total_ppr_points;

UPDATE te_adp t1
JOIN (
    SELECT Player, year, ADP,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY ADP ASC) AS rank_adp
    FROM te_adp
) t2 ON t1.Player = t2.Player AND t1.year = t2.year
SET t1.rank_adp = t2.rank_adp;

# Creating a 'break out score' to measure if a player had a break out year (if total points greatly exceeds adp)
ALTER TABLE te_adp 
ADD COLUMN breakout_score INT;

UPDATE te_adp
SET breakout_score = rank_adp - rank_total_ppr_points;

SELECT *
FROM te_adp
WHERE rank_total_ppr_points < 16
ORDER BY breakout_score DESC;

DELETE FROM te_adp # TE are not drafted as often as other positions, so breakout candidates will only be considered if they finished top 15
WHERE rank_total_ppr_points > 16;

CREATE TABLE te_breakouts 
LIKE te_adp;

SET @total_rows = 0;
SET @rank = 0; # Trying to find a good threshold for breakouts
SELECT @total_rows := COUNT(*), @rank := CEIL(COUNT(*) * 0.55) # Lower threshold since the sample of TE is much smaller
FROM te_adp; # 96 - 53 = 43; top 35% is the top 236 players
SELECT *
FROM te_adp
ORDER BY breakout_score DESC
LIMIT 43; # 55th percentile of breakout score is 4

INSERT INTO te_breakouts
SELECT *
FROM te_adp
WHERE breakout_score > 3; # Removing names with a break out score of less than 8 (isolates the top % of breakouts)

SELECT *
FROM te_breakouts;

# Now that I have a list of which players had breakout years, I will check their stats from the previous year to see if there's any indicators.
CREATE TABLE te_pre_breakout
LIKE te_breakouts;

INSERT INTO te_pre_breakout
SELECT a.*
FROM te_adp a
JOIN te_breakouts b
ON a.Player = b.Player 
AND a.year = b.year - 1;

SELECT *
FROM te_pre_breakout;

# Using python, I created a table, te_diff, that contains the % difference in the averages of the columns of breakout players vs general average

# I also want to analyze the impact of team changes on breakout players
SELECT 
    COUNT(*) AS num_players_switched_teams
FROM 
    te_breakouts b
JOIN 
    te_adp a
ON 
    b.Player = a.Player
    AND a.year = b.year - 1
WHERE 
    b.Tm != a.Tm; 

SELECT 
    COUNT(*) AS num_players_switched_teams
FROM 
    te_breakouts b
JOIN 
    te_adp a
ON 
    b.Player = a.Player
    AND a.year = b.year - 1; # 3/14 (21%) breakout players switched teams

SELECT 
    SUM(num_switched) AS avg_players_switched
FROM (
    SELECT 
        COUNT(*) AS num_switched
    FROM 
        te_adp a1
    JOIN 
        te_adp a2
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
        te_adp a1
    JOIN 
        te_adp a2
    ON 
        a1.Player = a2.Player
        AND a1.year = a2.year - 1
    GROUP BY 
        a2.year
) AS yearly_switch_counts; # 8/41 (20%) players in general switched teams from one year to the next

# Surprsingly, break out players switched teams at roughly the same frequency as everyone else