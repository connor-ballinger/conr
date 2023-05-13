#
# library(tidyverse)
#
# cost <- rnorm(n = 100, mean = 1000, sd = 500)
# u <- rnorm(100, 3, 3)
#
# df <- tibble(cost, u)
#
# # clockwise
# tr <- nrow(df[df$qaly > 0 & df$cost > 0,]) / B
# br <- nrow(df[df$qaly > 0 & df$cost < 0,]) / B
# bl <- nrow(df[df$qaly < 0 & df$cost < 0,]) / B
# tl <- nrow(df[df$qaly < 0 & df$cost > 0,]) / B
#
# quad_portions <- map(c(tr, br, bl, tl), .f = \(x) scales::label_percent()(x))
#
#
#
#
#
# icer_plot <- ggplot(data = df) +
#   geom_point(aes(x = qaly, y = cost)) +
#   geom_point(aes(x = unadjusted_qaly, y = unadjusted_cost), colour = "green", size = 5) +
#   geom_point(aes(x = adj_effect, y = adj_cost), colour = "blue", size = 5) +
#   geom_abline(slope = 30000, linewidth = 0.8) +
#   geom_vline(xintercept = 0, colour = "grey") +
#   geom_hline(yintercept = 0, colour = "grey") +
#   theme(panel.grid = element_blank()) +
#   labs(x = "Incremental QALYs", y = "Incremental Cost") +
#   scale_y_continuous(labels = scales::label_dollar()) +
#   annotate("text", x = -0.02, y = 5000,  label = quad_portions[[1]], fontface = "bold") +
#   annotate("text", x = -0.02, y = -12000, label = quad_portions[[2]], fontface = "bold") +
#   annotate("text", x = 0.03, y = -12000, label = quad_portions[[3]], fontface = "bold") +
#   annotate("text", x = 0.03, y = 5000, label = quad_portions[[4]], fontface = "bold")
# icer_plot
#

