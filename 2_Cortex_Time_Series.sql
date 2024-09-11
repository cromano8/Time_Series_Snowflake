-- Only 10 stores to test 
CREATE OR REPLACE table STORE_TRAFFIC.TIME_SERIES.TRAIN AS SELECT STORE_ID, DATE::TIMESTAMP_NTZ AS DATE, TRAFFIC
  FROM STORE_TRAFFIC.TIME_SERIES.traffic
  where Date <= current_date()-15
  and store_id < 11;

CREATE or replace SNOWFLAKE.ML.FORECAST multi_model_univariate(INPUT_DATA => SYSTEM$REFERENCE('TABLE', 'train'),
                                    SERIES_COLNAME => 'STORE_ID',
                                    TIMESTAMP_COLNAME => 'DATE',
                                    TARGET_COLNAME => 'TRAFFIC'
                                   );

CALL multi_model_univariate!FORECAST(FORECASTING_PERIODS => 28);
                                   
create or replace table cortex_forecast as
SELECT series as store_id, ts::date as date, forecast, lower_bound, upper_bound
  FROM TABLE(RESULT_SCAN(-1));

select * from cortex_forecast;

-- Create final table with actuals and forecast
create or replace table cortex_actual_vs_forecast as
select a.date as date, a.store_id, forecast, traffic as actual
from cortex_forecast a
left join traffic b
on a.store_id = b.store_id
and a.date = b.date;

-- view it for one store in Snowsight
select * from cortex_actual_vs_forecast
where store_id = 1;