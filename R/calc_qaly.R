#' Calculate QALYs for a Data Frame
#'
#' @description
#' Calculates quality-adjusted life-years for each row of the dataframe.
#' Missing data will cause issues.
#' Note that a baseline differences between treatment arms should be accounted
#' for.
#'
#' @param df A dataframe.
#' @param qol Columns which contain QALY weights.
#' @param periods Vector containing the number of weeks between each measure.
#'   The length of periods should be 1 less than the number of columns.
#'
#' @return vector of qaly values.
#' @export
#'
#' @importFrom dplyr select
#' @importFrom dplyr rowwise
#' @importFrom dplyr mutate
#' @importFrom dplyr c_across
#' @importFrom dplyr ungroup
#' @importFrom purrr modify2
#'
#' @examples
#' df <- data.frame(
#'   id = 1:3,
#'   u0 = c(0, 0, 1),
#'   u1 = c(0.8, 0.4, 1),
#'   u2 = c(0.9, 0.7, 1),
#'   u3 = c(0.4, 0.6, 1)
#' )
#'
#' calc_qaly(df, qol = dplyr::starts_with("u"), periods = c(4, 13, 26))
#' df |>
#'   dplyr::mutate(
#'     qaly = calc_qaly(df, qol = dplyr::starts_with("u"), periods = c(4, 13, 26))
#'   )
calc_qaly <- function(df, qol, periods) {
  multiplier <- periods_to_trapezium(periods)

  scores <- purrr::modify2(dplyr::select(df, {{ qol }}), multiplier, `*`)

  scores <- scores |>
    dplyr::rowwise() |>
    dplyr::mutate(qaly = sum(dplyr::c_across({{ qol }})) / 104) |>
    dplyr::ungroup() # 52 weeks * 2 for area trapezium

  scores$qaly
}

periods_to_trapezium <- function(periods) {
  # Area trapezium = h*(a+b)/2
  additions <- periods[-length(periods)] + periods[-1]
  # This creates all a+b for trapeziums.
  c(periods[1], additions, periods[length(periods)])
}
