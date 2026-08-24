# Spatial Analysis (R Coursework, NTU)

Coursework from **Spatial Analysis**, Department of Geography, National Taiwan University (Spring 2024). All analysis done in R using `sf`, `spatstat`, `dplyr`, and `tmap`.

## Contents

- **`期中考.Rmd`** / **`期中考.nb.html`** — Midterm exam. Includes:
  - Spatial distance calculations between administrative villages and fast food store locations (`sf::st_distance`)
  - Population-weighted centroid calculation by district (`dplyr` + `st_centroid`)

- **`空分期末.Rmd`** / **`空分期末.html`** — Final exam. Includes:
  - **Point pattern analysis** on fast food store locations using Quadrat Analysis (`spatstat::quadratcount`)
  - **Chi-square test for spatial clustering** — statistically testing whether store locations are randomly distributed or significantly clustered
  - Additional spatial statistics questions (see `空間分析期末考-實作題.pdf` for the original prompts)

- **`空間分析期末考-實作題.pdf`** — Original exam questions for reference.

## Why this matters for my current work

This course is where I first applied formal spatial statistics — not just mapping data, but testing hypotheses about spatial patterns (e.g., "are these points clustered, and is that statistically significant?"). That same mindset — treating location as something to be rigorously tested, not just visualized — is what I bring to my current Data Science Fundamentals final project on U.S. air pollution prediction.

**Note:** `.html` / `.nb.html` files can be downloaded and opened directly in a browser to view the full rendered output, including plots and test results.