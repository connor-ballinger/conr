#' Round numbers sensibly
#'
#' @param x The number you intend to round.
#' @param digits The number of digits after the decimal, defaults to zero.
#'
#' @description base::round() has a flaw in that it rounds 5 to the nearest even
#'   number - i.e. 1.5 is rounded to 2 but 2.5 is also rounded to 2. This
#'   function was originally stolen from
#'   \url{https://stackoverflow.com/questions/12688717/round-up-from-5} and I
#'   subsequently found \code{janitor::round_half_up}. Added exception to the
#'   \code{\link[lubridate]{timespan}} class, which is numeric but can't be
#'   rounded.
#'
#' @return A double.
#' @export
#'
#' @importFrom methods is
#'
#' @examples
#' base::round(2.5)
#' conr::round_sensibly(2.5)
#' conr::round_sensibly(2.115, 2)
#'
#' @examplesIf requireNamespace("lubridate")
#' library(lubridate)
#' lubridate::interval(
#'   lubridate::ymd("2021-01-01"),
#'   lubridate::ymd("2021-04-01")
#' ) |>
#'   round_sensibly()
round_sensibly <- function(x, digits = 0) {
  if (is(x, "numeric")) {
    if (!is(x, "Timespan")) {
      posneg <- sign(x)
      x <- abs(x) * (10^digits)
      x <- x + 0.5 + sqrt(.Machine$double.eps)
      x <- trunc(x)
      x <- x / (10^digits)
      x <- x * posneg
    } else if (interactive()) {
      # if Timespan, return x unchanged, warning to console if interactive
      cli::cli_warn(
        c("{.var x} should be a numeric. You supplied a {.cls {class(x)}}.
          {.var x} is unchanged.")
      )
    }
    x
  }  else {
    cli::cli_abort(
      c("{.var x} should be a numeric. You supplied class {.cls {class(x)}}.")
    )
  }
}
