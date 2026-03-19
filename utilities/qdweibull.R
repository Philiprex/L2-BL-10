# inverse distribution function for discrete weibull distribution with parameters mu and sigma
# set lower.tail to FALSE for upper-tail probability

qdweibull = function(p, mu, sigma, lower.tail = T){
  if (lower.tail){
    return(ceiling((-log(1-p))^sigma * exp(mu)-1))
  } else {
    p = 1-p
    return(floor((-log(1-p))^sigma * exp(mu)-1))
  }
}