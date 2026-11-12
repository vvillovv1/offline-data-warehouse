DROP TABLE IF EXISTS dws_item_behavior_day;
CREATE TABLE dws_item_behavior_day (
    item_id      STRING,
    category_id  STRING,
    pv_cnt       BIGINT,
    cart_cnt     BIGINT,
    fav_cnt      BIGINT,
    buy_cnt      BIGINT
)
PARTITIONED BY (dt)
STORED AS ORC;

INSERT OVERWRITE TABLE dws.dws_item_behavior_day
PARTITION(dt)
SELECT
    item_id,
    category_id,
    SUM(IF(behavior='pv',1,0)) AS pv_cnt,
    SUM(IF(behavior='cart',1,0)) AS cart_cnt,
    SUM(IF(behavior='fav',1,0)) AS fav_cnt,
    SUM(IF(behavior='buy',1,0)) AS buy_cnt,
    dt
FROM dwd.dwd_user_behavior_detail
GROUP BY dt, item_id, category_id;
