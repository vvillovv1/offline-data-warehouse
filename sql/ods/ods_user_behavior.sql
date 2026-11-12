CREATE DATABASE IF NOT EXISTS ods;
USE ods;

DROP TABLE IF EXISTS ods_user_behavior;
CREATE TABLE ods_user_behavior (
    user_id     STRING COMMENT '用户ID',
    item_id     STRING COMMENT '商品ID',
    category_id STRING COMMENT '商品品类ID',
    behavior    STRING COMMENT '用户行为 pv/cart/fav/buy',
    ts          BIGINT COMMENT '行为时间戳(秒)'
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="0");
