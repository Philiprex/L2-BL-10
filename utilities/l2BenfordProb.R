# the joint benford probability of digits d1 and d2 being in the nth and (n+1)st place

l2bProb = function(n, d1, d2){
  # if n==1, no summation is needed. Note, if n==1, d1 should not equal 0
  if (n==1){
    return(log10(1+1/(10*d1+d2)))
  }
  # if n!=1, see Eigen et al. 2026, Equation 4.3
  lb = 10^(n-2)
  ub = 10^(n-1)-1
  s = 0
  for (k in lb:ub){
    s = s + log10(1+1/(100*k+10*d1+d2))
  }
  return(s)
}