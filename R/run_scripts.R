#' Run Scripts
#'
#' @description Convenience function to source all (or some) scripts in a
#'   subdirectory. The function currently assumes all scripts to be run are
#'   named similar to `01_clean.R`, with numbers somewhere in the name to
#'   indicate ordering.
#'
#' @param directory Character. What directory contains the scripts to run? The
#'   default is in the `code` subdirectory of the open project.
#' @param last Numeric. What is the last script to run. Default is `Inf`. If
#'   later scripts are a work in progress, you don't want to run them.
#' @param ... Dots to pass to \code{\link[base]{source}}.
#'
#' @importFrom here here
#'
#' @return Whatever your scripts return after being parsed to `source`.
#' @export
#'
#' @examples
run_scripts <- function(directory = here::here("code"), last = Inf, ...) {
  scripts <- list.files(directory, pattern = "\\.R$")
  files_match <- regexpr("\\d+", scripts)
  numbers <- regmatches(scripts, files_match) |> as.integer()
  files_numbered <- scripts[files_match > 0]
  files <- files_numbered[which(numbers <= last)]
  files <- paste(directory, files, sep = "/")
  lapply(files, source, ...)
}
