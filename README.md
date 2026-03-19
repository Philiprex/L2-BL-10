# L2-BL 10: Last Two Digit Benford's Law Analysis for Election Data

Code for *"A Novel Benford-Based Approach for Detecting Statistical Anomalies in Precinct-Level Election Data"* by Philip Eigen, Steven J. Miller, and Kevin Dayaratna.

## Overview

This repository implements the L2-BL 10 framework, which tests precinct-level vote count data for conformity to Benford's Law by examining the joint distribution of final digit pairs. Unlike traditional first-digit Benford tests, this approach does not require data to span multiple orders of magnitude, making it well-suited to precinct-level election returns.

The analysis pipeline for a given election:

1. **Fit** a discrete Weibull distribution to each county's precinct-level vote counts via MLE.
2. **Assess goodness of fit** using a parametric bootstrap discrete Kolmogorov-Smirnov (d-KS) test.
3. **Assess Benford conformity of the fitted distribution** via chi-squared tests on Monte Carlo samples.
4. **Assess Benford conformity of the observed data** via chi-squared tests on matched-pair frequencies.
5. **Flag** counties where the fitted distribution is well-fit and Benford-conforming, but the observed data is not.

## Dependencies

- R (>= 4.0)
- `tidyverse`
- [`KSgeneral`](https://cran.r-project.org/package=KSgeneral) - exact discrete KS test statistics
- [`dWeibullAlt`](https://github.com/Philiprex/dWeibullAlt) - discrete Weibull distribution functions with alternative parameterization
- `cowplot`, `scales`, `magick` (for figure generation only)

## Project Structure

```
.
├── utilities/                 # Core statistical functions
│   ├── ddweibull.R             # Discrete Weibull density (PMF)
│   ├── pdweibull.R             # Discrete Weibull CDF
│   ├── qdweibull.R             # Discrete Weibull quantile function
│   ├── rdweibull.R             # Discrete Weibull random sampling
│   ├── param_fitter.R          # MLE fitting for discrete Weibull
│   │                           #   parameters
│   ├── boot_dKS.R              # Parametric bootstrap discrete
│   │                           #   KS test
│   ├── estWeibullChiSq.R       # Monte Carlo chi-squared test for
│   │                           #   L2-BL 10 conformity
│   ├── benfordProb.R           # Benford probability of digit d
│   │                           #   in the nth position
│   ├── l2BenfordProb.R         # Joint Benford probability of
│   │                           #   digit pairs (Eq. 4.3)
│   └── benfordDist.R           # Full Benford digit distribution
│                               #   for a given position
│
├── president_2016/             # 2016 U.S. Presidential Election
│   ├── elecData2016.rds        # Raw precinct-level data
│   │                           #   (source: MIT MEDSL)
│   ├── dataRefiner.R           # Filters raw data to relevant
│   │                           #   states/candidates/modes
│   ├── run2016.R               # Runs the full L2-BL 10 pipeline
│   │                           #   by state
│   └── resultsFormatter2016.r  # Compiles results, applies
│                               #   Bonferroni correction, extracts
│                               #   flagged counties
│
├── president_2020/             # 2020 U.S. Presidential Election
│   ├── elecData2020.rds        # Raw precinct-level data
│   │                           #   (source: MIT MEDSL)
│   ├── dataRefiner.R           # Filters raw data to relevant
│   │                           #   states/candidates/modes
│   ├── run2020.R               # Runs the full L2-BL 10 pipeline
│   │                           #   by state
│   └── resultsFormatter2020.r  # Compiles results, applies
│                               #   Bonferroni correction, extracts
│                               #   flagged counties
│
├── weibullSimulations/         # Weibull conformity to L2-BL 10
│   │                           #   (Section 4.3)
│   └── simWeibull.R            # Tests L2-BL 10 conformity across
│                               #   a grid of Weibull params
│
└── graphing/                   # Figure generation (Figs. 1-7)
    ├── fig1Generator.R         # Benford's Law first-digit
    │                           #   distribution
    ├── fig2Generator.R         # Digit distributions for
    │                           #   positions 1-4
    ├── fig3Generator.R         # Vote count distributions with
    │                           #   Weibull overlays
    ├── fig4Generator.R         # d-KS test results across
    │                           #   parameter space
    ├── fig5Generator.R         # Discrete Weibull PMFs across
    │                           #   parameterizations
    ├── fig6Generator.R         # L2-BL 10 conformity across
    │                           #   Weibull parameter grid
    └── fig7Generator.R         # County precinct count
                                #   distributions
```

## Usage

### Running an election analysis

Each election directory (`president_2016/`, `president_2020/`) is run in sequence:

1. **Set working directory** to the election directory (e.g., `president_2016/`).
2. **Run `dataRefiner.R`** to filter raw data into a cleaned subset (`relData20XX.rds`). The nine states analyzed are FL, GA, MD, MO, NE, NY, PA, TN, and WA. Some states are restricted to in-person votes due to how absentee data was reported.
3. **Run `run20XX.R`** to execute the full L2-BL 10 pipeline. This produces per-state results files. This step is computationally intensive (1000 bootstrap d-KS samples + 100 Monte Carlo chi-squared simulations per county-candidate).
4. **Run `resultsFormatter20XX.r`** to compile state-level results, apply Bonferroni corrections, and extract fully flagged counties.

### Running the Weibull simulations

Set the working directory to `weibullSimulations/` and run `simWeibull.R`. This tests L2-BL 10 conformity of the discrete Weibull across a grid of parameterizations (mu from 1 to 10, sigma from 0.1 to 2) at sample sizes of 25, 50, 100, and 200.

### Utility functions

The `utilities/` directory contains standalone functions that can be sourced individually. Note that `boot_dKS.R` and `estWeibullChiSq.R` depend on `dWeibullAlt` or the local d/p/q/r discrete Weibull functions.

## Data

Precinct-level election data is from the [MIT Election Data and Science Lab](https://electionlab.mit.edu/data):
- 2016: [doi.org/10.7910/DVN/LYWX3D](https://doi.org/10.7910/DVN/LYWX3D)
- 2020: [doi.org/10.7910/DVN/JXPREB](https://doi.org/10.7910/DVN/JXPREB)
