# Changing Hydroclimatic Regimes and Extreme Precipitation Dynamics in the Eastern Black Sea Region of Türkiye

### A NASA POWER-Based Hydroclimatic and Extreme Precipitation Analysis

**Author:** Ahmet Solmaz
**Study Region:** Eastern Black Sea Region, Türkiye
**Data Source:** NASA POWER
**Programming Environment:** R
**Study Period:** 1990–2025

---

## 1. Overview

The Eastern Black Sea Region of Türkiye is one of the country's most distinctive hydroclimatic environments, characterized by high precipitation, strong seasonal variability, steep topographic gradients, high atmospheric humidity, and frequent heavy precipitation events.

Although the region is generally recognized as a humid environment, changes in temperature, atmospheric moisture, precipitation intensity, and evaporative demand may substantially modify its hydroclimatic regime. Therefore, evaluating only long-term mean precipitation trends is insufficient to understand the changing characteristics of the regional climate.

This project investigates the **temporal evolution of hydroclimatic regimes and extreme precipitation dynamics in the Eastern Black Sea Region of Türkiye** using daily meteorological data obtained from the NASA Prediction of Worldwide Energy Resources (NASA POWER) database.

Rather than focusing exclusively on whether precipitation has increased or decreased, the study investigates whether the **structure, intensity, persistence, frequency, and statistical behavior of hydroclimatic extremes have changed over time**.

The analytical framework combines climate indices, non-parametric trend analysis, change-point detection, quantile regression, extreme value theory, wavelet analysis, and regime-switching models.

---

# 2. Research Objectives

The primary objective is to identify long-term changes in hydroclimatic conditions and extreme precipitation behavior across the Eastern Black Sea Region.

The study specifically aims to:

1. Characterize the long-term variability of precipitation and temperature.
2. Quantify changes in precipitation intensity and frequency.
3. Detect trends in extreme precipitation indices.
4. Identify statistically significant climate regime shifts.
5. Determine possible abrupt change points in hydroclimatic time series.
6. Investigate changes across different precipitation quantiles rather than only in the mean.
7. Estimate extreme precipitation return levels using Extreme Value Theory.
8. Examine temporal periodicities and frequency-dependent relationships using wavelet analysis.
9. Identify distinct hydroclimatic regimes using regime-switching models.
10. Evaluate the persistence and transition probabilities of different climate regimes.
11. Compare hydroclimatic behavior among selected locations across the Eastern Black Sea Region.
12. Develop an integrated statistical framework for understanding changing precipitation extremes in a humid climatic environment.

---

# 3. Study Area

The analysis focuses on the Eastern Black Sea Region of Türkiye, including representative locations distributed across the coastal and inland climatic gradients.

The study region is characterized by:

* High annual precipitation
* Strong precipitation seasonality
* High relative humidity
* Frequent heavy rainfall events
* Strong topographic influence
* Distinct coastal–inland hydroclimatic gradients
* Substantial variability in temperature and atmospheric moisture

The combination of high precipitation and complex topography makes the Eastern Black Sea Region particularly suitable for investigating changes in precipitation extremes and hydroclimatic regimes.

---

# 4. Data Source

Meteorological data are obtained from the **NASA Prediction of Worldwide Energy Resources (NASA POWER)** project.

The analysis primarily uses daily observations/reanalysis-derived estimates of the following variables:

| Variable            | NASA POWER Parameter | Description                         |
| ------------------- | -------------------- | ----------------------------------- |
| Precipitation       | PRECTOTCORR          | Corrected precipitation             |
| Air Temperature     | T2M                  | Mean air temperature                |
| Maximum Temperature | T2M_MAX              | Daily maximum temperature           |
| Minimum Temperature | T2M_MIN              | Daily minimum temperature           |
| Relative Humidity   | RH2M                 | Relative humidity at 2 m            |
| Wind Speed          | WS10M                | Wind speed at 10 m                  |
| Solar Radiation     | ALLSKY_SFC_SW_DWN    | All-sky surface shortwave radiation |

The primary study period is **1990–2025**, allowing the investigation of multi-decadal hydroclimatic variability and changes in extreme precipitation.

---

# 5. Data Processing

The raw NASA POWER data are processed using R.

The preprocessing workflow includes:

* Data import
* Date conversion
* Missing-value assessment
* Quality control
* Outlier screening
* Temporal aggregation
* Seasonal classification
* Annual aggregation
* Generation of precipitation indices
* Generation of temperature and moisture indicators
* Preparation of time series for statistical analysis

