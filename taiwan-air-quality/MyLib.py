"""
MyLib.py
"""
import sqlite3
import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt


class AirObj:
    def __init__(self, db_path='airquality.db'):
        self.db_connection = sqlite3.connect(db_path)

    def ViewData(self, stat='mean'):
        df = pd.read_sql_query("SELECT site, item, value FROM airdata", self.db_connection)
        df['value'] = pd.to_numeric(df['value'], errors='coerce')
        agg_map = {'mean': 'mean', 'max': 'max', 'min': 'min'}
        if stat not in agg_map:
            raise ValueError("stat must be one of 'mean', 'max', 'min'")
        table = df.pivot_table(index='site', columns='item', values='value', aggfunc=agg_map[stat])
        return table

    def Chart(self, item, site1, site2):
        df = pd.read_sql_query(
            "SELECT site, date, value FROM airdata WHERE item = ? AND site IN (?, ?)",
            self.db_connection, params=(item, site1, site2))
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

    def AlertMap(self, item, threshold, county_shp='TaiwanCounty.shp', data_csv='data_0528_utf8.csv'):
        if item not in ('co', 'no2', 'pm10'):
            raise ValueError("item must be one of 'co', 'no2', 'pm10'")
        counties = gpd.read_file(county_shp)
        counties['COUNTY'] = counties['COUNTY'].apply(lambda x: x.encode('latin1').decode('utf-8'))
        taipei_boundary = counties[counties['COUNTY'] == '臺北市']
        df = pd.read_csv(data_csv)
        taipei_df = df[df['county'] == '臺北市'].copy()
        gdf = gpd.GeoDataFrame(taipei_df, geometry=gpd.points_from_xy(taipei_df['longitude'], taipei_df['latitude']), crs='EPSG:4326')
        gdf = gdf.to_crs(taipei_boundary.crs)
        fig, ax = plt.subplots(figsize=(8, 8))
        taipei_boundary.plot(ax=ax, color='white', edgecolor='black')
        for _, row in gdf.iterrows():
            is_exceeded = row[item] > threshold
            color = 'red' if is_exceeded else 'green'
            size = 100 if is_exceeded else 30
            ax.scatter(row.geometry.x, row.geometry.y, color=color, s=size, edgecolor='black', linewidth=0.5, zorder=3)
        ax.set_title(f'Taipei City Stations - {item.upper()} > {threshold} Alert Map')
        ax.set_xlabel('Longitude')
        ax.set_ylabel('Latitude')
        plt.tight_layout()
        plt.show()
        return fig
