# Adult Data Clustering Analysis

## Overview
This project involves clustering analysis of the 'Adult' dataset from the UCI Machine Learning Repository. The goal is to identify meaningful structures in the data and discover useful patterns that may help in socio-economic investigations.

## Data
The dataset includes various demographic and economic attributes. The pre-processing steps include handling missing values, one-hot encoding categorical variables, and scaling numerical features.

### Data Files
- `data/adult.data`: Raw dataset used for analysis.

## Methodology
1. **Data Preprocessing**:
   - Handling missing values
   - One-hot encoding categorical variables
   - Scaling numerical features

2. **Clustering Methods**:
   - K-Means Clustering
   - DBSCAN Clustering
   - Hierarchical Clustering
   - Gaussian Mixture Models (GMM)

## How to Run the Project
### Prerequisites
- R and RStudio installed on your system.
- Required R packages installed. You can install necessary packages by running:
  ```R
  install.packages(c("ggplot2", "dplyr", "fastDummies", "cluster", "factoextra", "plotly", "pheatmap", "igraph", "mclust", "dbscan"))
