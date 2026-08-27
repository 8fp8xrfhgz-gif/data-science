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

    # ------------------------------------------------------------------
    # Q1: ViewData — cross-tab of station vs. monitoring item
    # ------------------------------------------------------------------
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

    # ------------------------------------------------------------------
    # Q2: Chart — time series comparison of two stations for one item
    # ------------------------------------------------------------------
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

    # ------------------------------------------------------------------
    # Q3: AlertMap — flag stations exceeding a threshold on a Taipei map
    # ------------------------------------------------------------------
    def AlertMap(self, item, threshold, county_shp='TaiwanCounty.shp',
                 data_csv='data_0528_utf8.csv'):
        """
        Plots a map of monitoring stations within Taipei City, flagging
        stations where `item` (co/no2/pm10) exceeds `threshold` in red
        (larger marker); other stations are shown in green (smaller marker).

        FIXED vs. the original (lost) submission: the map figure is
        created and the county boundary is plotted ONCE, before the
        loop. Station markers are added to that same figure inside the
        loop, and the figure is only returned/shown AFTER the loop
        finishes — not after the first station.
        """
        if item not in ('co', 'no2', 'pm10'):
            raise ValueError("item must be one of 'co', 'no2', 'pm10'")

        # Load and filter to Taipei City boundary
        # NOTE: TaiwanCounty.shp uses the column 'COUNTY' (not
        # 'COUNTYNAME') and is projected in EPSG:3826 (TWD97 / TM2
        # zone 121), not plain lat/lon.
        #
        # This particular shapefile's .dbf stores Chinese text that
        # comes out double-encoded when read normally (e.g. "臺北市"
        # reads back as garbled characters). Re-encoding as latin1 and
        # decoding as utf-8 restores the correct Chinese text.
        counties = gpd.read_file(county_shp)
        counties['COUNTY'] = counties['COUNTY'].apply(
            lambda x: x.encode('latin1').decode('utf-8')
        )
        taipei_boundary = counties[counties['COUNTY'] == '臺北市']

        # Load station data and filter to Taipei City
        df = pd.read_csv(data_csv)
        taipei_df = df[df['county'] == '臺北市'].copy()

        # Station coordinates in data_0528_utf8.csv are plain lon/lat
        # (EPSG:4326), while TaiwanCounty.shp is in EPSG:3826 — reproject
        # manually with pyproj.Transformer instead of GeoDataFrame.to_crs(),
        # which triggers a ProjError bug in some geopandas/pyproj version
        # combinations ("x, y, z, and time must be same size").
        from pyproj import Transformer
        from shapely.geometry import Point
        transformer = Transformer.from_crs('EPSG:4326', taipei_boundary.crs, always_xy=True)
        xs, ys = transformer.transform(
            taipei_df['longitude'].to_numpy(dtype='float64'),
            taipei_df['latitude'].to_numpy(dtype='float64'),
        )
        geometry = [Point(x, y) for x, y in zip(xs, ys)]
        gdf = gpd.GeoDataFrame(taipei_df, geometry=geometry, crs=taipei_boundary.crs)

        # Set up the figure and boundary ONCE, outside the loop
        fig, ax = plt.subplots(figsize=(8, 8))
        taipei_boundary.plot(ax=ax, color='white', edgecolor='black')

        # Add station markers inside the loop, onto the same figure
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

        # Return the figure AFTER all stations have been plotted
        return fig