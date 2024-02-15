#' Produce ICER Scatterplot
#'
#' @description
#' Plot an ICER using `boot::boot` output. Point estimate and WTP optional.
#'
#' @param df A dataframe, likely produced from boot.
#' @param effect Effect column.
#' @param cost Cost column.
#' @param est_effect Point estimate.
#' @param est_cost Point estimate.
#' @param wtp WTP per unit of effect.
#' @param alpha Opacity of data points, default 0.5.
#' @param fill Fill of point estimate, default "green".
#' @param colour Border colour of point estimate, default "black".
#' @param size Size of point estimate, default 2.
#' @param shape Shape of the point estimate, default 21.
#'
#' @return ggplot
#'
#' @export
#'
#' @importFrom dplyr pull
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_vline
#' @importFrom ggplot2 geom_hline
#' @importFrom ggplot2 theme_set
#' @importFrom ggplot2 theme_bw
#' @importFrom ggplot2 theme_update
#' @importFrom ggplot2 element_blank
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 coord_cartesian
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 geom_point
#' @importFrom scales label_percent
#' @importFrom scales label_dollar
#'
#' @examples
#' c <- rnorm(n = 100, mean = 1000, sd = 500) # cost
#' e <- rnorm(100, 3, 3) # effect
#' df <- data.frame(c, e)
#' plot_icer(df, e, c)
#' plot_icer(df, e, c, est_effect = 3, est_cost = 1000, wtp = 100,
#'   alpha = 0.8, size = 10)
plot_icer <- function(df, effect = "effect", cost = "cost", est_effect,
                      est_cost, wtp, alpha = 0.5, fill = "green",
                      colour = "black", size = 2, shape = 21) {

  icer_plot <- ggplot2::ggplot(data = df) +

    # setup
    ggplot2::geom_vline(xintercept = 0, colour = "grey10") +
    ggplot2::geom_hline(yintercept = 0, colour = "grey10") +
    ggplot2::theme_set(ggplot2::theme_bw()) +
    ggplot2::theme_update(panel.grid = ggplot2::element_blank()) +
    ggplot2::labs(x = "Incremental Effect", y = "Incremental Cost") +
    ggplot2::scale_y_continuous(labels = scales::label_dollar()) +
    wrangle_icer_portions(df, {{ effect }}, {{ cost }})

  # ensure origin always in view
  icer_plot <- icer_plot +
    ggplot2::coord_cartesian(
      xlim = c(
        min(0, dplyr::pull(df, {{ effect }})) -
          abs(0.1 * mean(dplyr::pull(df, {{ effect }}))),
        max(0, dplyr::pull(df, {{ effect }})) +
          abs(0.1 * mean(dplyr::pull(df, {{ effect }})))
      ),
      ylim = c(
        min(0, dplyr::pull(df, {{ cost }})) -
          abs(0.1 * mean(dplyr::pull(df, {{ cost }}))),
        max(0, dplyr::pull(df, {{ cost }})) +
          abs(0.1 * mean(dplyr::pull(df, {{ cost }})))
      )
    )

  # WTP
  if (!missing(wtp)) {
    icer_plot <- icer_plot + plot_wtp(slope = wtp)
  }

  # data
  icer_plot <- icer_plot +
    ggplot2::geom_point(aes(x = {{ effect }}, y = {{ cost }}), alpha = alpha)

  # point estimate plotted on top of data
  if (!missing(est_effect) & !missing(est_cost)) {
    icer_plot <- icer_plot +
      plot_icer_pt_est(
        est_effect = est_effect,
        est_cost = est_cost,
        fill = fill,
        colour = colour,
        size = size,
        shape = shape
      )
  }

  icer_plot
}

plot_icer_pt_est <- function(est_effect, est_cost, fill, colour, size, shape) {
  list(
    ggplot2::geom_point(
      data = data.frame(effect = est_effect, cost = est_cost),
      ggplot2::aes(x = effect, y = cost),
      fill = fill, colour = colour, size = size, shape = shape
    )
  )
}

plot_wtp <- function(slope, linewidth = 0.8, extras = list()) {
  list(
    do.call("geom_abline", c(slope = slope, linewidth = 0.8, extras))
  )
}

wrangle_icer_portions <- function(df, effect, cost) {
  # count bootstrap replications
  B <- nrow(df)

  # portion in quadrants, clockwise
  tr <- sum(
    dplyr::pull(df, {{ effect }}) > 0 &
      dplyr::pull(df, {{ cost }}) > 0
  ) / B
  br <- sum(
    dplyr::pull(df, {{ effect }}) > 0 &
      dplyr::pull(df, {{ cost }}) < 0
  ) / B
  bl <- sum(
    dplyr::pull(df, {{ effect }}) < 0 &
      dplyr::pull(df, {{ cost }}) < 0
  ) / B
  tl <- sum(
    dplyr::pull(df, {{ effect }}) < 0 &
      dplyr::pull(df, {{ cost }}) > 0
  ) / B

  # print as %
  quad_portions <- lapply(c(tr, br, bl, tl), scales::label_percent())

  # positioning the labels
  annotations <- data.frame(
    xpos = c(Inf, Inf, -Inf, -Inf),
    ypos = c(Inf, -Inf, -Inf, Inf),
    text = c(unlist(quad_portions)),
    hjustvar = c(1, 1, 0, 0),
    vjustvar = c(1, 0, 0, 1)
  )

  # plotting labels
  list(
    ggplot2::geom_label(
      data = annotations,
      ggplot2::aes(
        x = .data$xpos, y = .data$ypos,
        hjust = .data$hjustvar, vjust = .data$vjustvar,
        label = .data$text
      )
    )
  )
}
