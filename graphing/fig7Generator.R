library(tidyverse)
library(cowplot)

pList = list()

for (y in c(2016,2020)){
  relData = readRDS(paste0("../president_", y, "/relData", y, ".rds")) %>%
    group_by(state, county_name, candidate) %>%
    summarize(precinctN = n()) %>%
    ungroup()
  p = ggplot(relData) +
    geom_histogram(aes(x=precinctN), color="black", fill="lightblue", binwidth=25) +
    scale_x_continuous(limit=c(0,1000), breaks=c(seq(0,1000,200))) +
    labs(x="Number of Precincts", y="Count", title=y) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 10),
      panel.grid.minor.x = element_blank())
  i = ifelse(y==2016, 1, 2)
  pList[[i]] = p
}

p=plot_grid(plotlist=pList)

plot(p)

ggsave("Fig7.pdf", p, width=4.5, height=2.5, unit="in")
ggsave("Fig7.eps", p, width=4.5, height=2.5, unit="in")
