#' Produce ICER Scatterplot
#'
#' @param df A two-column dataframe with 1 column named cost, the other named
#'   effect, produced from boot.
#' @param effect Effect column.
#' @param cost Cost column.
#' @param est_effect Point estimate.
#' @param est_cost Point estimate.
#' @param wtp WTP per unit of effect.
#' @param alpha Opacity of data points.
#' @param fill Fill of point estimate.
#' @param colour Border colour of point estimate.
#' @param size Size of point estimate.
#'
#' @return ggplot
#'
#' @export
#'
#' @import ggplot2
#' @importFrom scales label_percent
#' @importFrom scales label_dollar
#'
#' @examples
#' cost <- rnorm(n = 100, mean = 1000, sd = 500)
#' effect <- rnorm(100, 3, 3)
#' df <- data.frame(cost, effect)
#' plot_icer(df, effect, cost)
#' plot_icer(df, effect, cost, est_effect = 3,
#'           est_cost = 1000, wtp = 100, alpha = 0.8, size = 10)

plot_icer <- function(df, effect = "effect", cost = "cost", est_effect,
                      est_cost, wtp, alpha = 0.5, fill = "green",
                      colour = "black", size = 2) {
# plot_icer <- function(df, effect = "effect", cost = "cost", point_est = list(), wtp)
  icer_plot = ggplot2::ggplot(data = df) +

    # setup
    geom_vline(xintercept = 0, colour = "grey10") +
    geom_hline(yintercept = 0, colour = "grey10") +
    theme_set(theme_bw()) +
    theme_update(panel.grid = element_blank()) +
    labs(x = "Incremental Effect", y = "Incremental Cost") +
    scale_y_continuous(labels = scales::label_dollar()) +
    wrangle_icer_portions(df, effect, cost)

  # WTP
  if (!missing(wtp)) {
    icer_plot = icer_plot + plot_wtp(slope = wtp)
  }

  # data
  icer_plot = icer_plot +
    geom_point(aes(x = .data$effect, y = .data$cost), alpha = alpha)

  # ensure origin always in view
  icer_plot = icer_plot +
    coord_cartesian(
      xlim = c(
        min(0, pull(df, {{ effect }})) - abs(0.1 * mean(pull(df, {{ effect }}))),
        max(0, pull(df, {{ effect }})) + abs(0.1 * mean(pull(df, {{ effect }})))
      ),
      ylim = c(min(0, pull(df, {{ cost }})) - abs(0.1 * mean(pull(df, {{ cost }}))),
               max(0, pull(df, {{ cost }})) + abs(0.1 * mean(pull(df, {{ cost }}))))
    )

  # point estimate
  if (!missing(est_effect) & !missing(est_cost)) {
    icer_plot = icer_plot +
      plot_icer_pt_est(est_effect = est_effect, est_cost = est_cost)
  }

  icer_plot

}


#############################################
# Split into multiple functions

plot_icer_pt_est <- function(est_effect, est_cost, fill = "green",
                             colour = "black", size = 2, shape = 21) {
  list(
    geom_point(data = data.frame(effect = est_effect, cost = est_cost),
               aes(x = effect, y = cost),
               fill = fill, colour = colour, size = size, shape = shape)
  )
}

plot_wtp <- function(slope, linewidth = 0.8, extras = list()) {
  list(
  do.call("geom_abline", c(slope = slope, linewidth = 0.8, extras))
  )
}

wrangle_icer_portions <- function(df = df, effect = effect, cost = cost) {
  # count bootstrap replications
  B = nrow(df)

  # portion in quadrants, clockwise
  tr = sum(pull(df, {{ effect }}) > 0 & pull(df, {{ cost }}) > 0) / B
  br = sum(pull(df, {{ effect }}) > 0 & pull(df, {{ cost }}) < 0) / B
  bl = sum(pull(df, {{ effect }}) < 0 & pull(df, {{ cost }}) < 0) / B
  tl = sum(pull(df, {{ effect }}) < 0 & pull(df, {{ cost }}) > 0) / B

  # print as %
  quad_portions = lapply(c(tr, br, bl, tl), scales::label_percent())

  # positioning the labels
  annotations = data.frame(
    xpos = c(Inf, Inf, -Inf, -Inf),
    ypos = c(Inf, -Inf, -Inf, Inf),
    text = c(unlist(quad_portions)),
    hjustvar = c(1, 1, 0, 0),
    vjustvar = c(1, 0, 0, 1)
  )

  list(
    geom_label(data = annotations,
               aes(x = .data$xpos, y = .data$ypos,
                   hjust = .data$hjustvar, vjust = .data$vjustvar,
                   label = .data$text))
  )

}

################################################################################


# plot_iris <- ggplot(data = iris, aes(x = Petal.Length, y = Petal.Width))
# + geom_point(fill = "green", shape = 21)
# plot_iris + plot_pt_est(4, 1) + plot_wtp(slope = 0.5)
#
#
#
# foo <- function(x, y, s1 = list(), g1 = list()) {
#   list(s2 = do.call("sum", c(x, s1)), g2 = do.call("grep", c("abc", y, g1)))
# }
#
# # test
#
# X <- c(1:5, NA, 6:10)
# Y <- "xyzabcxyz"
# foo(X, Y, s1 = list(na.rm = TRUE), g1 = list(value = TRUE))


