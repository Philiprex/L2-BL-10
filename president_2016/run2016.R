# YOU MUST setwd() TO president_2016

library(tidyverse)
library(dWeibullAlt)

source("../utilities/param_fitter.R")
source("../utilities/boot_dKS.R")
source("../utilities/estWeibullChiSq.R")

elecData = readRDS("relData2016.rds")

# for each state-county-candidate we preform L2-BL 10 analysis and add it as one row in a df for the whole election
for (s in unique(elecData$state_postal)){
  print(paste(s, " Start"))

  sData = filter(elecData, state_postal == s)
  nCounties = n_distinct(sData$county_name, sData$candidate)
  cCount = 1

  resultsMat = matrix(nrow = n_distinct(elecData$state_postal, elecData$county_name)*2, ncol = 11)
  i = 1

  for (c in unique(sData$county_name)){
    cData = filter(sData, county_name == c)
    for (cand in unique(cData$candidate)){
      print(paste0(cCount, "/", nCounties))
      cCount = cCount+1

      # this is all the data for the state-county-candidate
      candData = filter(cData, candidate == cand)
      voteVec = candData$votes
      n = length(voteVec)

      if (n < 5){
        row = c(c(s, c, cand, n), rep(0, 7))
      } else {
        matchCount = sum(as.numeric(((voteVec %% 100) %% 11)==0)) # no. of matched last-two-digit pairs
        nonMatchCount = n - matchCount                            # no. of non-matched last-two-digit pairs

        chisq.p = chisq.test(c(matchCount, nonMatchCount), p=c(0.1, 0.9))$p.value # the chi-sq p-value for the observed data

        weibullResults = fit_weibull(voteVec, getSE = T) # this fits a discrete weibull to the vote counts with MLE and adds mu, mu.se, sigma, and sigma.se to the environment
        mu = weibullResults[1]
        mu.se = weibullResults[2]
        sigma = weibullResults[3]
        sigma.se = weibullResults[4]

        ks.p = bootstrap_dKS(voteVec, mu, sigma, b=1000) # given voteVec -- the vote counts -- and estimated discrete weibull parameters mu and sigma, returns bootstrap (b=1000 bootstrap samples), two-sided, discrete KS goodness of fit test p-values

        fittedChiSqP = weibullChiSq(mu, sigma, n, p=0.1, b=100) # gives the monte carlo p-value for fitted-distributional conformity to L2-BL 10

        row = c(s, c, cand, n, chisq.p, mu, mu.se, sigma, sigma.se, ks.p, fittedChiSqP)
      }
      resultsMat[i,] = row
      i = i+1
    }
  }

  resultsDF = data.frame(resultsMat) %>%
    mutate(across(4:11, ~ as.numeric(.x)))
  names(resultsDF) = c("State", "County", "Candidate", "N", "ChiSq.P", "Mu", "Mu.SE", "Sigma", "Sigma.SE", "KS.P", "Fit.ChiSq.P")
  resultsDF = filter(resultsDF, is.na(State)==F)

  saveRDS(resultsDF, paste0("2016", s, "Results.rds"))

  print(paste(s, " Done"))

}
