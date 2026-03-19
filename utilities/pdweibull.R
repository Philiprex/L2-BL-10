# distribution function for discrete weibull distribution with parameters mu and sigma
# set lower.tail to FALSE for upper-tail probability

pdweibull = function(x, mu, sigma, type = 1, lower.tail = T){
  if (type==1){
    if (lower.tail){
      return(1-exp(-exp(((log(x+1)-mu)/sigma))))
    } else {
      return(exp(-exp(((log(x+1)-mu)/sigma))))
    }
  } else {
    alpha = log(mu)
    beta = 1/sigma
    return(pdweibull(x, alpha, sigma, type = 1, lower.tail = lower.tail))
  }
}