#' Save Output File with the Date
#'
#' @description Pass this function to the YAML knit argument. Can also be used
#'   interactively. Dots can't be accessed in the YAML (but see that they can
#'   for the knit argument, which is used by format_html).
#'
#' @param input File to knit. Automatically provided by YAML when knitting.
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Supply any arguments to
#'   \code{\link[rmarkdown]{render}}. For example, the default \code{output_dir}
#'   is \code{\link[here]{here}("output")} - the output folder in your project
#'   directory.
#'
#'   The other argument with a default specified is:
#'   \code{output_file = paste(
#'      \link[tools]{file_path_sans_ext}(basename(input)),
#'       Sys.Date(),
#'       sep = "_"
#'   )}
#'
#'   This provides an output file with the same name as the Rmarkdown file,
#'   suffixed by the date and with an appropriate file extension.
#'
#' @return Output file created.
#' @export
#'
#' @importFrom here here
#' @importFrom rlang dots_list
#' @importFrom rmarkdown render
#' @importFrom tools file_path_sans_ext
#' @importFrom xfun Rscript_call
#'
#' @examples
#' # example YAML
#' # ---
#' # title: "Title"
#' # date: "`r conr::format_date()`"
#' # author: "Author"
#' # knit: conr::write_and_date
#' # output: conr::format_html
#' # ---
write_and_date <- function(input, ...) {
  arguments <- rlang::dots_list(
    input,
    output_file = paste(
      tools::file_path_sans_ext(basename(input)),
      Sys.Date(),
      sep = "_"
    ),
    output_dir = here::here("output"),
    ...,
    .homonyms = "last" # means the dots will overwrite defaults
  )
  xfun::Rscript_call(fun = rmarkdown::render, args = arguments)
}
