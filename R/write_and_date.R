#' Save Output File with the Date
#'
#' @description
#' Would be good to avoid the `xfun` dependency...
#'
#' @param input File to be knitted.
#' @param ... Dots.
#'
#' @return Output file created.
#' @export
#'
#' @importFrom xfun Rscript_call
#' @importFrom tools file_path_sans_ext
#' @importFrom rmarkdown render
#' @importFrom here here
#'
#' @examples
write_and_date <- function(input, ...) {
  xfun::Rscript_call(
    rmarkdown::render,
    list(input,
      output_file = paste(
        tools::file_path_sans_ext(basename(input)),
        Sys.Date(),
        sep = "_"
      ),
      output_dir = here::here("output")
    )
  )
}
