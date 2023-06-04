#' Calculate an Individual QALY From a List of Utilities
#'
#' @description Calculate quality-adjusted life-years using utility scores and
#'   the trapezium method for a single case.
#'
#' @param utilities Utility scores, roughly between zero and one, in a vector.
#' @param periods Length of periods between utility scores, in weeks. For
#'   example, utility may be measured at baseline, 6 weeks later, and 10 weeks
#'   after baseline. Periods would then be c(6, 4). Periods is a vector one
#'   element shorter than utilities.
#'
#' @return QALY, a numeric.
#' @export
#'
#' @examples
#' calc_ind_qaly(c(1, 0.4, 0.8), c(6, 4))
calc_ind_qaly <- function(utilities = c(), periods = c()) {

  stopifnot(length(utilities) - length(periods) == 1)

  parts = vector(mode = "double", length = length(periods))

  for (i in 1:(length(utilities)-1)) {

    parts[[i]] = utilities[[i]] + utilities[[i + 1]]

    sum(parts)/104

  }
}
