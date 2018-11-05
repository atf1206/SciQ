
/
# Copyright 2018 Andrew Fritz

These functions are adaptations of statistical functions provided for
SciPy (https://github.com/scipy/scipy/blob/master/scipy/stats/stats.py), 
a statistical package for Python. 

This package includes the comments below, equally applicable here:


A collection of basic statistical functions for Python.  The function
names appear below.

Disclaimers:  The function list is obviously incomplete and, worse, the
functions are not optimized.  All functions have been tested (some more
so than others), but they are far from bulletproof.  Thus, as with any
free software, no warranty or guarantee is expressed or implied. :-)  A
few extra functions that don't appear in the list below can be found by
interested treasure-hunters.  These functions don't necessarily have
both list and array versions but were deemed useful.

Central Tendency
----------------
.. autosummary::
   :toctree: generated/
    gmean
    hmean
    mode
Moments
-------
.. autosummary::
   :toctree: generated/
    moment
    variation
    skew
    kurtosis
    normaltest
Altered Versions
----------------
.. autosummary::
   :toctree: generated/
    tmean
    tvar
    tstd
    tsem
    describe
Frequency Stats
---------------
.. autosummary::
   :toctree: generated/
    itemfreq
    scoreatpercentile
    percentileofscore
    cumfreq
    relfreq
Variability
-----------
.. autosummary::
   :toctree: generated/
    obrientransform
    sem
    zmap
    zscore
    iqr
Trimming Functions
------------------
.. autosummary::
   :toctree: generated/
   trimboth
   trim1
Correlation Functions
---------------------
.. autosummary::
   :toctree: generated/
   pearsonr
   fisher_exact
   spearmanr
   pointbiserialr
   kendalltau
   weightedtau
   linregress
   theilslopes
Inferential Stats
-----------------
.. autosummary::
   :toctree: generated/
   ttest_1samp
   ttest_ind
   ttest_ind_from_stats
   ttest_rel
   chisquare
   power_divergence
   ks_2samp
   mannwhitneyu
   ranksums
   wilcoxon
   kruskal
   friedmanchisquare
   brunnermunzel
   combine_pvalues
Statistical Distances
---------------------
.. autosummary::
   :toctree: generated/
   wasserstein_distance
   energy_distance
ANOVA Functions
---------------
.. autosummary::
   :toctree: generated/
   f_oneway
Support Functions
-----------------
.. autosummary::
   :toctree: generated/
   rankdata

References
----------
.. [CRCProbStat2000] Zwillinger, D. and Kokoska, S. (2000). CRC Standard
   Probability and Statistics Tables and Formulae. Chapman & Hall: New
   York. 2000.
\


// Calculate the nth moment about the mean for a sample
moment:{[datalist; n]
	(sum (datalist - avg datalist) xexp n) % count datalist
 };


// Scipy Version
skew:{[datalist]
	N:count datalist;
	moment[datalist;3] % moment[datalist;2] xexp 1.5
 };

// Alternate Version
// From https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm
skewness:{[datalist]
	N:count datalist;
	S:sdev datalist;
	datalist:sum (xexp[;3] datalist-avg datalist) % N;
	datalist % 3 xexp S
 };

// Alternate version with adjustment
skewnessAdj:{[datalist]
	N:count datalist;
	(sqrt[N*N-1] % N-2) * skew[datalist]
 };

