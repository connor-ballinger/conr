#' Long Format Date
#'
#' @param date Currently a Date format, as provided by Sys.Date()
#' @param ...
#'
#' @return character date
#' @export
#' @importFrom scales ordinal
#'
#' @examples
#' format_date()
#' format_date(as.Date("2023-01-01"))
format_date <- function(date = Sys.Date(), ...) {
  d <- as.integer(format(date, "%d"))
  d <- scales::ordinal(d)
  my <- format(date, "%B, %Y")
  paste(d, my)
}
