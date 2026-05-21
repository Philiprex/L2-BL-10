# YOU MUST setwd() TO weibullSimulations

library(tidyverse)
library(KSgeneral)

source("../utilities/ddweibull.R")
source("../utilities/pdweibull.R")
source("../utilities/qdweibull.R")
source("../utilities/rdweibull.R")
source("../utilities/param_fitter.R")
source("../utilities/estWeibullChiSq.R")

ns = c(25,50,100,200)
mus = seq(1, 10, 1)
sigmas = seq(0.1, 2, 0.1)

set.seed(1234)

for (n in ns){
  simOutputs = matrix(nrow = length(mus)*length(sigmas), ncol = 3)
  print(nrow(simOutputs))
  c=1
  for (m in mus){
    for (s in sigmas){
      
      chisq.p = weibullChiSq(m, s, n)
        
      row = c(m, s, chisq.p)
      simOutputs[c,] = row
      print(c)
      c = c+1
      }
  }

  simOutputsDF = data.frame(simOutputs) %>%
    mutate(across(1:3, ~ as.numeric(.x)))
  names(simOutputsDF) = c("Mu", "Sigma", "ChiSq.P")

  fname = paste0("weibullSimulation_", n, ".csv")
  write.csv(simOutputsDF, fname, row.names = F)
}