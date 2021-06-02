-- 仅限 event 表的触发器
-- 计算 result 和 importance

--    1  两个 insert

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `result_insert_event`;
delimiter ;;
CREATE TRIGGER `result_insert_event` BEFORE INSERT ON `all_event` FOR EACH ROW BEGIN
DECLARE goal_diff INT;
SET goal_diff=new.home_score-new.away_score;
#1 means win, 0.5 means draw, 0 means loss(for home team)
IF goal_diff>0 THEN SET new.result=1;
ELSEIF goal_diff=0 THEN SET new.result=0.5;
ELSE SET new.result=0;
END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------

DROP TRIGGER IF EXISTS `importance_insert_event`;
delimiter ;;
CREATE TRIGGER `importance_insert_event` BEFORE INSERT ON `all_event` FOR EACH ROW BEGIN
IF new.tournament="FIFA World Cup" THEN SET new.importance=60;
ELSEIF new.tournament="UEFA CL" THEN SET new.importance=60;
ELSEIF new.tournament="UEFA Euro championship" THEN SET new.importance=50;
ELSEIF new.tournament="UEFA EL" THEN SET new.importance=40;
ELSEIF new.tournament="FIFA World Cup qualification" THEN SET new.importance=40;
ELSEIF new.tournament="UEFA Euro qualification" THEN SET new.importance=30;
ELSEIF new.tournament="UEFA SC" THEN SET new.importance=30;
ELSEIF new.tournament LIKE "AFC%" THEN SET new.importance=10;
ELSEIF new.tournament LIKE "OFC%" THEN SET new.importance=10;
ELSEIF new.tournament="Friendly" THEN SET new.importance=10;
ELSE SET new.importance=20;
END IF;
END
;;
delimiter ;


--    2  两个 update 并非真的用于update, 而是为了方便我们更新数据库
-- 配合 重置积分数据库代码 使用

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------
DROP TRIGGER IF EXISTS `result_update_event`;
delimiter ;;
CREATE TRIGGER `result_update_event` BEFORE UPDATE ON `all_event` FOR EACH ROW BEGIN
DECLARE goal_diff INT;
SET goal_diff=new.home_score-new.away_score;
#1 means win, 0.5 means draw, 0 means loss(for home team)
IF goal_diff>0 THEN SET new.result=1;
ELSEIF goal_diff=0 THEN SET new.result=0.5;
ELSE SET new.result=0;
END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table event
-- ----------------------------

DROP TRIGGER IF EXISTS `importance_update_event`;
delimiter ;;
CREATE TRIGGER `importance_update_event` BEFORE UPDATE ON `all_event` FOR EACH ROW BEGIN
IF new.tournament="FIFA World Cup" THEN SET new.importance=60;
ELSEIF new.tournament="UEFA CL" THEN SET new.importance=60;
ELSEIF new.tournament="UEFA Euro championship" THEN SET new.importance=50;
ELSEIF new.tournament="UEFA EL" THEN SET new.importance=40;
ELSEIF new.tournament="FIFA World Cup qualification" THEN SET new.importance=40;
ELSEIF new.tournament="UEFA Euro qualification" THEN SET new.importance=30;
ELSEIF new.tournament="UEFA SC" THEN SET new.importance=30;
ELSEIF new.tournament LIKE "AFC%" THEN SET new.importance=10;
ELSEIF new.tournament LIKE "OFC%" THEN SET new.importance=10;
ELSEIF new.tournament="Friendly" THEN SET new.importance=10;
ELSE SET new.importance=20;
END IF;
END
;;
delimiter ;

-- -------------------------------------------------------------------------------------------------------------------------
