from typing import Tuple, List
from datetime import datetime, timedelta
from mockseries.trend import LinearTrend
from mockseries.seasonality import SinusoidalSeasonality
from mockseries.noise import RedNoise
from mockseries.utils import datetime_range
import pandas as pd
import numpy as np

def generate_time_series_data(grain:str='daily',
                            start_year:int=2021,
                            trend_coeff:float=0.1, 
                            trend_flat_base:int=100,
                            seasonality_daily_amp:int=5,
                            seasonality_weekly_amp:int=10,
                            seasonality_6mo_amp:int = 5,
                            seasonality_yearly_amp:int = 25,
                            noise_mean:int=0,
                            noise_std:int=3,
                            noise_corr:float=0.5) -> Tuple[List, np.ndarray]:
    """
    Generate a single mock time series with specified trend, seasonality, and noise. 
    """

    # Define trend
    trend = LinearTrend(coefficient=trend_coeff, time_unit=timedelta(days=4), flat_base=trend_flat_base)

    # Define random noise
    noise = RedNoise(mean=noise_mean, std=noise_std, correlation=noise_corr)

    # Define seasonality
    seasonality = SinusoidalSeasonality(amplitude=seasonality_6mo_amp, period=timedelta(days=182.5)) \
        + SinusoidalSeasonality(amplitude=seasonality_yearly_amp, period=timedelta(days=365))

    # Depending on the desired granularity, establish a time delta for time_points and adjust the seasonality
    if grain[0].lower() == 'w':
        granularity_time_delta = timedelta(weeks=1)
    elif grain[0].lower() == 'h':
        granularity_time_delta = timedelta(hours=1) 
        seasonality = seasonality + SinusoidalSeasonality(amplitude=seasonality_weekly_amp, period=timedelta(days=7.0)) \
            + SinusoidalSeasonality(amplitude=seasonality_daily_amp, period=timedelta(days=1.0))
    else: # case when grain[0].lower() == 'd'
        granularity_time_delta = timedelta(days=1)  
        seasonality = seasonality + SinusoidalSeasonality(amplitude=seasonality_weekly_amp, period=timedelta(days=7.0))

    timeseries = trend + seasonality + noise

    time_points = datetime_range(
        granularity=granularity_time_delta,
        start_time=datetime(start_year, 1, 1),
        end_time=datetime.today(),
    )
    ts_values = timeseries.generate(time_points=time_points)

    return time_points, ts_values


def create_dataframe(time_points:list, ts_values:np.ndarray) -> pd.DataFrame:
    """
    Create a pandas DataFrame from the list and numpy array that come from the generate_time_series_data function. 
    This dataframe will represent a single time series.
    """
    df_single_partition = pd.DataFrame({"ORDER_TIMESTAMP":time_points,"TARGET":ts_values})
    return df_single_partition