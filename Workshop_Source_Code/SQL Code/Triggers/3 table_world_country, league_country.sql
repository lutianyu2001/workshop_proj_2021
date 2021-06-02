-- 涉及 world_country, league_country 表的触发器

-- I 计算 pts

--    1  insert

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `points_insert_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `points_insert_world_and_league_country` BEFORE INSERT ON `all_event` FOR EACH ROW BEGIN
DECLARE away_points,home_points,we_1,we_2,dr FLOAT;
IF new.league_mark=0 THEN BEGIN
    SELECT points INTO away_points FROM world_country WHERE NAME=new.away_name;
    SELECT points INTO home_points FROM world_country WHERE NAME=new.home_name;
END; ELSE BEGIN
    SELECT points INTO away_points FROM league_country WHERE NAME=new.away_name;
    SELECT points INTO home_points FROM league_country WHERE NAME=new.home_name;
END; END IF;
SET dr=(home_points-away_points)/600;
SET we_1=1/(1+power(10,-dr));
SET we_2=1/(1+power(10,dr));
IF new.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.points=t1.points+new.importance*(new.result-we_1) WHERE t1.NAME=new.home_name;
    UPDATE world_country t1
    SET t1.points=t1.points+new.importance*((1-new.result)-we_2) WHERE t1.NAME=new.away_name;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.points=t1.points+new.importance*(new.result-we_1) WHERE t1.NAME=new.home_name;
    UPDATE league_country t1
    SET t1.points=t1.points+new.importance*((1-new.result)-we_2) WHERE t1.NAME=new.away_name;
END; END IF;
END
;;
delimiter ;


--    2  delete

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `points_delete_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `points_delete_world_and_league_country` BEFORE DELETE ON `all_event` FOR EACH ROW BEGIN
DECLARE away_points,home_points,we_1,we_2,dr FLOAT;
IF old.league_mark=0 THEN BEGIN
    SELECT points INTO away_points FROM world_country WHERE NAME=old.away_name;
    SELECT points INTO home_points FROM world_country WHERE NAME=old.home_name;
END; ELSE BEGIN
    SELECT points INTO away_points FROM league_country WHERE NAME=old.away_name;
    SELECT points INTO home_points FROM league_country WHERE NAME=old.home_name;
END; END IF;
SET dr=(home_points-away_points)/600;
SET we_1=1/(1+power(10,-dr));
SET we_2=1/(1+power(10,dr));
IF old.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.points=t1.points-old.importance*(old.result-we_1) WHERE t1.NAME=old.home_name;
    UPDATE world_country t1
    SET t1.points=t1.points-old.importance*((1-old.result)-we_2) WHERE t1.NAME=old.away_name;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.points=t1.points-old.importance*(old.result-we_1) WHERE t1.NAME=old.home_name;
    UPDATE league_country t1
    SET t1.points=t1.points-old.importance*((1-old.result)-we_2) WHERE t1.NAME=old.away_name;
END; END IF;
END
;;
delimiter ;


