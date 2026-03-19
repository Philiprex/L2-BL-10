# YOU MUST setwd() TO THE DIRECTORY CONTAINING THIS FILE
# this file is to take the data from ~/2020Data and retrieve only the data used in the project

library(tidyverse)

allData = readRDS("elecData2020.rds")

relData = allData %>%
  filter(dataverse == "PRESIDENT",
         candidate %in% c("JOSEPH R BIDEN", "DONALD J TRUMP"),
         state_po %in% c("FL", "PA", "TN", "NE", "MO", "WA"),
         mode %in% c("ELECTION DAY", "TOTAL", "HAND COUNTED", "ADVANCED VOTING"),
         precinct != "ABSENTEE") %>%
  select(c("state_po", "county_name", "precinct", "candidate", "mode", "votes")) %>%
  group_by(state_po, county_name, precinct, candidate) %>%
  summarise(votes = sum(votes)) %>%
  data.frame() %>%
  mutate(candidate_normalized = candidate) %>%
  mutate(candidate_normalized = ifelse(candidate_normalized == "DONALD J TRUMP", "trump", "biden"),
         state = state_po)

relDataAbs = allData %>%
  filter(dataverse == "PRESIDENT",
         candidate %in% c("JOSEPH R BIDEN", "DONALD J TRUMP"),
         state_po %in% c("GA", "MD", "NY"),
         precinct != "ABSENTEE") %>%
  select(c("state_po", "county_name", "precinct", "candidate", "mode", "votes")) %>%
  group_by(state_po, county_name, precinct, candidate) %>%
  summarise(votes = sum(votes)) %>%
  data.frame() %>%
  mutate(candidate_normalized = candidate) %>%
  mutate(candidate_normalized = ifelse(candidate_normalized == "DONALD J TRUMP", "trump", "biden"),
         state = state_po)

relData = rbind(relData, relDataAbs)

saveRDS(relData, "relData2020.rds")