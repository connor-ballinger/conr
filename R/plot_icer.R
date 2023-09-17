#' Produce ICER Scatterplot
#'
#' @param df A two-column dataframe with 1 column named cost, the other named effect.
#' @param estimate A vector of length 2, the first number being cost, the second being effect.
#' @param wtp WTP per unit of effect.
#' @param alpha Opacity of data points.
#'
#' @return ggplot
#' @export
#' @import ggplot2
#' @importFrom scales label_percent
#' @importFrom scales label_dollar
#' @examples
#' cost <- rnorm(n = 100, mean = 1000, sd = 500)
#' effect <- rnorm(100, 3, 3)
#' df <- data.frame(cost, effect)
#' plot_icer(df, c(effect = 1, cost = 100), wtp = 100, alpha = 0.8)

plot_icer <- function(df, estimate, wtp, alpha = 0.5) {

  # count bootstrap replications
  B = nrow(df)

  # portion in quadrants, clockwise
  tr = sum(df[, 1] > 0 & df[, 2] > 0) / B
  br = sum(df[, 1] > 0 & df[, 2] < 0) / B
  bl = sum(df[, 1] < 0 & df[, 2] < 0) / B
  tl = sum(df[, 1] < 0 & df[, 2] > 0) / B

  # print as %
  quad_portions = lapply(c(tr, br, bl, tl), scales::label_percent())

  # positioning the labels
  annotations = data.frame(
    xpos = c(Inf, Inf, -Inf, -Inf),
    ypos = c(Inf, -Inf, -Inf, Inf),
    text = c(unlist(quad_portions)),
    hjustvar = c(1, 1, 0, 0),
    vjustvar = c(1, 0, 0, 1))

  icer_plot = ggplot2::ggplot(data = df) +
    # setup
    geom_vline(xintercept = 0, colour = "grey") +
    geom_hline(yintercept = 0, colour = "grey") +
    theme_set(theme_bw()) +
    theme_update(panel.grid = element_blank()) +
    labs(x = "Incremental Effect", y = "Incremental Cost") +
    scale_y_continuous(labels = scales::label_dollar()) +
    geom_label(data = annotations,
               aes(x = xpos, y = ypos,
                   hjust = hjustvar, vjust = vjustvar,
                   label = text)) +
    # WTP
    geom_abline(slope = wtp, linewidth = 0.8) +
    geom_label(aes(x = Inf, y = wtp * max(effect, na.rm = TRUE),
                   label = paste0("WTP = $", wtp)),
               hjust = "inward", vjust = 2) +
    # point estimate
    geom_point(aes(x = estimate[1], y = estimate[2]),
               colour = "green", size = 5) +
    geom_label(aes(x = estimate[1], y = estimate[2],
                   label = paste0(estimate[1], ", $", estimate[2])),
               vjust = 2) +
    # data
    geom_point(aes(x = effect, y = cost), alpha = alpha)

  icer_plot

}
