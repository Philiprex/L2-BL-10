source("../utilities/benfordDist.R")

library(tidyverse)
library(scales)

digs = data.frame(digit = factor(c(rep("First Digit", 10), rep("Second Digit", 10), rep("Third Digit", 10), rep("Fourth Digit", 10)), levels=c("First Digit", "Second Digit", "Third Digit", "Fourth Digit")),
                  digitPlace = c(rep(0:9, 4)),
                  digitProb = c(c(0, bDist(1)[2:10]), bDist(2), bDist(3), bDist(4)))

p = ggplot(digs, aes(x=digitPlace, y=digitProb)) +
  geom_bar(stat="identity", fill="darkblue") +
  facet_wrap(~ digit, scales="free_x") +
  scale_x_continuous(breaks=c(0:9)) +
  scale_y_continuous(labels=label_percent(), limit=c(0,0.35)) +
  labs(x="Digit", y="Relative Frequency") +
  theme(
    axis.title = element_text(size=10, face="bold"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )

plot(p)

ggsave("Fig2.pdf", p, width=4.49, height=3.3, unit="in")
ggsave("Fig2.eps", p, width=4.49, height=3.3, unit="in")
