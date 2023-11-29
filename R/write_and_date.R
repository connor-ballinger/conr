#' Save Output File with the Date
#'
#' @param input File to be knitted.
#' @param ...
#'
#' @return Output file created.
#' @export
#'
#' @examples
write_and_date <- function(input, ...) {
  xfun::Rscript_call(
    rmarkdown::render,
    list(input,
         output_file = paste(
           Sys.Date(),
           xfun::sans_ext(basename(input)),
           sep = "_"
         ),
         output_dir = here::here("output")
    )
  )
}
