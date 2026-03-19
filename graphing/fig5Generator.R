library(tidyverse)
library(cowplot)
library(magick)

source("../utilities/pdweibull.R")

pList = list()
i = 1

for (mu in c(8,7,6,5,4)){
  for (sigma in c(0.2,0.6,1,1.4,1.8)){

    gccDensity = function(x){return(pdweibull(x+32, mu, sigma)-pdweibull(x, mu, sigma))}
    idx = seq(0,800,32)

    ccDF = data.frame(idx=idx, 
                      tProb=gccDensity(idx))
    
    p=ggplot(ccDF) +
      geom_col(aes(x=idx, y=tProb), color="red", fill=NA, linewidth=0.4, position = position_nudge(16)) +
      scale_x_continuous(limit=c(0,800), breaks=seq(0,800,400)) +
      scale_y_continuous(n.breaks=3) +
      labs(x=NULL, y=NULL, title=paste0("\U03BC = ", mu, ", \U03C3 = ", sigma)) +
      theme_bw() +
      theme(plot.title = element_text(hjust = 0.5, size = 8))

    pList[[i]] = p
    i = i+1
  }
}


p = plot_grid(plotlist=pList, nrow=5, ncol=5)

plot(p)

# This is required to properly render mu and sigma characters. The issue is related to rendering engines when working on Mac
ggsave("Fig5.png", p, height=4, width=6, unit="in")
image_write(image_read("Fig5.png"), format="pdf", path="Fig5.pdf")
image_write(image_read("Fig5.png"), format="eps", path="Fig5.eps")
