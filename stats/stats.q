
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


// Compute the kurtosis (Fisher or Pearson) of a dataset.
// Kurtosis is the fourth central moment divided by the square of the
// variance. Default is Fisher (subtract 3 from result).
kurtosis:{[datalist]
	-3 + moment[datalist;4] % (var datalist) xexp 2
 };


// Test whether the skew is different from the normal distribution.
// This function tests the null hypothesis that the skewness of
// the population that the sample was drawn from is the same
// as that of a corresponding normal distribution.

// Notes
// -----
// The sample size must be at least 8.

skewtest:{[datalist]
	if[8 > N:count datalist;:`$"error - sample size must be at least 8"];
	b2:skew[datalist];
	y:b2 * sqrt (N+1) * (N + 3) % (6 * N - 2);
	beta2:3 * (((N xexp 2) + (27 * N) - 70) * (N+1) * (N + 3)) % (N - 2) * (N + 5) * (N + 7) * (N + 9);
	W2:-1 + sqrt 2 * beta2 - 1;
	delta:reciprocal sqrt 0.5 * log W2;
	alpha:sqrt 2.0 % W2 - 1;
	y:$[y=0f;1f;y];
	Z: delta * log (y % alpha) + sqrt 1 + (y % alpha) xexp 2;
	`Z`pvalue!(Z;`nyi)
 };


// Compute several descriptive statistics of the passed list.
describe:{[datalist]
	(!) . flip (
		( `$"NOBs (count)";  count datalist              );
		( `$"min-max";       (min datalist;max datalist) );
		( `mean;             avg datalist                );
		( `variance;         var datalist                );
		( `skewness;         skew[datalist]              );
		( `kurtosis          kurtosis[datalist]          )
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


// Slices off the passed proportion of items from both ends of the passed
// array (i.e., with `proportiontocut` = 0.1, slices leftmost 10% **and**
// rightmost 10% of scores). The trimmed values are the lowest and
// highest ones.
// Slices off less if proportion results in a non-integer slice index (i.e.,
// conservatively slices off`proportiontocut`).
trimboth:{[datalist;proportiontotrim]
	N:count datalist;
	ntrim:floor N * proportiontotrim;
	(neg ntrim) _ ntrim _ asc datalist
 };


// Slices off a proportion from ONE end of the passed array distribution.
// If `proportiontocut` = 0.1, slices off 'leftmost' or 'rightmost'
// 10% of scores. The lowest or highest values are trimmed (depending on
// the tail).
// Slices off less if proportion results in a non-integer slice index
// (i.e., conservatively slices off `proportiontocut` ).
trim1:{[datalist;proportiontotrim;side]
	N:count datalist;
	ntrim:floor N * proportiontotrim;
	$[side=`r;(neg ntrim);ntrim] _ asc datalist
 };


// Return mean of array after trimming distribution from both tails.
// If `proportiontocut` = 0.1, slices off 'leftmost' and 'rightmost' 10% of
// scores. The input is sorted before slicing. Slices off less if proportion
// results in a non-integer slice index (i.e., conservatively slices off
// `proportiontocut` ).
trim_mean:{[datalist;proportiontotrim]
	avg trimboth[datalist;proportiontotrim]
 };


// Calculate a Pearson correlation coefficient and the p-value for testing
// non-correlation.

// The Pearson correlation coefficient measures the linear relationship
// between two datasets. Strictly speaking, Pearson's correlation requires
// that each dataset be normally distributed, and not necessarily zero-mean.
// Like other correlation coefficients, this one varies between -1 and +1
// with 0 implying no correlation. Correlations of -1 or +1 imply an exact
// linear relationship. Positive correlations imply that as x increases, so
// does y. Negative correlations imply that as x increases, y decreases.

// The p-value roughly indicates the probability of an uncorrelated system
// producing datasets that have a Pearson correlation at least as extreme
// as the one computed from these datasets. The p-values are not entirely
// reliable but are probably reasonable for datasets larger than 500 or so.
pearson:{[datalist1;datalist2]
	d1:datalist1 - avg datalist1;
	d2:datalist2 - avg datalist2;
	(sum d1 * d2) % sqrt (sum d1 xexp 2) * (sum d2 xexp 2)
 };

// Calculates a Pearson correlation for a population (instead of a sample -
// see https://en.wikipedia.org/wiki/Pearson_correlation_coefficient )
pearsonPopulation:{[datalist1;datalist2]
	(datalist1 cov datalist2) % (sdev datalist1) * (sdev datalist2)
 };


// Find repeats and repeat counts.
find_repeats:{[datalist]
	w!c w:(),where 1 < c:count each group datalist
 };



\d .
