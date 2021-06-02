-- 0. Code for creating tables

CREATE TABLE `all_country` (
`NAME` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
`points` decimal(10,2) NULL DEFAULT NULL,
`wins` int UNSIGNED NULL DEFAULT 0,
`draws` int UNSIGNED NULL DEFAULT NULL,
`losses` int UNSIGNED NULL DEFAULT NULL,
PRIMARY KEY (`NAME`)
)

CREATE TABLE `all_event` (
`ID` int NOT NULL AUTO_INCREMENT,
`date` date NULL DEFAULT NULL,
`home_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`away_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`home_score` int NULL DEFAULT NULL,
`away_score` int NULL DEFAULT NULL,
`tournament` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`importance` int NULL DEFAULT NULL,
`result` float NULL DEFAULT NULL,
`league_mark` tinyint(1) NULL DEFAULT 0,
PRIMARY KEY (`ID`)
)

CREATE TABLE `league_country` (
`NAME` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
`points` decimal(10,2) NULL DEFAULT NULL,
`wins` int UNSIGNED NULL DEFAULT 0,
`draws` int UNSIGNED NULL DEFAULT NULL,
`losses` int UNSIGNED NULL DEFAULT NULL,
PRIMARY KEY (`NAME`)
)

CREATE TABLE `std_fifa_ranking` (
`RNK` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`TEAM` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
`TOTAL_POINTS` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`PREVIOUS_POINTS` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
PRIMARY KEY (`TEAM`)
)

CREATE TABLE `std_uefa_ranking` (
`Pos` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`Country` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
`team_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`16/17` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`17/18` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`18/19` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`19/20` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`20/21` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
`Pts` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
PRIMARY KEY (`Country`)
)

CREATE TABLE `world_country` (
`NAME` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
`points` decimal(10,2) NULL DEFAULT NULL,
`wins` int UNSIGNED NULL DEFAULT 0,
`draws` int UNSIGNED NULL DEFAULT NULL,
`losses` int UNSIGNED NULL DEFAULT NULL,
PRIMARY KEY (`NAME`)
)


-- 1. Code for generating the statement for removing all the triggers

SELECT Concat('DROP TRIGGER ', Trigger_Name, ';')
FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = 'football';


-- 2. Code for rebuilding all the point tables

-- empty all_country, world_country, league_country

TRUNCATE all_country;
TRUNCATE world_country;
TRUNCATE league_country;

-- rebuild country datebase

INSERT INTO all_country(NAME,points,wins,draws,losses) SELECT DISTINCT home_name,1150,0,0,0 FROM all_event;
INSERT INTO all_country(NAME,points,wins,draws,losses) (SELECT DISTINCT away_name,1150,0,0,0 FROM all_event WHERE away_name not in (SELECT NAME FROM all_country));

INSERT INTO world_country(NAME,points,wins,draws,losses) SELECT DISTINCT home_name,1150,0,0,0 FROM (
    SELECT DISTINCT home_name FROM all_event WHERE league_mark=0) AS T;
INSERT INTO world_country(NAME,points,wins,draws,losses) (SELECT DISTINCT away_name,1150,0,0,0 FROM (
    SELECT DISTINCT away_name FROM all_event WHERE league_mark=0) AS T
WHERE away_name NOT IN (SELECT NAME FROM world_country));

INSERT INTO league_country(NAME,points,wins,draws,losses) SELECT DISTINCT home_name,1150,0,0,0 FROM (
    SELECT DISTINCT home_name FROM all_event WHERE league_mark=1) AS T;
INSERT INTO league_country(NAME,points,wins,draws,losses) (SELECT DISTINCT away_name,1150,0,0,0 FROM (
    SELECT DISTINCT away_name FROM all_event WHERE league_mark=1) AS T
WHERE away_name NOT IN (SELECT NAME FROM league_country));

-- Reload Pts data (Calculated by Triggers)

UPDATE all_event
SET id=id+0;


-- 3. Code for calculating how many rows

SELECT SUM(cnt)
FROM(
    SELECT COUNT(*) FROM `std_fifa_ranking`
    UNION ALL
    SELECT COUNT(*) FROM `std_uefa_ranking`
    UNION ALL
    SELECT COUNT(*) FROM  `all_country`
    UNION ALL
    SELECT COUNT(*) FROM `league_country`
    UNION ALL
    SELECT COUNT(*) FROM `world_country`
    UNION ALL
    SELECT COUNT(*) FROM `all_event`
) AS T(cnt);


-- 4. Code for correct the incorrect country names (connected with '-' not spaces):

UPDATE `all_event` SET `home_name`=REPLACE(`home_name`, '-', ' ');
UPDATE `all_event` SET `away_name`=REPLACE(`away_name`, '-', ' ');
