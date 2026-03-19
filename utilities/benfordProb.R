# benford probability of digit d in the nth place

bProb = function(d, n){
  lb = 10^(n-2)
  ub = 10^(n-1)-1
  s = 0
  for (k in lb:ub){
    s = s + log10((10*k+d+1)/(10*k+d))
  }
  return(s)
}