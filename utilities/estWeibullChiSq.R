# this function takes in parameters mu and sigma, sample size n, probability p, and sample count b.
# it returns the the p-value of 100 monte carlo simulations of the one df chi squared test given probability p
# and samples of size n taken from the discrete Weibull distribution as parameterized by mu and sigma
# NOTE: should be run in an environment that has sourced rdweibull.R or has imported dWeibullAlt package

weibullChiSq = function(mu, sigma, n, p = 0.1, b = 100){
  stats.ps = list()
  for (i in 1:b){
    samp = rdweibull(n, mu, sigma)

    sampMatchCount = sum(as.numeric(((samp %% 100) %% 11) == 0))
    sampNonMatchCount = n-sampMatchCount

    stats.ps[[i]] = chisq.test(c(sampMatchCount, sampNonMatchCount), p=c(p, (1-p)))$p.value
  }

  stats.p = mean(unlist(stats.ps))

  return(stats.p)
}