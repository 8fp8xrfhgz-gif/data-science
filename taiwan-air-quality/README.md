# Taiwan Air Quality Analysis (NTU Coursework)

Coursework from **Programming for Geographic Data Science**, Department of Geography, National Taiwan University (Spring 2023), taught by Prof. Tsai-Hung Wen.

This folder contains my midterm and final exam projects, both built around real Taiwan EPA air quality monitoring data. These directly foreshadow the spatial analysis approach I'm applying to my current Data Science Fundamentals final project (predicting U.S. EPA pollution levels).

## Contents

- **`Midterm.ipynb`** — Basic data querying and a nearest-station search algorithm (finds the closest air quality monitoring station to a given coordinate), implemented in pure Python.
- **`Final_Exam.ipynb`** — A more advanced object-oriented air quality analysis tool, including:
  - SQL querying (`sqlite3`) and pivot-table summaries of pollutant data by station
  - Time-series comparison charts between monitoring stations (matplotlib)
  - Geospatial visualization with `geopandas` and `folium`, flagging stations that exceed pollution thresholds on a map of Taipei/New Taipei
- **`EPA_STN1.csv`** — Station metadata for Taiwan's national air quality monitoring network (site names, coordinates in TWD97, and pollutant readings).
- **`data_0528_utf8.csv`** — Daily pollutant monitoring data (CO, NO2, PM10) by station, used in the final exam's map visualization.
- **`TaiwanCounty.shp`** (+ `.dbf`, `.shx`, `.prj`) — County-level boundary shapefile for Taiwan, used as the base map.

## Why this matters for my current work

My GIS background is the foundation for how I approach data science problems — treating location as a meaningful feature, not just a category. This coursework shows that foundation in practice: querying real environmental monitoring data, building reusable analysis tools, and visualizing spatial patterns in pollution — the same skill set I'm now extending with regression modeling in my current air pollution prediction project.