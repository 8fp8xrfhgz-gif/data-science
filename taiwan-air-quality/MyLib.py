"""
MyLib.py

Reconstructed for the Programming for Geographic Data Science final exam
(NTU Geography, Prof. Wen, Spring 2023).

The original MyLib.py containing this class was lost / not saved. This
version was rewritten from scratch based on:
  - The exam question specifications (Q1-Q3)
  - The actual schema of airquality.db (table: airdata, columns:
    site, date, item, value)
  - The actual schema of data_0528_utf8.csv (columns: sitename, county,
    aqi, status, co, pm10, no2, longitude, latitude, siteid)

It intentionally avoids a bug present in the original submission, where
AlertMap's `return` statement was indented inside the plotting loop,
causing the map to be rebuilt and returned after only the first station
instead of after all stations were plotted.
"""

import sqlite3
import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt


class AirObj:
    def __init__(self, db_path='airquality.db'):
        self.db_connection = sqlite3.connect(db_path)

    def ViewData(self, stat='mean'):
        """
        Returns a station x item cross-tab table.
        stat: 'mean', 'max', or 'min' — aggregated over 2023/5/1-5/28.
        """
        df = pd.read_sql_query(
            "SELECT site, item, value FROM airdata", self.db_connection
        )
        df['value'] = pd.to_numeric(df['value'], errors='coerce')

        agg_map = {'mean': 'mean', 'max': 'max', 'min': 'min'}
        if stat not in agg_map:
            raise ValueError("stat must be one of 'mean', 'max', 'min'")

        table = df.pivot_table(
            index='site', columns='item', values='value', aggfunc=agg_map[stat]
        )
        return table

    def Chart(self, item, site1, site2):
        """
        Plots a time-series comparison of `item` (CO/NO2/PM10) between
        two stations, site1 and site2.
        """
        df = pd.read_sql_query(
            "SELECT site, date, value FROM airdata WHERE item = ? AND site IN (?, ?)",
            self.db_connection,
            params=(item, site1, site2),
        )
        df['value'] = pd.to_numeric(df['value'], errors='coerce')
        df['date'] = pd.to_datetime(df['date'])
        df = df.sort_values('date')

        fig, ax = plt.subplots(figsize=(10, 5))
        for site_name, group in df.groupby('site'):
            ax.plot(group['date'], group['value'], marker='o', label=site_name)

        ax.set_title(f'{item} Trend Comparison: {site1} vs {site2}')
        ax.set_xlabel('Date')
        ax.set_ylabel(f'{item} Value')
        ax.legend(title='Station')
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.show()

    def AlertMap(self, item, threshold, county_shp='TaiwanCounty.shp',
                 data_csv='data_0528_utf8.csv'):
        """
        Plots a map of monitoring stations within Taipei City, flagging
        stations where `item` (co/no2/pm10) exceeds `threshold` in red
        (larger marker); other stations are shown in green (smaller marker).
        """
        if item not in ('co', 'no2', 'pm10'):
            raise ValueError("item must be one of 'co', 'no2', 'pm10'")

        counties = gpd.read_file(county_shp)
        counties['COUNTY'] = counties['COUNTY'].apply(
            lambda x: x.encode('latin1').decode('utf-8')
        )
        taipei_boundary = counties[counties['COUNTY'] == '臺北市']

        df = pd.read_csv(data_csv)
        taipei_df = df[df['county'] == '臺北市'].copy()

        from pyproj import Transformer
        from shapely.geometry import Point
        transformer = Transformer.from_crs('EPSG:4326', taipei_boundary.crs, always_xy=True)
        xs, ys = transformer.transform(
            taipei_df['longitude'].to_numpy(dtype='float64'),
            taipei_df['latitude'].to_numpy(dtype='float64'),
        )
        geometry = [Point(x, y) for x, y in zip(xs, ys)]
        gdf = gpd.GeoDataFrame(taipei_df, geometry=geometry, crs=taipei_boundary.crs)

        fig, ax = plt.subplots(figsize=(8, 8))
        taipei_boundary.plot(ax=ax, color='white', edgecolor='black')

        for _, row in gdf.iterrows():
            is_exceeded = row[item] > threshold
            color = 'red' if is_exceeded else 'green'
            size = 100 if is_exceeded else 30
            ax.scatter(row.geometry.x, row.geometry.y, color=color, s=size,
                       edgecolor='black', linewidth=0.5, zorder=3)

        ax.set_title(f'Taipei City Stations — {item.upper()} > {threshold} Alert Map')
        ax.set_xlabel('Longitude')
        ax.set_ylabel('Latitude')
        plt.tight_layout()
        plt.show()

        return fig
