CREATE DATABASE IF NOT EXISTS dwd;
USE dwd;

DROP TABLE IF EXISTS dwd_user_behavior_detail;
CREATE TABLE dwd_user_behavior_detail (
    user_id     STRING COMMENT '用户ID',
    item_id     STRING COMMENT '商品ID',
    category_id STRING COMMENT '商品品类ID',
    behavior    STRING COMMENT '行为 pv/cart/fav/buy',
    ts          BIGINT COMMENT '原始时间戳',
    dt          STRING COMMENT '日期 yyyy-MM-dd',
    hour        STRING COMMENT '小时 HH'
)
PARTITIONED BY (dt)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS ORC
TBLPROPERTIES ("orc.compress"="snappy");

-- 清洗插入逻辑
INSERT OVERWRITE TABLE dwd.dwd_user_behavior_detail
PARTITION(dt)
SELECT
    user_id,
    item_id,
    category_id,
    behavior,
    ts,
    date_format(from_utc_timestamp(ts,'GMT+8'),'yyyy-MM-dd') AS dt,
    date_format(from_utc_timestamp(ts,'GMT+8'),'HH') AS hour,
    date_format(from_utc_timestamp(ts,'GMT+8'),'yyyy-MM-dd') AS dt
FROM ods.ods_user_behavior
WHERE
    -- 只保留合法行为
    behavior IN ('pv','cart','fav','buy')
    -- 过滤时间异常，业务区间：2017-11-25 至 2017-12-03
    AND ts >= 1511510400 AND ts <= 1512273599
    AND user_id IS NOT NULL
    AND item_id IS NOT NULL;
