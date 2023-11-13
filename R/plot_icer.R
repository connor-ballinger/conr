#' Produce ICER Scatterplot
#'
#' @param df A two-column dataframe with 1 column named cost, the other named effect, produced from boot.
#' @param effect Effect column.
#' @param cost Cost column.
#' @param est_effect Point estimate.
#' @param est_cost Point estimate.
#' @param wtp WTP per unit of effect.
#' @param alpha Opacity of data points.
#' @param colour Colour of point estimate.
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
#' plot_icer(df, effect, cost, 3, 1000, wtp = 100, alpha = 0.8)

plot_icer <- function(df, effect, cost, est_effect, est_cost, wtp, alpha = 0.5, colour = "green", size = 2) {

  # count bootstrap replications
  B = nrow(df)

  # portion in quadrants, clockwise
  tr = sum(pull(df, {{ effect }} ) > 0 & pull(df, {{ cost }} ) > 0) / B
  br = sum(pull(df, {{ effect }} ) > 0 & pull(df, {{ cost }} ) < 0) / B
  bl = sum(pull(df, {{ effect }} ) < 0 & pull(df, {{ cost }} ) < 0) / B
  tl = sum(pull(df, {{ effect }} ) < 0 & pull(df, {{ cost }} ) > 0) / B

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

  icer_plot = ggplot2::ggplot(data = df) +

    # setup
    geom_vline(xintercept = 0, colour = "grey") +
    geom_hline(yintercept = 0, colour = "grey") +
    theme_set(theme_bw()) +
    theme_update(panel.grid = element_blank()) +
    labs(x = "Incremental Effect", y = "Incremental Cost") +
    scale_y_continuous(labels = scales::label_dollar()) +
    geom_label(data = annotations,
               aes(x = .data$xpos, y = .data$ypos,
                   hjust = .data$hjustvar, vjust = .data$vjustvar,
                   label = .data$text))

  # WTP
  if (!missing(wtp)) {
    icer_plot = icer_plot +
      geom_abline(slope = wtp, linewidth = 0.8)
    # geom_label(aes(x = Inf, y = wtp * max(effect, na.rm = TRUE),
    #                label = paste0("WTP = $", wtp)),
    #            hjust = "inward", vjust = 2, size = 4)#atan(pi * wtp) * 180 / pi)
  }

  # point estimate
  if (!missing(est_effect) & !missing(est_cost)) {
    icer_plot = icer_plot +
      geom_point(data = data.frame(effect = est_effect, cost = est_cost),
                 aes(x = effect, y = cost),
                 colour = colour, size = size)
    # geom_label(data = data.frame(estimate),
    #                  aes(x = estimate[1], y = estimate[2],
    #                      label = paste0(estimate[1], ", $", estimate[2])))
  }

  # data
  icer_plot = icer_plot +
    geom_point(aes(x = .data$effect, y = .data$cost), alpha = alpha)

  icer_plot +
    coord_cartesian(
      xlim = c(
        min(0, pull(df, {{ effect }} )),
        max(0, pull(df, {{ effect }} ))
      ),
      ylim = c(min(0, pull(df, {{ cost }} )),
               max(0, pull(df, {{ cost }} )))
    )

}


#############################################
# Split into multiple functions



