# density function for discrete weibull distribution with parameters mu and sigma
# set type to 2 if inputting alpha/beta parameter values

ddweibull = function(x, mu, sigma, type = 1){
  if (type == 1){
    return(exp(-(x/exp(mu))^(1/sigma))-exp(-((x+1)/exp(mu))^(1/sigma)))
  } else {
    alpha = log(mu)
    beta = 1/sigma
    return(ddweibull(x, alpha, beta))
  }
}