source("../utilities/benfordDist.R")

library(tidyverse)
library(scales)

# figure 1
firstD = bDist(1)[2:10]
firstDigit = data.frame(Digit=c(1:9), Probs=firstD)

p = ggplot(firstDigit, aes(x=Digit, y=Probs)) +
  geom_bar(stat="identity", fill="darkblue") +
  geom_text(aes(label=paste0(round(Probs*100, 2), "%"), vjust= -0.5, hjust=0.4), size=3.5) +
  scale_x_continuous(breaks=c(1:9)) +
  scale_y_continuous(labels=label_percent(), limit=c(0,0.35)) +
  labs(x="Digit", y="Relative Frequency") +
  theme(
    axis.title = element_text(size=12, face="bold"),
    axis.text = element_text(size=10),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )

plot(p)

ggsave("Fig1.pdf", p, width=6, height=2.5, unit="in")
ggsave("Fig1.eps", p, width=6, height=2.5, unit="in")
