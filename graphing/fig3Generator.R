library(tidyverse)
library(dWeibullAlt)


gData = readRDS("../president_2016/2016Results.rds") %>%
  filter((County=="Fulton County" & State=="GA") | (County=="Genesee County" & State=="NY") | (County=="Walla Walla County" & State=="WA")) %>%
  mutate(Candidate=recode(Candidate, "trump"="Donald Trump", "clinton"="Hillary Clinton"),
         County = str_sub(County, end=-8))

vData = readRDS("../president_2016/relData2016.rds") %>%
  filter((county_name=="Fulton County" & state_postal=="GA") | (county_name=="Genesee County" & state_postal=="NY") | (county_name=="Walla Walla County" & state_postal=="WA")) %>%
  mutate(Candidate = candidate, County = str_sub(county_name, end=-8))


pData = data.frame()
for (cand in c("Donald Trump", "Hillary Clinton")){
  for (county in c("Fulton", "Genesee", "Walla Walla")){
    ccECDF = ecdf(filter(vData, County==county & Candidate==cand)$votes)
    gccED = function(x){return(ccECDF(x+32)-ccECDF(x))}
    ccMu = filter(gData, County==county & Candidate==cand)$Mu[1]
    ccSigma = filter(gData, County==county & Candidate==cand)$Sigma[1]
    gccDensity = function(x){return(pdweibull(x+32, ccMu, ccSigma)-pdweibull(x, ccMu, ccSigma))}
    idx = seq(0,800,32)
    ccDF = data.frame(idx=idx, 
                      candidate=rep(cand, length(idx)), 
                      county=rep(county, length(idx)),
                      eProb=gccED(idx),
                      tProb=gccDensity(idx))
    pData = rbind(pData, ccDF)
  }
}


p=ggplot(pData) +
  geom_col(aes(x=idx, y=eProb), color="black", fill="lightblue", linewidth=0.3, position = position_nudge(16)) +
  geom_col(aes(x=idx, y=tProb), color="red", fill=NA, linewidth=0.4, position = position_nudge(16)) +
  facet_grid(county~candidate, scales="free_y") +
  scale_x_continuous(limit=c(0,800)) +
  labs(x="Votes", y="Density") +
  theme_bw() +
  theme(
    axis.title = element_text(size=12, face="bold"),
    panel.grid.major.x = element_blank()
  )

plot(p)

ggsave("Fig3.pdf", p, width=5.5, height=3.5, unit="in")
ggsave("Fig3.eps", p, width=5.5, height=3.5, unit="in")
