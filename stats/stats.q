
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

\d .sq

// Return the geometric average of the array elements.
// That is: n-th root of (x1 * x2 * ... * xn)
gmean:{[datalist]
	N:count datalist;
	(prd datalist) xexp 1 % N
 };

// Calculate the harmonic mean along the specified axis.
// That is:  n / (1/x1 + 1/x2 + ... + 1/xn)
hmean:{[datalist]
	N:count datalist;
	N % sum (1 % datalist)
 };


// Calculate the nth moment about the mean for a sample
moment:{[datalist; n]
	(sum (datalist - avg datalist) xexp n) % count datalist
 };


//  Compute the trimmed mean.
//  This function finds the arithmetic mean of given values, ignoring values
//  outside the given limits.
tmean:{[datalist; limits]
	avg datalist where datalist within limits
 };


// Returns a list of the modal (most common) value(s)
mode:{[datalist]
	where (max C) = C:count each group datalist
 };


// Compute the trimmed variance.
// This function computes the sample variance of an array of values,
// while ignoring values which are outside of given `limits`.
// tvar computes the unbiased sample variance, i.e. it uses a correction
// factor `n / (n - 1)`
tvar: {[datalist;limits]
	N:count datalist;
	(N % N - 1) * svar datalist where datalist within limits
 };


// Compute the trimmed minimum.
// This function finds the miminum value of a list, but only considering
// values greater than a specified lower limit
tmin:{[datalist;lowermin]
	min datalist where datalist > lowermin
 };

// Compute the trimmed maximum.
// This function computes the maximum value of a list, while ignoring
// values larger than a specified upper limit.
tmax:{[datalist;uppermax]
	max datalist where datalist < uppermax
 };


// Compute the trimmed sample standard deviation.
// This function finds the sample standard deviation of given values,
// ignoring values outside the given `limits`.
tstd:tsdev:{[datalist;limits]
	/sdev datalist where datalist within limits
	sqrt tvar[datalist;limits]
 };


// Compute the trimmed standard error of the mean.
// This function finds the standard error of the mean for given
// values, ignoring values outside the given `limits`.
tsem:{[datalist;limits]
	N:count d:datalist where datalist within limits;
	(sdev d) % sqrt N
 };


// Compute the coefficient of variation, the ratio of the biased standard
// deviation to the mean.
variation:{[datalist]
	(sdev datalist) % avg datalist
 };


// Skew -- Scipy Version
// Compute the skewness of a data set.
// For normally distributed data, the skewness should be about 0. For
// unimodal continuous distributions, a skewness value > 0 means that
// there is more weight in the right tail of the distribution.
skew:{[datalist]
	N:count datalist;
	moment[datalist;3] % moment[datalist;2] xexp 1.5
 };


// Skew -- Alternate Version
// From https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm
skewness:{[datalist]
	N:count datalist;
	S:sdev datalist;
	datalist:sum (xexp[;3] datalist-avg datalist) % N;
	datalist % 3 xexp S
 };

// Skew -- Alternate version with adjustment
skewnessAdj:{[datalist]
	N:count datalist;
	(sqrt[N*N-1] % N-2) * skew[datalist]
 };






// Compute several descriptive statistics of the passed list.
describe:{[datalist]
	(!) . flip (
		( `$"NOBs (count)";  count datalist              );
		( `$"min-max";       (min datalist;max datalist) );
		( `mean;             avg datalist                );
		( `variance;         var datalist                );
		( `skewness;         skew[datalist]              )
		/ `kurtosis          kurtosis[datalist]
	)
 };


// Return a 2-D array of item frequencies
itemfreq:{[datalist]
	count each group datalist
 };


// Return a relative frequency histogram, using the histogram function.
// A relative frequency  histogram is a mapping of the number of
// observations in each of the bins relative to the total of observations.
relfreq:{[datalist]
	N:count datalist;
	(count each group datalist) % N
 };


// Calculate the standard error of the mean (or standard error of
// measurement) of the values in the input list
sem:{[datalist]
	(sdev datalist where datalist within limits) % sqrt N
 };



\d .