Extreme observations are carefully evaluated rather than automatically removed, because exceptionally high precipitation values may represent genuine climatic extremes rather than data errors.

---

# 6. Hydroclimatic Indicators

The study evaluates hydroclimatic variability through several complementary indicators.

## 6.1 Precipitation

The following precipitation characteristics are calculated:

* Annual precipitation
* Seasonal precipitation
* Wet-day frequency
* Precipitation intensity
* Maximum 1-day precipitation
* Maximum 5-day precipitation
* Consecutive wet days
* Consecutive dry days

---

## 6.2 Potential Evapotranspiration

Potential evapotranspiration is estimated using the **FAO-56 Penman–Monteith approach**, where the required meteorological variables are available.

PET provides an important measure of atmospheric evaporative demand and allows precipitation to be evaluated together with atmospheric water demand.

---

## 6.3 Drought and Moisture Indicators

The analysis includes:

* Standardized Precipitation Index (SPI)
* Standardized Precipitation Evapotranspiration Index (SPEI)
* Aridity Index
* Precipitation minus potential evapotranspiration (P − PET)

These indicators allow the study to investigate whether a traditionally humid environment is experiencing changes in its hydroclimatic moisture balance.

---

# 7. Extreme Precipitation Indices

A major component of the project is the analysis of precipitation extremes.

The study uses internationally recognized precipitation indices, including:

| Index   | Description                              |
| ------- | ---------------------------------------- |
| Rx1day  | Maximum 1-day precipitation              |
| Rx5day  | Maximum consecutive 5-day precipitation  |
| R10mm   | Number of days with precipitation ≥10 mm |
| R20mm   | Number of days with precipitation ≥20 mm |
| R95p    | Precipitation from very wet days         |
| R99p    | Precipitation from extremely wet days    |
| SDII    | Simple precipitation intensity index     |
| CDD     | Consecutive dry days                     |
| CWD     | Consecutive wet days                     |
| PRCPTOT | Annual precipitation from wet days       |

These indices provide information about both the **frequency and intensity** of precipitation extremes.

---

# 8. Statistical Methodology

## 8.1 Descriptive Statistics

Initial statistical characterization includes:

* Mean
* Median
* Standard deviation
* Coefficient of variation
* Minimum
* Maximum
* Skewness
* Kurtosis

These statistics are used to describe the distribution and variability of hydroclimatic variables.

---

# 9. Mann–Kendall Trend Analysis

The **Modified Mann–Kendall test** is applied to identify statistically significant monotonic trends while accounting for potential serial correlation in meteorological time series.

The analysis is performed for:

* Precipitation
* Temperature
* PET
* SPI
* SPEI
* Extreme precipitation indices

The direction and statistical significance of temporal trends are evaluated separately.

---

# 10. Sen's Slope Estimator

Sen's slope is used to quantify the magnitude of detected trends.

While Mann–Kendall determines whether a statistically significant monotonic trend exists, Sen's slope estimates the rate of change.

This provides an interpretable measure such as:

> millimeters per year

or

> degrees Celsius per decade.

---

# 11. Change-Point Analysis

Changes in hydroclimatic regimes are investigated using multiple change-point methods.

### Pettitt Test

The Pettitt test is used to identify statistically significant single change points in the time series.

### PELT

The **Pruned Exact Linear Time (PELT)** algorithm is used to identify potentially multiple structural changes.

This allows the analysis to distinguish between:

* Gradual trends
* Abrupt changes
* Multiple regime shifts

The combination of Pettitt and PELT provides a more comprehensive assessment of temporal structural changes.

---

# 12. Quantile Regression

Conventional regression focuses primarily on changes in the mean.

However, changes in precipitation extremes may occur mainly in the upper tail of the distribution.

Therefore, **quantile regression** is applied to selected precipitation variables at multiple quantiles:

* 0.10
* 0.25
* 0.50
* 0.75
* 0.90
* 0.95
* 0.99

This approach allows the study to determine whether changes are concentrated in the lower, central, or extreme portions of the precipitation distribution.

A particularly important research question is whether extreme precipitation has changed even when the long-term mean precipitation trend remains weak.

---

# 13. Extreme Value Theory

Extreme Value Theory (EVT) is used to characterize the statistical behavior of rare precipitation events.

## 13.1 Generalized Extreme Value Model

The **Generalized Extreme Value (GEV)** distribution is applied to block maxima, particularly annual maximum precipitation.

