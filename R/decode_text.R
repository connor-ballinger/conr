#' Decode Text for Aesthetics
#'
#' @description
#' Transform text which is used for code to something more normal-looking.
#'
#' @param x A character vector.
#' @param ... Dots.
#'
#' @return A visually-appealing character vector.
#' @export
#'
#' @examples
#' colnames(fake_health_ec_data)
#' colnames(fake_health_ec_data) |> decode_text()
decode_text <- function(x, ...) {
  x = gsub("_", " ", x) # underscores to spaces
  x = tools::toTitleCase(x) # upper case
  x = gsub("\\.", " ", x) # remove periods - replace with a space.

  # columns named by years are often given x prefix, eg x2018

  gsub("^(x)([[:digit:]])", "\\2", x, ignore.case = TRUE)
}
