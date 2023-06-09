#' Decode Text for Aesthetics
#'
#' @param x A character vector.
#' @param ...
#'
#' @return A visually-appealing character vector.
#' @export
#'
#' @examples
decode_text <- function(x, ...) {
  x = gsub("_", " ", x)
  x = tools::toTitleCase(x)
  x = gsub("\\.", "", x)

  # columns named by years are often given x prefix, eg x2018

  gsub("^(x)([[:digit:]])", "\\2", x, ignore.case = TRUE)
}
