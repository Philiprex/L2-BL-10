# YOU MUST setwd() TO THE DIRECTORY CONTAINING THIS FILE
# this file is to take the data from ~/2016Data and retrieve only the data used in the project

library(tidyverse)

allData = readRDS("elecData2016.rds")

relData = allData %>%
  filter(candidate_normalized %in% c("clinton", "trump"),
         state_postal %in% c("FL", "PA", "TN", "NE", "MO", "MD"),
         !(precinct %in% c("total", "Total"))) %>%
  select(c("state", "state_postal", "county_name", "precinct", "candidate", "candidate_normalized", "mode", "votes")) %>%
  mutate(state = state_postal) %>%
  group_by(state, state_postal, county_name, precinct, candidate, candidate_normalized) %>%
  summarise(votes = sum(votes))


relDataAbs = allData %>%
  filter(candidate_normalized %in% c("clinton", "trump"),
         state_postal %in% c("GA", "NY", "WA"),
         !(precinct %in% c("total", "Total"))) %>%
  select(c("state", "state_postal", "county_name", "precinct", "candidate", "candidate_normalized", "mode", "votes")) %>%
  mutate(state = state_postal) %>%
  group_by(state, state_postal, county_name, precinct, candidate, candidate_normalized) %>%
  summarise(votes = sum(votes))

relData = rbind(relData, relDataAbs)

saveRDS(relData, "relData2016.rds")