--    3  update 并非真的用于update, 而是为了方便我们更新数据库
-- 配合 重置积分数据库代码 使用

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `points_update_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `points_update_world_and_league_country` BEFORE UPDATE ON `all_event` FOR EACH ROW BEGIN
DECLARE away_points,home_points,we_1,we_2,dr FLOAT;
IF new.league_mark=0 THEN BEGIN
    SELECT points INTO away_points FROM world_country WHERE NAME=new.away_name;
    SELECT points INTO home_points FROM world_country WHERE NAME=new.home_name;
END; ELSE BEGIN
    SELECT points INTO away_points FROM league_country WHERE NAME=new.away_name;
    SELECT points INTO home_points FROM league_country WHERE NAME=new.home_name;
END; END IF;
SET dr=(home_points-away_points)/600;
SET we_1=1/(1+power(10,-dr));
SET we_2=1/(1+power(10,dr));
IF new.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.points=t1.points+new.importance*(new.result-we_1) WHERE t1.NAME=new.home_name;
    UPDATE world_country t1
    SET t1.points=t1.points+new.importance*((1-new.result)-we_2) WHERE t1.NAME=new.away_name;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.points=t1.points+new.importance*(new.result-we_1) WHERE t1.NAME=new.home_name;
    UPDATE league_country t1
    SET t1.points=t1.points+new.importance*((1-new.result)-we_2) WHERE t1.NAME=new.away_name;
END; END IF;
END
;;
delimiter ;



-- II 更新 cnt

--    1  insert (3个)

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_wins_insert_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `count_wins_insert_world_and_league_country` AFTER INSERT ON `all_event` FOR EACH ROW BEGIN
IF new.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.wins=t1.wins+1 WHERE (t1.NAME=new.home_name and new.result=1) or (t1.NAME=new.away_name and new.result=0) ;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.wins=t1.wins+1 WHERE (t1.NAME=new.home_name and new.result=1) or (t1.NAME=new.away_name and new.result=0) ;
END; END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_draws_insert_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `count_draws_insert_world_and_league_country` AFTER INSERT ON `all_event` FOR EACH ROW BEGIN
IF new.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.draws=t1.draws+1 WHERE (t1.NAME=new.home_name and new.result=0.5) or (t1.NAME=new.away_name and new.result=0.5) ;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.draws=t1.draws+1 WHERE (t1.NAME=new.home_name and new.result=0.5) or (t1.NAME=new.away_name and new.result=0.5) ;
END; END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_losses_insert_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `count_losses_insert_world_and_league_country` AFTER INSERT ON `all_event` FOR EACH ROW BEGIN
IF new.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.losses=t1.losses+1 WHERE (t1.NAME=new.home_name and new.result=0) or (t1.NAME=new.away_name and new.result=1) ;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.losses=t1.losses+1 WHERE (t1.NAME=new.home_name and new.result=0) or (t1.NAME=new.away_name and new.result=1) ;
END; END IF;
END
;;
delimiter ;


--    2  delete (3个)

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_wins_delete_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `count_wins_delete_world_and_league_country` AFTER DELETE ON `all_event` FOR EACH ROW BEGIN
IF old.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.wins=t1.wins-1 WHERE (t1.NAME=old.home_name and old.result=1) or (t1.NAME=old.away_name and old.result=0) ;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.wins=t1.wins-1 WHERE (t1.NAME=old.home_name and old.result=1) or (t1.NAME=old.away_name and old.result=0) ;
END; END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_draws_delete_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `count_draws_delete_world_and_league_country` AFTER DELETE ON `all_event` FOR EACH ROW BEGIN
IF old.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.draws=t1.draws-1 WHERE (t1.NAME=old.home_name and old.result=0.5) or (t1.NAME=old.away_name and old.result=0.5) ;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.draws=t1.draws-1 WHERE (t1.NAME=old.home_name and old.result=0.5) or (t1.NAME=old.away_name and old.result=0.5) ;
END; END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_losses_delete_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `count_losses_delete_world_and_league_country` AFTER DELETE ON `all_event` FOR EACH ROW BEGIN
IF old.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.losses=t1.losses-1 WHERE (t1.NAME=old.home_name and old.result=0) or (t1.NAME=old.away_name and old.result=1) ;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.losses=t1.losses-1 WHERE (t1.NAME=old.home_name and old.result=0) or (t1.NAME=old.away_name and old.result=1) ;
END; END IF;
END
;;
delimiter ;


--    3  update 并非真的用于update, 而是为了方便我们更新数据库
-- 配合 重置积分数据库代码 使用

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_wins_update_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `count_wins_update_world_and_league_country` AFTER UPDATE ON `all_event` FOR EACH ROW BEGIN
IF new.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.wins=t1.wins+1 WHERE (t1.NAME=new.home_name and new.result=1) or (t1.NAME=new.away_name and new.result=0) ;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.wins=t1.wins+1 WHERE (t1.NAME=new.home_name and new.result=1) or (t1.NAME=new.away_name and new.result=0) ;
END; END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_draws_update_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `count_draws_update_world_and_league_country` AFTER UPDATE ON `all_event` FOR EACH ROW BEGIN
IF new.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.draws=t1.draws+1 WHERE (t1.NAME=new.home_name and new.result=0.5) or (t1.NAME=new.away_name and new.result=0.5) ;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.draws=t1.draws+1 WHERE (t1.NAME=new.home_name and new.result=0.5) or (t1.NAME=new.away_name and new.result=0.5) ;
END; END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_losses_update_world_and_league_country`;
delimiter ;;
CREATE TRIGGER `count_losses_update_world_and_league_country` AFTER UPDATE ON `all_event` FOR EACH ROW BEGIN
IF new.league_mark=0 THEN BEGIN
    UPDATE world_country t1
    SET t1.losses=t1.losses+1 WHERE (t1.NAME=new.home_name and new.result=0) or (t1.NAME=new.away_name and new.result=1) ;
END; ELSE BEGIN
    UPDATE league_country t1
    SET t1.losses=t1.losses+1 WHERE (t1.NAME=new.home_name and new.result=0) or (t1.NAME=new.away_name and new.result=1) ;
END; END IF;
END
;;
delimiter ;


