# compile results
elecData = readRDS("relData2016.rds")

dlist = list()
i = 1
for (s in unique(elecData$state_postal)){
  fname = paste0("2016", s, "Results.rds")
  f = readRDS(fname) %>%
    filter(!(is.na(State)) & N>=5)
  dlist[[i]] = f
  i = i+1
}

rd = data.frame(dlist[[1]])
for (i in 2:length(dlist)){
  rd  = rbind(rd, dlist[[i]])
}

saveRDS(rd, "2016Results.rds")


# perform Bonferroni adjustments
rd2016 = rd %>% # bonferoni
  group_by(State, Candidate) %>%
  mutate(BF.p = ChiSq.P*n(),
         F.BF.p = Fit.ChiSq.P*n()) %>%
  ungroup()

saveRDS(rd2016, "2016ResultsBF.rds")


# get fully flagged counties
rd2016Filt = rd2016 %>%
  filter(BF.p <= 0.05 & KS.P>0.05 & F.BF.p > 0.05) %>%
  select(c(State, Candidate, County, N, BF.p, Mu, Mu.SE, Sigma, Sigma.SE, KS.P, F.BF.p)) %>%
  mutate(County = str_sub(County, end=-7),
         Candidate=recode(Candidate, "trump"="Trump", "clinton"="Clinton"),
         BF.p = round(BF.p, 4),
         Mu = round(Mu, 4),
         Mu.SE = round(Mu.SE, 4),
         Sigma = round(Sigma, 4),
         Sigma.SE = round(Sigma.SE, 4),
         KS.P = round(KS.P, 4),
         F.BF.p = round(F.BF.p, 4)) %>%
  arrange(State, Candidate)

saveRDS(rd2016Filt, "fullFlags2016.rds")
write.csv(rd2016Filt, "fullFlags2016.csv", row.names=F)


# get cross-tabs
rd2016ContBF = rd2016 %>% # 3-way contingency table after bonferroni
  mutate(Observed=ifelse(BF.p<=0.05, "Non-Conforming", "Conforming"),
         GOF=ifelse(KS.P>0.05, "Well Fit", "Poorly Fit"), 
         Fitted=ifelse(F.BF.p>0.05, "Conforming", "Non-Conforming")) %>%
  select(c(Observed, GOF, Fitted))

ftable(addmargins(xtabs(~ GOF + Fitted + Observed, data = rd2016ContBF)))