The analysis estimates:

* Distribution parameters
* Return levels
* Return periods
* Confidence intervals

Return levels are estimated for selected return periods such as:

* 10 years
* 25 years
* 50 years
* 100 years

---

## 13.2 Generalized Pareto Distribution

The **Generalized Pareto Distribution (GPD)** is applied using the **Peaks Over Threshold (POT)** approach.

This method allows extreme precipitation events exceeding a defined threshold to be analyzed directly.

The EVT component provides an estimate of the probability and magnitude of rare precipitation events.

---

# 14. Wavelet Analysis

Climate time series frequently contain variability at multiple temporal scales.

Therefore, wavelet analysis is used to investigate changes in precipitation variability across different time scales.

The analysis includes:

### Continuous Wavelet Transform

Used to identify dominant periodicities in precipitation and hydroclimatic variables.

### Wavelet Coherence

Used to examine time-frequency relationships between variables such as:

* Temperature and precipitation
* Relative humidity and precipitation
* PET and precipitation
* SPI and precipitation

This allows the analysis to determine whether relationships remain stable over time or become stronger/weaker during specific periods.

---

# 15. Hydroclimatic Regime Analysis

One of the central components of the project is the identification of distinct hydroclimatic regimes.

Potential regimes include:

* Humid regime
* Normal regime
* Dry regime
* Extreme precipitation regime

The classification is based on combinations of:

* Precipitation
* Temperature
* PET
* SPI
* SPEI
* Relative humidity
* Extreme precipitation indicators

---

# 16. Markov-Switching Model

A **Markov-Switching Model** is used to identify hidden temporal regimes within the hydroclimatic system.

The model allows the statistical properties of the time series to vary depending on the underlying climatic state.

The analysis estimates:

* Regime-specific means
* Regime-specific variability
* Transition probabilities
* Regime persistence
* Expected regime duration
* Probability of transition between hydroclimatic states

This approach provides a dynamic perspective on hydroclimatic change rather than assuming that the entire study period represents a single stationary climate regime.

---

# 17. Multivariate Analysis

Because hydroclimatic variability is controlled by several interacting variables, multivariate methods are also considered.

## Principal Component Analysis

PCA is used to identify the dominant dimensions of hydroclimatic variability.

Potential input variables include:

* Precipitation
* Temperature
* Relative humidity
* PET
* SPI
* SPEI
* Extreme precipitation indices

The objective is to identify the major components explaining regional hydroclimatic variability.

---

# 18. Cluster Analysis

Hierarchical clustering and/or k-means clustering are used to classify locations according to their hydroclimatic characteristics.

This allows the identification of groups with similar:

* Precipitation regimes
* Temperature behavior
* Moisture conditions
* Extreme precipitation characteristics
* Hydroclimatic variability

The resulting clusters can reveal differences between coastal and inland climatic environments.

---

# 19. Correlation Analysis

Relationships among hydroclimatic variables are investigated using:

* Pearson correlation
* Spearman rank correlation
* Kendall's tau

The analysis focuses on relationships between:

**Temperature ↔ Precipitation**

**Humidity ↔ Precipitation**

**PET ↔ Precipitation**

**Temperature ↔ PET**

**SPI ↔ SPEI**

These analyses provide an initial assessment of interactions before applying more advanced time-series methods.

---

# 20. Integrated Analytical Framework

The complete methodology follows the sequence:

```text
NASA POWER Daily Data
        ↓
Data Quality Control
        ↓
Temporal Aggregation
        ↓
Hydroclimatic Indicators
        ↓
Extreme Precipitation Indices
        ↓
SPI / SPEI / PET
        ↓
Modified Mann–Kendall
        ↓
Sen's Slope
        ↓
Pettitt Test
        ↓
PELT Change-Point Analysis
        ↓
Quantile Regression
        ↓
Extreme Value Theory
        ↓
GEV / GPD / POT
        ↓
Wavelet Analysis
        ↓
Wavelet Coherence
        ↓
PCA / Cluster Analysis
        ↓
Markov-Switching Model
        ↓
Hydroclimatic Regime Interpretation
```

---

# 21. Main Research Questions

The project is designed around several central research questions:

### RQ1

Has annual and seasonal precipitation significantly changed in the Eastern Black Sea Region since 1990?

### RQ2

Have extreme precipitation events become more frequent or intense?

### RQ3

Are changes in precipitation concentrated in the upper tail of the distribution?

### RQ4

