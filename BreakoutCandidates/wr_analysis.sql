-- WR Analysis --
CREATE TABLE wr_adp
LIKE adv_rec_all;

INSERT INTO wr_adp
SELECT *
FROM adv_rec_all;

ALTER TABLE wr_adp
ADD COLUMN ADP FLOAT;

ALTER TABLE wr_adp
ADD COLUMN PPR_PTS FLOAT;

UPDATE wr_adp r
JOIN adp_all a ON r.Player = a.Player AND r.year = a.year
SET r.ADP = a.AVG;

UPDATE wr_adp r
JOIN fantasy_all f ON r.Player = f.Player AND r.year = f.year
SET r.PPR_PTS = f.PPR;

SELECT *
FROM wr_adp
WHERE ADP IS NULL
ORDER BY PPR_PTS DESC; # Certain players have a NULL ADP, the most note-wrothy of which is Myles Gaskin. Pretty much, all of these players were undrafted.

UPDATE wr_adp
SET ADP = 999
WHERE ADP IS NULL; # ADP of 999 essentially indicates that a player most likely went undrafted.

SELECT *
FROM wr_adp
WHERE PPR_PTS IS NULL
ORDER BY ADP ASC; # The highest drafted player with NULL PPR_PPTS is Pharoh Cooper whose ADP is 112. These guys don't impact the results and can be removed for simplicity.

DELETE FROM wr_adp
WHERE PPR_PTS IS NULL;

DELETE FROM wr_adp
WHERE rec_Pos != 'WR';

SELECT *
FROM wr_adp;

ALTER TABLE wr_adp 
ADD COLUMN rank_total_ppr_points INT,
ADD COLUMN rank_adp INT;

# Rank players by total PPR points and ADP for each year
UPDATE wr_adp t1
JOIN (
    SELECT Player, year, PPR_PTS,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY PPR_PTS DESC) AS rank_total_ppr_points
    FROM wr_adp
) t2 ON t1.Player = t2.Player AND t1.year = t2.year
SET t1.rank_total_ppr_points = t2.rank_total_ppr_points;

UPDATE wr_adp t1
JOIN (
    SELECT Player, year, ADP,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY ADP ASC) AS rank_adp
    FROM wr_adp
) t2 ON t1.Player = t2.Player AND t1.year = t2.year
SET t1.rank_adp = t2.rank_adp;

# Creating a 'break out score' to measure if a player had a break out year (if total points greatly exceeds adp)
ALTER TABLE wr_adp 
ADD COLUMN breakout_score INT;

UPDATE wr_adp
SET breakout_score = rank_adp - rank_total_ppr_points;

SELECT *
FROM wr_adp
ORDER BY breakout_score DESC;

CREATE TABLE wr_breakouts 
LIKE wr_adp;

SET @total_rows = 0;
SET @rank = 0; # Trying to find a good threshold for breakouts
SELECT @total_rows := COUNT(*), @rank := CEIL(COUNT(*) * 0.65)
FROM wr_adp; # 1172 - 762 = 410; top 35% is the top 410 players
SELECT *
FROM wr_adp
ORDER BY breakout_score DESC
LIMIT 410; # 65th percentile of breakout score is 12

INSERT INTO wr_breakouts
SELECT *
FROM wr_adp
WHERE breakout_score > 11; # Removing names with a break out score of less than 15 (isolates the top % of breakouts)

SELECT *
FROM wr_breakouts;

# Now that I have a list of which players had breakout years, I will check their stats from the previous year to see if there's any indicators.
CREATE TABLE wr_pre_breakout
LIKE wr_breakouts;

INSERT INTO wr_pre_breakout
SELECT a.*
FROM wr_adp a
JOIN wr_breakouts b
ON a.Player = b.Player 
AND a.year = b.year - 1;

SELECT *
FROM wr_adp 
WHERE Player like 'Amon%';

# Using python, I created a table, wr_diff, that contains the % difference in the averages of the columns of breakout players vs general average

# I also want to analyze the impact of team changes on breakout players
SELECT 
    COUNT(*) AS num_players_switched_teams
FROM 
    wr_breakouts b
JOIN 
    wr_adp a
ON 
    b.Player = a.Player
    AND a.year = b.year - 1
WHERE 
    b.Tm != a.Tm; 

SELECT 
    COUNT(*) AS num_players_switched_teams
FROM 
    wr_breakouts b
JOIN 
    wr_adp a
ON 
    b.Player = a.Player
    AND a.year = b.year - 1; # 36/117 (31%) breakout players switched teams

SELECT 
    SUM(num_switched) AS avg_players_switched
FROM (
    SELECT 
        COUNT(*) AS num_switched
    FROM 
        wr_adp a1
    JOIN 
        wr_adp a2
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
        wr_adp a1
    JOIN 
        wr_adp a2
    ON 
        a1.Player = a2.Player
        AND a1.year = a2.year - 1
    GROUP BY 
        a2.year
) AS yearly_switch_counts; # 199/694 (29%) players in general switched teams from one year to the next

# Surprsingly, break out players switched teams at roughly the same frequency as everyone else