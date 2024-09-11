# Time_Series_Snowflake
Multiple ways to perform time series analysis in Snowflake

## Configuration Setup

1. Create a `.env` file and populate it with your account details, or use SnowCLI to store credentials :

    ```plaintext
    SNOWFLAKE_ACCOUNT = abc123.us-east-1
    SNOWFLAKE_USER = username
    SNOWFLAKE_PASSWORD = yourpassword
    SNOWFLAKE_ROLE = sysadmin
    SNOWFLAKE_WAREHOUSE = compute_wh
    SNOWFLAKE_DATABASE = snowpark
    SNOWFLAKE_SCHEMA = titanic
    ```

2. Utilize the `environment.yml` file to set up your Python environment for the demo:
    - Examples in the terminal:
        - `conda env create -f environment.yml`
        - `micromamba create -f environment.yml -y`
     
## Creating Fake Data

Run the first notebook to create fake data.  Throughout this notebook you can change the seasonality, trend, add features and how much they impact the target.  You can also choose how many partitions and how far back the data goes.

## AutoML in Snowflake

Use Snowflake Cortex to run AutoML Time Series.

## UDTF

UDTF's give users to run custom models extremely fast by distributing the individual models across snowflake compute.
