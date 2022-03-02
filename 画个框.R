library(dplyr)
library(ggplot2)

rm(list = ls())

psypath <<- "./psy" # psy文件夹的位置
scale.factor <<- 2.45 #用来调整等焓线的角度，英文推荐2.53，中文推荐2.45

psypath %>% 
  paste("chart.R", sep = "/") %>% 
  source(encoding = "UTF-8")

df <- read.csv("./data/template.csv") %>% 
  mutate(B = 101325,
         d = cal.d_Ta.RH(Ta, RH, B),
         h = cal.h_Ta.d(Ta, d),
         y = cal.y(h, d))

zone1 <- data.frame(Ta = c(20,25,25,20), d = c(5,5,10,10)) %>% 
  mutate(h = cal.h_Ta.d(Ta, d),
         y = cal.y(h, d))


p <- draw_psy(linesize = 0.1) +
  geom_point(data = df, aes(x = d, y = y), size = 0.5) +
  geom_polygon(data = zone1, aes(x = d, y = y), alpha = 0.5, fill = "red") +
  theme(
    text = element_text(size = 7) #PPT用14，word用8
  ) +
  labs(x = expression(paste("含湿量/", " g·k",g[干空气]^-1)),
       y = expression(paste("干球温度/", degree, "C"))) 

p

plotpath <- "./plot" # 输出的图片位置
ggsave("焓湿图示例.png", plot = p, width = 140, height = 80, units = "mm", dpi = 1200, path = plotpath)
