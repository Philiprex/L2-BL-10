# fit discrete weibull distribution to dataVec (numeric)
# set getSE to TRUE to have standard error returned
# NOTE: should be run in an environment that has sourced ddweibull.R or has imported dWeibullAlt package

fit_weibull = function(dataVec, getSE = F){
  # maximizes joint log-likelihood
  getD = function(params) -sum(log(ddweibull(dataVec, params[1], params[2])+.Machine$double.eps))
  fitResults = optim(c(5, 0.75), getD, lower=list(-300, 1e-10), method = "L-BFGS-B", hessian = T)

  # extract estimated mu and sigma
  mu = fitResults$par[1]
  sigma = fitResults$par[2]
  

  # if getSE==T, extract standard errors of mu and sigma from inverse Fisher information matrix
  if (getSE){
    sem = solve(fitResults$hessian)
    mu.se = sqrt(sem[1,1])
    sigma.se = sqrt(sem[2,2])
    # return parameters and SEs
    return(c(mu, mu.se, sigma, sigma.se))
  }

  # return parameters
  return(c(mu, sigma))

}