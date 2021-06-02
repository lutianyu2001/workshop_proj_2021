-- 涉及 all_country 表的触发器

-- I 计算 pts

--    1  insert

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `points_insert_all_country`;
delimiter ;;
CREATE TRIGGER `points_insert_all_country` BEFORE INSERT ON `all_event` FOR EACH ROW BEGIN
DECLARE away_points,home_points,we_1,we_2,dr FLOAT;
SELECT points INTO away_points FROM all_country WHERE NAME=new.away_name;
SELECT points INTO home_points FROM all_country WHERE NAME=new.home_name;
SET dr=(home_points-away_points)/600;
SET we_1=1/(1+power(10,-dr));
SET we_2=1/(1+power(10,dr));
UPDATE all_country t1
SET t1.points=t1.points+new.importance*(new.result-we_1) WHERE t1.NAME=new.home_name;
UPDATE all_country t1
SET t1.points=t1.points+new.importance*((1-new.result)-we_2) WHERE t1.NAME=new.away_name;
END
;;
delimiter ;


--    2  delete

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `points_delete_all_country`;
delimiter ;;
CREATE TRIGGER `points_delete_all_country` BEFORE DELETE ON `all_event` FOR EACH ROW BEGIN
DECLARE away_points,home_points,we_1,we_2,dr FLOAT;
SELECT points INTO away_points FROM all_country WHERE NAME=old.away_name;
SELECT points INTO home_points FROM all_country WHERE NAME=old.home_name;
SET dr=(home_points-away_points)/600;
SET we_1=1/(1+power(10,-dr));
SET we_2=1/(1+power(10,dr));
UPDATE all_country t1
SET t1.points=t1.points-old.importance*(old.result-we_1) WHERE t1.NAME=old.home_name;
UPDATE all_country t1
SET t1.points=t1.points-old.importance*((1-old.result)-we_2) WHERE t1.NAME=old.away_name;
END
;;
delimiter ;


--    3  update 并非真的用于update, 而是为了方便我们更新数据库
-- 配合 重置积分数据库代码 使用

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `points_update_all_country`;
delimiter ;;
CREATE TRIGGER `points_update_all_country` BEFORE UPDATE ON `all_event` FOR EACH ROW BEGIN
DECLARE away_points,home_points,we_1,we_2,dr FLOAT;
SELECT points INTO away_points FROM all_country WHERE NAME=new.away_name;
SELECT points INTO home_points FROM all_country WHERE NAME=new.home_name;
SET dr=(home_points-away_points)/600;
SET we_1=1/(1+power(10,-dr));
SET we_2=1/(1+power(10,dr));
UPDATE all_country t1
SET t1.points=t1.points+new.importance*(new.result-we_1) WHERE t1.NAME=new.home_name;
UPDATE all_country t1
SET t1.points=t1.points+new.importance*((1-new.result)-we_2) WHERE t1.NAME=new.away_name;
END
;;
delimiter ;



-- II 更新 cnt

--    1  insert (3个)

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_wins_insert_all_country`;
delimiter ;;
CREATE TRIGGER `count_wins_insert_all_country` AFTER INSERT ON `all_event` FOR EACH ROW BEGIN
UPDATE all_country t1
SET t1.wins=t1.wins+1 WHERE (t1.NAME=new.home_name and new.result=1) or (t1.NAME=new.away_name and new.result=0) ;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_draws_insert_all_country`;
delimiter ;;
CREATE TRIGGER `count_draws_insert_all_country` AFTER INSERT ON `all_event` FOR EACH ROW BEGIN
UPDATE all_country t1
SET t1.draws=t1.draws+1 WHERE (t1.NAME=new.home_name and new.result=0.5) or (t1.NAME=new.away_name and new.result=0.5) ;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_losses_insert_all_country`;
delimiter ;;
CREATE TRIGGER `count_losses_insert_all_country` AFTER INSERT ON `all_event` FOR EACH ROW BEGIN
UPDATE all_country t1
SET t1.losses=t1.losses+1 WHERE (t1.NAME=new.home_name and new.result=0) or (t1.NAME=new.away_name and new.result=1) ;
END
;;
delimiter ;


--    2  delete (3个)

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_wins_delete_all_country`;
delimiter ;;
CREATE TRIGGER `count_wins_delete_all_country` AFTER DELETE ON `all_event` FOR EACH ROW BEGIN
UPDATE all_country t1
SET t1.wins=t1.wins-1 WHERE (t1.NAME=old.home_name and old.result=1) or (t1.NAME=old.away_name and old.result=0) ;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_draws_delete_all_country`;
delimiter ;;
CREATE TRIGGER `count_draws_delete_all_country` AFTER DELETE ON `all_event` FOR EACH ROW BEGIN
UPDATE all_country t1
SET t1.draws=t1.draws-1 WHERE (t1.NAME=old.home_name and old.result=0.5) or (t1.NAME=old.away_name and old.result=0.5) ;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_losses_delete_all_country`;
delimiter ;;
CREATE TRIGGER `count_losses_delete_all_country` AFTER DELETE ON `all_event` FOR EACH ROW BEGIN
UPDATE all_country t1
SET t1.losses=t1.losses-1 WHERE (t1.NAME=old.home_name and old.result=0) or (t1.NAME=old.away_name and old.result=1) ;
END
;;
delimiter ;


--    3  update 并非真的用于update, 而是为了方便我们更新数据库
-- 配合 重置积分数据库代码 使用

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_wins_update_all_country`;
delimiter ;;
CREATE TRIGGER `count_wins_update_all_country` AFTER UPDATE ON `all_event` FOR EACH ROW BEGIN
UPDATE all_country t1
SET t1.wins=t1.wins+1 WHERE (t1.NAME=new.home_name and new.result=1) or (t1.NAME=new.away_name and new.result=0) ;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_draws_update_all_country`;
delimiter ;;
CREATE TRIGGER `count_draws_update_all_country` AFTER UPDATE ON `all_event` FOR EACH ROW BEGIN
UPDATE all_country t1
SET t1.draws=t1.draws+1 WHERE (t1.NAME=new.home_name and new.result=0.5) or (t1.NAME=new.away_name and new.result=0.5) ;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `count_losses_update_all_country`;
delimiter ;;
CREATE TRIGGER `count_losses_update_all_country` AFTER UPDATE ON `all_event` FOR EACH ROW BEGIN
UPDATE all_country t1
SET t1.losses=t1.losses+1 WHERE (t1.NAME=new.home_name and new.result=0) or (t1.NAME=new.away_name and new.result=1) ;
END
;;
delimiter ;

