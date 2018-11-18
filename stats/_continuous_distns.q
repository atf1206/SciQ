



// Normal distribution

/ loc = mu, scale = std
/ Keep these implementations out of the class definition so they can be reused
/ by other distributions.
norm_pdf_C:sqrt 2 * pi;
norm_pdf_logC:log norm_pdf_C;
pi:3.14159265359;

norm_pdf:{[x]
	((exp -x xexp 2) % 2) % norm_pdf_C
 };


norm_logpdf:{[x]
    ((-x xexp 2) % 2) - _norm_pdf_logC
 };

/
def _norm_cdf(x):
    return sc.ndtr(x)


def _norm_logcdf(x):
    return sc.log_ndtr(x)


def _norm_ppf(q):
    return sc.ndtri(q)


def _norm_sf(x):
    return _norm_cdf(-x)


def _norm_logsf(x):
    return _norm_logcdf(-x)


def _norm_isf(q):
return -_norm_ppf(q)
