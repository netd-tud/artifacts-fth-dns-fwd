from pathlib import Path

import polars as pl
import pandas as pd
from datetime import datetime

def unique_and_resample(df: pl.LazyFrame, subset, keep='first',every='1d',index_column='Timestamp',origin='start'):
    tmp = df.unique(subset=subset, keep=keep).sort(index_column).collect()
    return tmp.group_by_dynamic(index_column=index_column,every=every).agg(pl.count(subset).alias('count')).sort(index_column).with_columns((pl.col('count').cum_sum() / tmp.height).alias(subset))

def concat_frames(dfs: list[pl.LazyFrame], labels: list[str], column: str,columns: list[str]) -> pl.LazyFrame:
    if len(dfs) != len(labels):
        raise ValueError("The number of DataFrames must match the number of labels.")

    enriched_dfs = [
        df.select(columns).with_columns(pl.lit(label).alias(column))
        for df, label in zip(dfs, labels)
    ]

    return pl.concat(enriched_dfs, how="vertical")