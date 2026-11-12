CREATE DATABASE IF NOT EXISTS ads;
USE ads;

-- 每日核心指标报表：日UV、PV、加购数、收藏数、下单数、加购转化率、下单转化率
DROP TABLE IF EXISTS ads_daily_summary;
CREATE TABLE ads_daily_summary (
    dt                STRING COMMENT '日期',
    uv                BIGINT COMMENT '独立用户数',
    pv                BIGINT COMMENT '浏览总量',
    cart_total        BIGINT COMMENT '加购总量',
    fav_total         BIGINT COMMENT '收藏总量',
    buy_total         BIGINT COMMENT '下单总量',
    pv_to_cart_rate   DECIMAL(6,4) COMMENT '浏览-加购转化率',
    pv_to_buy_rate    DECIMAL(6,4) COMMENT '浏览-下单转化率'
)
STORED AS ORC;

INSERT OVERWRITE TABLE ads.ads_daily_summary
SELECT
    dt,
    COUNT(DISTINCT user_id) AS uv,
    SUM(IF(behavior='pv',1,0)) AS pv,
    SUM(IF(behavior='cart',1,0)) AS cart_total,
    SUM(IF(behavior='fav',1,0)) AS fav_total,
    SUM(IF(behavior='buy',1,0)) AS buy_total,
    -- 转化率
    ROUND(SUM(IF(behavior='cart',1,0)) / SUM(IF(behavior='pv',1,0)),4) AS pv_to_cart_rate,
    ROUND(SUM(IF(behavior='buy',1,0)) / SUM(IF(behavior='pv',1,0)),4) AS pv_to_buy_rate
FROM dwd.dwd_user_behavior_detail
GROUP BY dt;
