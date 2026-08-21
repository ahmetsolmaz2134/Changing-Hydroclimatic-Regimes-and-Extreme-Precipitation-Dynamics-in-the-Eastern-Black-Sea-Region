# Changing Hydroclimatic Regimes and Extreme Precipitation Dynamics in the Eastern Black Sea Region of Türkiye

### An Integrated Hydroclimatic, Extreme Precipitation, Time-Frequency and Regime-Based Analysis

**Author:** Ahmet Solmaz
**Region:** Eastern Black Sea Region, Türkiye
**Data Source:** NASA POWER
**Study Period:** 1990–2025
**Programming Environment:** R

---

## Overview

The Eastern Black Sea Region of Türkiye represents one of the most precipitation-intensive and hydroclimatically complex regions of the country. Its climatic structure is characterized by strong precipitation seasonality, high atmospheric moisture, pronounced spatial variability and frequent high-intensity precipitation events.

This project, prepared by **Ahmet Solmaz**, investigates the temporal evolution, variability, extremes, structural changes and hydroclimatic regimes of the Eastern Black Sea Region using NASA POWER meteorological data.

The project combines classical and advanced statistical approaches, including:

* Hydroclimatic indices
* Drought and aridity analysis
* ETCCDI precipitation extremes
* Mann–Kendall trend analysis
* Sen's slope estimation
* Pettitt change-point detection
* PELT segmentation
* Quantile regression
* Extreme Value Theory
* GEV/GPD/POT analysis
* Wavelet analysis
* Wavelet coherence
* Correlation analysis
* Principal Component Analysis
* Station clustering
* Multivariate regime analysis
* Markov-switching/regime-based analysis

---

# 1. Research Framework

The complete analytical framework follows:

```text
NASA POWER Data
       ↓
Data Processing
       ↓
Hydroclimatic Indicators
       ↓
Drought & Aridity
       ↓
Precipitation Extremes
       ↓
Trend Analysis
       ↓
Change-Point Detection
       ↓
Quantile Regression
       ↓
Extreme Value Theory
       ↓
Wavelet Analysis
       ↓
PCA
       ↓
Clustering
       ↓
Hydroclimatic Regimes
```

The project therefore evaluates the Eastern Black Sea climate from multiple statistical perspectives rather than relying on a single trend statistic.

---

# 2. Hydroclimatic Analysis

The first stage evaluates the fundamental hydroclimatic characteristics of the region.

The analysis includes precipitation variability, drought-related indicators, aridity characteristics and atmospheric moisture conditions.

### Hydroclimatic and Drought Results

The corresponding numerical outputs are available in:

* `East_BlackSea_Master_Analysis.xlsx`
* `East_BlackSea_Drought_Aridity_Indices.xlsx`
* `East_BlackSea_Precipitation_Indices.xlsx`

---

# 3. Precipitation Extreme Analysis

Extreme precipitation represents one of the central components of the project.

The analysis examines a broad range of precipitation-extreme characteristics based on ETCCDI-style indices.

The corresponding results are stored in:

`East_BlackSea_ETCCDI_Extremes.xlsx`

The graphical outputs provide a visual representation of temporal changes in precipitation intensity, frequency and extreme-event behavior.

---

# 4. Trend Analysis

Long-term temporal behavior is investigated using non-parametric trend analysis.

The statistical framework includes:

* Modified Mann–Kendall
* Sen's slope
* Trend direction
* Statistical significance

The results are stored in:

`East_BlackSea_Trend_Analysis_Results.xlsx`

### Trend Analysis Figures

The trend-related figures in the repository provide station-level and variable-level visualization of long-term hydroclimatic behavior.

These figures are intended to complement the numerical trend tables and provide an immediate visual interpretation of temporal evolution.

---

# 5. Change-Point Analysis

Climate time series may contain abrupt structural changes that cannot be adequately represented by a single linear trend.

Two complementary approaches are therefore used:

### Pettitt Test

`East_BlackSea_Pettitt_Test_Results.xlsx`

### PELT Change-Point Detection

`East_BlackSea_PELT_Change_Points.xlsx`

The combination of these approaches provides a more detailed examination of structural changes within the hydroclimatic record.

---

# 6. Extreme Value Theory

Extreme Value Theory is used to investigate the statistical behavior of rare precipitation events.

The project includes:

* Generalized Extreme Value distribution
* Generalized Pareto distribution
* Peaks Over Threshold
* Return-period analysis
* Extreme-event probability assessment

The principal output is:

`East_BlackSea_EVT_Results.xlsx`

### EVT Visualization

The EVT figures provide a visual representation of the statistical tail behavior of precipitation.

These graphics are particularly important because extreme precipitation risk cannot be adequately described by mean precipitation statistics alone.

---

# 7. Quantile Regression

