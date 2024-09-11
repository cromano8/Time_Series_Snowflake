select * from MOCKSERIES.DAILY_TS_5000_PARTITIONS_STARTING_2021
order by order_timestamp desc;


CREATE OR REPLACE table train AS 
SELECT STORE_ID, feature_1, feature_2, ORDER_TIMESTAMP::TIMESTAMP_NTZ AS DATE, TARGET
  FROM CROMANO.MOCKSERIES.DAILY_TS_5000_PARTITIONS_STARTING_2021
  where Date <= current_date()-15
  and store_id < 5;

select * from train
order by date desc;  

CREATE or replace SNOWFLAKE.ML.FORECAST store_forecast(INPUT_DATA => SYSTEM$REFERENCE('TABLE', 'train'),
                                SERIES_COLNAME => 'STORE_ID',
                                TIMESTAMP_COLNAME => 'DATE',
                                TARGET_COLNAME => 'TARGET'
                               );

CREATE OR REPLACE table test AS 
SELECT STORE_ID, feature_1, feature_2, ORDER_TIMESTAMP::TIMESTAMP_NTZ AS DATE, TARGET
  FROM CROMANO.MOCKSERIES.DAILY_TS_5000_PARTITIONS_STARTING_2021
  where Date > current_date()-15
  and store_id < 5;
           
CALL store_forecast!FORECAST(input_data => TABLE(test),SERIES_COLNAME => 'STORE_ID',TIMESTAMP_COLNAME=> 'date');

CALL store_forecast!show_evaluation_metrics();

CALL store_forecast!EXPLAIN_FEATURE_IMPORTANCE();
