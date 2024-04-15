#' Produce ICER Scatterplot
#'
#' @description Plot an ICER using `boot::boot` output. Point estimate and WTP
#'   optional.
#'
#' @param df A dataframe, likely produced from boot.
#' @param effect Effect column. Numeric.
#' @param cost Cost column. Numeric.
#' @param est_effect Point estimate. Numeric.
#' @param est_cost Point estimate. Numeric.
#' @param est_fill Colour to fill point estimate. Character.
#' @param est_colour Colour to outline point estimate. Character.
#' @param est_size Size of point estimate.
#' @param est_shape Point type of point estimate.
#' @param ellipse Draw ellipse? TRUE/FALSE.
#' @param ellipse_fill Colour of fill of ellipse. Character.
#' @param ellipse_alpha Transparency of ellipse. Numeric.
#' @param zoom_factor Change how zoomed-in the plot is using
#'   ggplot2::coord_cartesian indirectly. Numeric.
#' @param est_alpha Point estimate transparency for data, via
#'   geom_point(..., alpha = est_alpha). Numeric.
#' @param wtp WTP per unit of effect. Numeric.
#' @param wtp_line_colour Colour of WTP line. Character.
#' @param wtp_fill Colour to fill beyond WTP line. Character.
#' @param wtp_alpha Numeric.
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
#' @importFrom ggplot2 stat_ellipse
#' @importFrom ggplot2 geom_polygon
#' @importFrom scales label_percent
#' @importFrom scales label_dollar
#' @importFrom rlang .data
#'
#' @examples
#' c <- rnorm(n = 100, mean = 1000, sd = 50000) # cost
#' e <- rnorm(100, 3, 300) # effect
#' df <- data.frame(c, e)
#' plot_icer(df, e, c, zoom_factor = 5)
#' plot_icer(df, e, c, est_effect = 3, est_cost = 1000, wtp = 100)
plot_icer <- function(df, effect = "effect", cost = "cost", est_effect,
                      est_cost, wtp, est_fill = "green", est_colour = "black",
                      est_size = 2, est_shape = 21, data_alpha = 0.5,
                      wtp_line_colour = "grey", wtp_fill = "grey",
                      wtp_alpha = 0.1, ellipse = TRUE, ellipse_fill = "grey",
                      ellipse_alpha = 0.2, zoom_factor = 4) {

  icer_plot <- ggplot2::ggplot(
    data = df,
    ggplot2::aes(x = {{ effect }}, y = {{ cost }})
  )
  # setup
  # WTP
  if (!missing(wtp)) {
    icer_plot <- icer_plot +
      plot_wtp(df = df, effect = {{ effect }}, wtp = wtp, wtp_fill = wtp_fill,
               wtp_alpha = wtp_alpha, wtp_line_colour = wtp_line_colour)
  }
  icer_plot <- icer_plot +
    ggplot2::geom_vline(xintercept = 0, colour = "grey10") +
    ggplot2::geom_hline(yintercept = 0, colour = "grey10") +
    ggplot2::theme_set(ggplot2::theme_bw()) +
    ggplot2::theme_update(panel.grid = ggplot2::element_blank()) +
    ggplot2::labs(x = "Incremental Effect", y = "Incremental Cost") +
    ggplot2::scale_y_continuous(labels = scales::label_dollar()) +
    wrangle_icer_portions(df, {{ effect }}, {{ cost }})

  # ensure origin always in view
  icer_plot <- icer_plot +
    zoom(df = df, effect = {{ effect }}, cost = {{ cost }},
         zoom_factor = zoom_factor)

  # data
  icer_plot <- icer_plot +
    ggplot2::geom_point(alpha = data_alpha)

  if (ellipse) {
    icer_plot <- icer_plot +
      plot_ellipse(
        ellipse_fill = ellipse_fill,
        ellipse_alpha = ellipse_alpha
      )
  }

  # point estimate plotted on top of data
  if (!missing(est_effect) & !missing(est_cost)) {
    icer_plot <- icer_plot +
      plot_icer_pt_est(
        est_effect = est_effect,
        est_cost = est_cost,
        est_fill = est_fill,
        est_colour = est_colour,
        est_size = est_size,
        est_shape = est_shape
      )
  }

  icer_plot
}

plot_icer_pt_est <- function(est_effect, est_cost, est_fill,
                             est_colour, est_size, est_shape) {
  list(
    ggplot2::geom_point(
      data = data.frame("effect" = est_effect, "cost" = est_cost),
      ggplot2::aes(x = .data$effect, y = .data$cost),
      fill = est_fill, colour = est_colour, size = est_size, shape = est_shape
    )
  )
}

plot_ellipse <- function(ellipse_fill, ellipse_alpha) {
  list(
    ggplot2::stat_ellipse(type = "norm", geom = "polygon", fill = ellipse_fill,
                          alpha = ellipse_alpha)
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

plot_wtp <- function(df, effect, wtp, wtp_fill, wtp_alpha, wtp_line_colour) {
  xmin <- dplyr::pull(df, {{ effect }}) |> min(na.rm = TRUE)
  xmax <- dplyr::pull(df, {{ effect }}) |> max(na.rm = TRUE)
  x1 <- abs(xmin) * - 100
  x2 <- abs(xmax) * 100
  ymin <- wtp * x1
  ymax <- wtp * x2
  list(
    ggplot2::geom_polygon(
      data = data.frame(x = c(x1, x2, 0),
                        y = c(ymin, ymax, 1e10)),
      mapping = ggplot2::aes(x = .data$x, y = .data$y),
      fill = wtp_fill,
      alpha = wtp_alpha,
      colour = wtp_line_colour
    )
  )
}

zoom <- function(df, effect, cost, zoom_factor) {
  zoom_factor <- 1 / zoom_factor

  range_e <- pull(df, {{ effect }}) |>
    range(na.rm = TRUE)
  range_c <- pull(df, {{ cost }}) |>
    range(na.rm = TRUE)

  space_e <- zoom_factor * diff(range_e)
  space_c <- zoom_factor * diff(range_c)

  ggplot2::coord_cartesian(
    xlim = c(
      min(0, range_e) - space_e,
      max(0, range_e) + space_e
    ),
    ylim = c(
      min(0, range_c) - space_c,
      max(0, range_c) + space_c
    )
  )
}
