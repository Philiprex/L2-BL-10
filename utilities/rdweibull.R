# random sample of size n from discrete weibull distribution with parameters mu and sigma

rdweibull = function(n, mu, sigma){
  xGetter = function(x) qdweibull(x, mu, sigma)
  return(sapply(runif(n, 0, 1), xGetter))
}