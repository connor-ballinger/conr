#' Round Sensibly
#'
#' @param x The number you intend to round.
#' @param digits The number of digits after the decimal, defaults to zero.
#'
#' @description base::round() has a flaw in that it rounds 5 to the nearest even
#'   number - i.e. 1.5 is rounded to 2 but 2.5 is also rounded to 2. This
#'   function was stolen from
#'   \url{https://stackoverflow.com/questions/12688717/round-up-from-5}.
#'
#' @return A double.
#' @export
#'
#' @examples
#' base::round(2.5)
#' conr::round_sensibly(2.5)
#'
round_sensibly <- function(x, digits = 0) {
  if (is(x, "numeric")) {
    if (!is(x, "Timespan")) {
      posneg <- sign(x)
      z <- abs(x) * (10^digits)
      z <- z + 0.5 + sqrt(.Machine$double.eps)
      z <- trunc(z)
      z <- z / (10^digits)
      z * posneg
    }
  }
}
