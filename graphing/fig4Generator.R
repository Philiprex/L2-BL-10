library(tidyverse)
library(cowplot)

edata = readRDS("../president_2016/2016ResultsBF.rds")

candName = c("Donald Trump", "Hillary Clinton")
cand = c("trump", "clinton")
stateabb = c("NY", "WA", "GA")

gridPoints = data.frame(Sigma=rep(c(0.2,0.6,1,1.4,1.8), 5),
                         Mu=c(rep(8,5),
                                 rep(7,5),
                                 rep(6, 5),
                                 rep(5, 5),
                                 rep(4, 5)))

plotList = list()
i = 1

for (c in 1:2){
  for (s in 1:3){
    wdata = filter(edata, Candidate == candName[c] & State == stateabb[s]) %>%
      filter(rowSums(across(5:11)) != 0) %>%
      mutate(colGroup = ifelse(KS.P<=0.05, "darkred", "blue"),
             fillGroup = ifelse(KS.P<=0.05, "darkred", "transparent")) %>%
      arrange(colGroup)

    p = ggplot(wdata, aes(x=Sigma, y=Mu)) +
      geom_point(aes(x=Sigma, y=Mu), data=gridPoints, color="#828282", shape=8, size=1) +
      geom_point(aes(color=colGroup, fill=fillGroup), shape=21, stroke=0.2) +
      scale_x_continuous(limit=c(0,1.8), breaks=seq(0.2,1.8,0.4)) +
      scale_y_continuous(limit=c(3, 8)) +
      scale_color_identity() +
      scale_fill_identity() +
      labs(title=paste0(candName[c], ", ", stateabb[s]), x="Sigma", y="Mu") +
      theme(
        plot.title=element_text(size=11), 
        axis.title.y = element_text(angle = 90, vjust = 0.5),
        legend.position="none")

    plotList[[i]] = p
    i = i+1
  }
}

paramDists = plot_grid(plotlist=plotList, nrow=2, ncol=3)

plot(paramDists)

ggsave("Fig4.pdf", paramDists, width=7, height=4, unit="in")
ggsave("Fig4.eps", paramDists, width=7, height=4, unit="in")