Have abrupt shifts occurred in the regional hydroclimatic regime?

### RQ5

Do precipitation and atmospheric moisture relationships vary across time scales?

### RQ6

Has evaporative demand altered the regional moisture balance despite the region's humid climatic characteristics?

### RQ7

Can the hydroclimatic system be represented by distinct statistical regimes?

### RQ8

How persistent are these regimes, and how frequently does the system transition between them?

### RQ9

Are coastal and inland locations characterized by different extreme precipitation regimes?

### RQ10

Are rare precipitation events becoming statistically more probable?

---

# 22. Expected Scientific Contribution

The main contribution of this project is the integration of **trend analysis, extreme-value statistics, time-frequency analysis, and regime-switching methodology** within a single hydroclimatic framework.

The study does not interpret climate change solely through changes in average temperature or total precipitation.

Instead, it examines:

* Changes in precipitation intensity
* Changes in extreme-event frequency
* Distributional changes
* Structural breaks
* Temporal periodicities
* Hydroclimatic moisture balance
* Extreme-event probabilities
* Regime persistence
* Regime transitions

This multidimensional framework can provide a more comprehensive understanding of how hydroclimatic variability is evolving in one of Türkiye's most precipitation-sensitive regions.

---

# 23. Reproducible Research

All statistical analyses are implemented in **R**.

The project is designed according to reproducible research principles:

* Automated data processing
* Reproducible statistical procedures
* Script-based analysis
* Standardized outputs
* High-resolution figures
* Transparent methodology
* Structured result tables

The repository will progressively include the R scripts, processed datasets where distribution is permitted, statistical outputs, and visualization files.

---

# 24. Project Structure

```text
Eastern-Black-Sea-Hydroclimatic-Regimes/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── R/
│   ├── 01_data_download.R
│   ├── 02_data_cleaning.R
│   ├── 03_hydroclimatic_indices.R
│   ├── 04_extreme_precipitation.R
│   ├── 05_mann_kendall.R
│   ├── 06_sens_slope.R
│   ├── 07_change_points.R
│   ├── 08_quantile_regression.R
│   ├── 09_extreme_value_theory.R
│   ├── 10_wavelet_analysis.R
│   ├── 11_markov_switching.R
│   ├── 12_pca_clustering.R
│   └── 13_visualization.R
│
├── figures/
│
├── results/
│
├── tables/
│
└── README.md
```

---

# 25. Reproducibility Philosophy

The project follows an open and reproducible analytical philosophy.

Every major statistical result should be traceable from:

**NASA POWER data → preprocessing → index calculation → statistical model → numerical result → visualization.**

This structure is intended to make the analysis transparent and independently reproducible.

---

# 26. Scientific Scope

This project contributes to the broader fields of:

* Climate variability
* Hydroclimatology
* Extreme precipitation analysis
* Climate statistics
* Time-series analysis
* Extreme Value Theory
* Climate regime detection
* Atmospheric moisture dynamics
* Climate change assessment

The methodology is particularly relevant for understanding the changing behavior of extreme precipitation in humid and topographically complex environments.

---

# 27. Author

**Ahmet Solmaz**

Geography | Climatology | Hydroclimatology | Climate Data Analysis | R Statistical Computing

This project is independently developed by **Ahmet Solmaz** as a reproducible research project focused on advanced statistical analysis of hydroclimatic variability and precipitation extremes in the Eastern Black Sea Region of Türkiye.

---

# 28. Project Status

**Status:** Research and analytical development

The statistical analysis, visualization, and interpretation stages are being progressively developed.

Final numerical results will be added after completion and validation of the full analytical workflow.

---

# 29. Keywords

`Eastern Black Sea`
`Türkiye`
`NASA POWER`
`Hydroclimatology`
`Extreme Precipitation`
`Climate Variability`
`Climate Change`
`Mann-Kendall`
`Sen's Slope`
`Pettitt Test`
`PELT`
`Quantile Regression`
`Extreme Value Theory`
`GEV`
`GPD`
`POT`
`Wavelet Analysis`
`Wavelet Coherence`
`Markov Switching`
`SPI`
`SPEI`
`Penman-Monteith`
`R Programming`
`Time Series Analysis`

---

## Citation

If this repository contributes to your research, please acknowledge the project and the underlying NASA POWER data source.

**Author:** Ahmet Solmaz
**Project:** *Changing Hydroclimatic Regimes and Extreme Precipitation Dynamics in the Eastern Black Sea Region of Türkiye*
