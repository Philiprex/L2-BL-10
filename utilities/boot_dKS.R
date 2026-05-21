# this file provides bootstrap_dks which takes in a vector of value, a mu and sigma parameter, and a number b.
# it returns the p-value for the parametric bootstrap, one-sided, two-tailed, discrete KS test with a null
# distribution of the discrete Weibull as parameterized with mu and sigma

library(KSgeneral)
library(dWeibullAlt)

get_dKS_stat = function(dataVec, m, s){
  support = 0:(max(dataVec)+1)
  vals = c(0, pdweibull(0:max(dataVec), m, s), 1)

  estCDF = stepfun(support, vals)

  # this implementation of calculation for the d-KS test statistic comes from disc_ks_test in KSgeneral (https://github.com/d-dimitrova/KSgeneral)
  x = dataVec
  y = estCDF
  z = knots(y)
  dev <- c(0, ecdf(x)(z) - y(z))
  STATISTIC <- max(abs(dev))
  return(STATISTIC)
}

# takes a sample from discrete weibull with parameters mu and sigma of size n, fits a new weibull to it, return sample and new weibull info
sampFitter = function(n, mu, sigma){
  tryCatch(
    {samp = rdweibull(n, mu, sigma)
    fitInfo = fit_weibull(samp)
    return(list(samp, fitInfo))},
    error = function(e){
      return(sampFitter(n, mu, sigma))
    }
  )
}

# calculates bootstrap two-sided disctete KS p-value for goodness of fit between data oVec and a discrete weibull distribution with parameters mu and sigma
bootstrap_dKS = function(oVec, mu, sigma, b=1000){
  n = length(oVec)
  # dKS statistic of original data, oVec
  oDStat = get_dKS_stat(oVec, mu, sigma)
  Dlist = list()

  # takes b samples from the distribution, fits another distribution to each, and returns the dKS test statistics
  for (i in 1:b){
    bsData = sampFitter(n, mu, sigma)
    samp = bsData[[1]]
    fitInfo = bsData[[2]]
    sMu = fitInfo[1]
    sSigma = fitInfo[2]
    sDStat = get_dKS_stat(samp, sMu, sSigma)
    Dlist[[i]] = sDStat
  }

  dEDF = ecdf(unlist(Dlist))

  # empirical probability of original dKS test statistic
  return(1-dEDF(oDStat))

}