Quantile regression is used to investigate whether temporal changes occur uniformly across the precipitation distribution.

The analysis considers different sections of the conditional distribution, allowing the study to compare:

* lower precipitation quantiles,
* central quantiles,
* upper quantiles,
* and extreme precipitation quantiles.

Results are stored in:

`East_BlackSea_Quantile_Regression.xlsx`

### Quantile Regression Figures

The graphical outputs allow the reader to visually compare temporal behavior across different quantiles of the precipitation distribution.

This provides an important complement to conventional mean-based regression.

---

# 8. Wavelet Analysis

Climate variability is inherently multiscale.

Wavelet analysis is therefore used to identify temporal-frequency structures that may not be visible through conventional trend analysis.

The project investigates:

* dominant periodicities,
* temporal localization of variability,
* changing oscillatory behavior,
* and non-stationary frequency structures.

Results are stored in:

`East_BlackSea_Wavelet_Analysis.xlsx`

### Wavelet Figures

The wavelet figures visualize the temporal evolution of precipitation variability across multiple frequency scales.

These graphics provide an important time-frequency perspective on Eastern Black Sea hydroclimatic variability.

---

# 9. Wavelet Coherence

Wavelet coherence extends the time-frequency analysis by examining the relationship between hydroclimatic variables across different temporal scales.

The analysis allows relationships among variables such as:

* precipitation,
* temperature,
* humidity,
* PET,
* SPI,
* SPEI

to be evaluated in both time and frequency domains.

The corresponding figures visualize periods and scales in which relationships become stronger or weaker.

---

# 10. Correlation Structure

The project evaluates the statistical dependence among hydroclimatic variables using:

* Pearson correlation
* Spearman correlation
* Kendall's tau

The results are available in:

`Station_Correlation_Analysis.xlsx`

## Academic Correlation Heatmap

![Academic Correlation Heatmap](Academic_Correlation_Heatmap.png)

The correlation heatmap provides a compact visual representation of the dependence structure among the major hydroclimatic variables.

---

# 11. Principal Component Analysis

Principal Component Analysis is used to identify the dominant dimensions of hydroclimatic variability.

The PCA results are stored in:

`Hydroclimatological_PCA_Analysis.xlsx`

## PCA Scree Plot

![PCA Scree Plot](PCA_ScreePlot_Academic.png)

The scree plot illustrates the relative contribution of the principal components and provides a visual basis for evaluating dimensional reduction.

## PCA Variable Biplot

![PCA Variable Biplot](PCA_Variable_Biplot_Academic.png)

The PCA biplot provides a visual representation of the relationships among the hydroclimatic variables and their contribution to the principal component structure.

---

# 12. Station Clustering

Station clustering is used to investigate similarities in hydroclimatic behavior among locations.

The analysis provides a complementary spatial-statistical perspective without requiring a conventional geographic map.

The results are stored in:

`Station_Clustering_Report.xlsx`

## Publication-Quality Station Clustering

![Publication Quality Clustering](Publication_Quality_Clustering.png)

The clustering visualization highlights groups of stations exhibiting similar statistical hydroclimatic characteristics.

---

# 13. Multivariate Hydroclimatic Regimes

The project goes beyond individual-variable analysis by investigating the existence of multivariate hydroclimatic regimes.

The principal outputs are:

* `Analysis_24_Multivariate_Regime_Results.xlsx`
* `East_BlackSea_Regime_Analysis_R.xlsx`

The regime framework combines multiple hydroclimatic characteristics to investigate whether the climate system can be represented by distinct statistical states.

---

# 14. Station-Level Hydroclimatic Regimes

The repository includes publication-oriented regime visualizations for major Eastern Black Sea stations.

---

## Artvin

![Artvin Hydroclimatic Regimes](Artvin_Regimes_Academic.png)

The Artvin regime visualization provides a station-level representation of temporal changes in the statistical hydroclimatic state.

---

## Giresun

![Giresun Hydroclimatic Regimes](Giresun_Regimes_Academic.png)

The Giresun figure illustrates the temporal organization of hydroclimatic states and their evolution through the study period.

---

## Ordu

![Ordu Hydroclimatic Regimes](Ordu_Regimes_Academic.png)

The Ordu visualization provides an additional station-level perspective on hydroclimatic regime variability.

---

## Rize

![Rize Hydroclimatic Regimes](Rize_Regimes_Academic.png)

The Rize figure represents the temporal evolution of hydroclimatic regimes at one of the region's most precipitation-sensitive locations.

---

## Trabzon

![Trabzon Hydroclimatic Regimes](Trabzon_Regimes_Academic.png)

The Trabzon visualization provides another station-level representation of changing hydroclimatic states.

---

# 15. Complete Graphical Analysis

The repository contains a broad collection of analytical figures covering different dimensions of hydroclimatic variability.

The graphical framework includes:

### Hydroclimatic Variability

* precipitation variability
* drought indicators
* aridity indicators
* moisture-related variables

### Precipitation Extremes

* extreme precipitation indices
* intensity indicators
* wet and dry spell indicators
* precipitation distribution characteristics

### Temporal Trends

* long-term trends
* trend lines
* station-level temporal evolution

### Structural Changes

* Pettitt change points
* PELT segmentation
* temporal regime boundaries

### Distributional Analysis

* quantile regression
* upper-tail behavior
* lower-tail behavior

### Extreme Value Analysis

* GEV
* GPD
* POT
* return-period characteristics

### Time-Frequency Analysis

* wavelet power
* wavelet spectra
* wavelet coherence
* temporal periodicity

### Multivariate Analysis

* correlation heatmaps
* PCA scree plots
* PCA biplots
* station clustering

### Regime Analysis

* multivariate regimes
* station-level regimes
* regime transitions
* temporal regime structure

---

# 16. Graphical Evidence Gallery

## Correlation Structure

![Correlation Structure](Academic_Correlation_Heatmap.png)

---

## PCA Explained Variance

![PCA Explained Variance](PCA_ScreePlot_Academic.png)

---

## PCA Hydroclimatic Structure

![PCA Hydroclimatic Structure](PCA_Variable_Biplot_Academic.png)

---

## Station Clustering

![Station Clustering](Publication_Quality_Clustering.png)

---

## Artvin Regime Structure

![Artvin Regime Structure](Artvin_Regimes_Academic.png)

---

## Giresun Regime Structure

![Giresun Regime Structure](Giresun_Regimes_Academic.png)

---

## Ordu Regime Structure

![Ordu Regime Structure](Ordu_Regimes_Academic.png)

---

## Rize Regime Structure

![Rize Regime Structure](Rize_Regimes_Academic.png)

---

## Trabzon Regime Structure

![Trabzon Regime Structure](Trabzon_Regimes_Academic.png)

---

# 17. Analytical Integration

The graphical results are not intended to be interpreted independently.

The project integrates them through the following conceptual structure:

```text
TREND
  ↓
STRUCTURAL CHANGE
  ↓
DISTRIBUTIONAL CHANGE
  ↓
EXTREME-EVENT BEHAVIOR
  ↓
TIME-FREQUENCY VARIABILITY
  ↓
MULTIVARIATE STRUCTURE
  ↓
HYDROCLIMATIC REGIMES
```

This framework allows the project to examine hydroclimatic change from several complementary statistical perspectives.

---

# 18. Research Outputs

The repository contains three principal categories of research outputs.

### Numerical Outputs

Excel files containing statistical estimates, indices, test statistics and analytical results.

### Graphical Outputs

High-quality PNG figures designed to visualize temporal, statistical and multivariate characteristics.

### Reproducible Code

R scripts implementing the analytical workflow.

---

# 19. Reproducibility

All analyses were developed in **R**.

The repository is structured to allow the analytical workflow to be reproduced from data processing through statistical analysis and visualization.

The project emphasizes:

* transparent statistical methodology,
* reproducible computation,
* structured analytical outputs,
* publication-oriented graphics,
* and clear separation between numerical results and visualization.

---

# 20. Scientific Perspective

The principal objective of the project is not merely to determine whether precipitation increased or decreased.

Instead, the analysis investigates the broader question:

> **How is the statistical structure of the Eastern Black Sea hydroclimatic system changing through time?**

This requires examining:

* trends,
* structural breaks,
* precipitation extremes,
* distributional changes,
* temporal periodicities,
* multivariate dependencies,
* station similarities,
* and hydroclimatic regimes.

The graphical outputs presented in this repository provide a visual synthesis of these different dimensions.

---

# 21. Author

## Ahmet Solmaz

This research project was prepared and developed by **Ahmet Solmaz**.

The project focuses on hydroclimatology, climate variability, extreme precipitation, statistical climatology, time-series analysis and hydroclimatic regime detection.

---

# 22. Repository

**Project:** Changing Hydroclimatic Regimes and Extreme Precipitation Dynamics in the Eastern Black Sea Region of Türkiye

**Author:** Ahmet Solmaz

**Data:** NASA POWER

**Period:** 1990–2025

**Software:** R

**Primary Focus:** Hydroclimatic variability, extreme precipitation and regime dynamics

---

# Keywords

`Eastern Black Sea` · `Türkiye` · `Hydroclimatology` · `NASA POWER` · `Extreme Precipitation` · `Climate Variability` · `Climate Change` · `Mann-Kendall` · `Sen's Slope` · `Pettitt` · `PELT` · `Quantile Regression` · `Extreme Value Theory` · `GEV` · `GPD` · `POT` · `Wavelet Analysis` · `PCA` · `Clustering` · `Hydroclimatic Regimes` · `R`
