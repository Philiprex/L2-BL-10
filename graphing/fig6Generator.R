library(tidyverse)
library(cowplot)

pList = list()
i = 1

for(n in c(25, 50, 100, 200)){
  pData = read.csv(paste0("../weibullSimulations/weibullSimulation_", n, ".csv")) %>%
    mutate(colGroup = ifelse(ChiSq.P*n()<=0.05, "red", ifelse(ChiSq.P<=0.1, "orange", "blue")),
           shapeGroup = ifelse(ChiSq.P*n()<=0.05, "diamond", ifelse(ChiSq.P<=0.1, "square", "circle")))

  cols = c("red"="red", "orange"="orange", "blue"="blue")
  shps = c("diamond"=23, "square"=22, "circle"=21)

  p=ggplot(pData) +
    geom_point(aes(x=Sigma, y=Mu, color=colGroup, fill=colGroup, shape=shapeGroup)) +
    scale_color_manual(values=cols, aesthetics="color") +
    scale_fill_manual(values=cols, aesthetics="fill") +
    scale_shape_manual(values=shps, aesthetics="shape") +
    scale_y_continuous(limit=c(1,10), breaks=seq(2,10,2)) +
    scale_x_continuous(limit=c(0.1,2), breaks=seq(0.4, 2, 0.4)) +
    ggtitle(paste0("n = ", n)) + 
    theme(legend.position = "none",
          plot.title = element_text(hjust = 0.5, size = 10))

  pList[[i]]=p
  i = i+1
}

p = plot_grid(plotlist=pList, ncol=4, nrow=1)

plot(p)

ggsave("Fig6.pdf", p, height=2, width=8, unit="in")
ggsave("Fig6.eps", p, height=2, width=8, unit="in")
