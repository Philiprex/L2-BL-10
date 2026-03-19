# returns vector of digit probabilities in nth position under Benford's Law
source("../utilities/benfordProb.R")

bDist = function(n){
  if (n>1){
    digits = 0:9
    getBProb = function(x) bProb(x, n)
    bdist = sapply(digits, getBProb)
  } else {
    digits = 1:9
    bdist = c(0, sapply(digits, function(x) log10(1+1/x)))
  }
  return(bdist)
}