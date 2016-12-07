library(ggplot2)
library(gtable)
library(grid)

test <- as.data.frame(read.csv("C:/Users/ragilbert/Desktop/listedArea.csv", header = TRUE))

# faceted
ggplot(data = test, aes(x = test$year, y = test$area_acres)) + geom_bar(alpha = 0.5, stat = "sum") + facet_wrap(~ family)

################
grid.newpage()

areaPlot <- geom_bar(data = test, aes(x = test$year, y = test$area_acres), alpha = 0.5, stat = "sum")
lengthPlot <- geom_jitter(data = test, aes(x = year, y = test$length_km), colour = "Red", alpha = 0.5)

g1 <- ggplot_gtable(ggplot_build(areaPlot))
g2 <- ggplot_gtable(ggplot_build(lengthPlot))

pp <- c(subset(g1$layout, name == "panel", se = t:r))
g <- gtable_add_grob(g1, g2$grobs[[which(g2$layout$name == "panel")]], pp$t, pp$l, pp$b, pp$l)

# extract gtable
g1 <- ggplot_gtable(ggplot_build(p1))
g2 <- ggplot_gtable(ggplot_build(p2))

# overlap the panel of 2nd plot on that of 1st plot
pp <- c(subset(g1$layout, name == "panel", se = t:r))
g <- gtable_add_grob(g1, g2$grobs[[which(g2$layout$name == "panel")]], pp$t, 
                     pp$l, pp$b, pp$l)

# axis tweaks
ia <- which(g2$layout$name == "axis-l")
ga <- g2$grobs[[ia]]
ax <- ga$children[[2]]
ax$widths <- rev(ax$widths)
ax$grobs <- rev(ax$grobs)
ax$grobs[[1]]$x <- ax$grobs[[1]]$x - unit(1, "npc") + unit(0.15, "cm")
g <- gtable_add_cols(g, g2$widths[g2$layout[ia, ]$l], length(g$widths) - 1)
g <- gtable_add_grob(g, ax, pp$t, length(g$widths) - 1, pp$b)

# draw it
grid.draw(g)