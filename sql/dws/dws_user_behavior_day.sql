CREATE DATABASE IF NOT EXISTS dws;
USE dws;

DROP TABLE IF EXISTS dws_user_behavior_day;
CREATE TABLE dws_user_behavior_day (
    user_id      STRING,
    pv_cnt       BIGINT COMMENT '浏览次数',
    cart_cnt     BIGINT COMMENT '加购次数',
    fav_cnt      BIGINT COMMENT '收藏次数',
    buy_cnt      BIGINT COMMENT '下单次数'
)
PARTITIONED BY (dt)
STORED AS ORC;

INSERT OVERWRITE TABLE dws.dws_user_behavior_day
PARTITION(dt)
SELECT
    user_id,
    SUM(IF(behavior='pv',1,0)) AS pv_cnt,
    SUM(IF(behavior='cart',1,0)) AS cart_cnt,
    SUM(IF(behavior='fav',1,0)) AS fav_cnt,
    SUM(IF(behavior='buy',1,0)) AS buy_cnt,
    dt
FROM dwd.dwd_user_behavior_detail
GROUP BY dt, user_id;
