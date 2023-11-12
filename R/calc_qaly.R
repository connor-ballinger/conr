#' Calculate QALYs for a Data Frame
#'
#' @param df A dataframe.
#' @param qol Columns which contain QALY weights.
#' @param periods Vector containing the number of weeks between each measure.
#'   The length of periods should be 1 more than the number of columns.
#'
#' @return vector of qaly values.
#' @export
#'
#' @import dplyr
#' @importFrom purrr modify2
#'
#' @examples
#' testdf <- data.frame(
#'   id = 1:3,
#'   u0 = c(0, 0, 1),
#'   u1 = c(0.8, 0.4, 1),
#'   u2 = c(0.9, 0.7, 1),
#'   u3 = c(0.4, 0.6, 1)
#' )
#'
#' calc_qaly(testdf, qol = starts_with("u"), periods = c(4, 13, 26))

calc_qaly <- function (df, qol, periods) {

  multiplier = periods_to_trapezium(periods)

  scores = purrr::modify2(select(df, {{ qol }}), multiplier, `*`)

  scores = scores |>
    rowwise() |>
    mutate(qaly = sum(c_across({{ qol }})) / 104) |>  # 52 weeks * 2 for area trapezium
    ungroup()

  scores$qaly

}

periods_to_trapezium <- function(periods) {

  additions = periods[-length(periods)] + periods[-1] # Area trapezium = h*(a+b)/2
  c(periods[1], additions, periods[length(periods)]) # This creates all a+b for trapeziums.

}
