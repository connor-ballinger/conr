#' Produce an HTML Report
#'
#' @description Produce an .html file from .Rmd, with branding and some
#'   preferences. Essentially a wrapper around
#'   \code{\link[rmarkdown]{html_document}}.
#'
#' @param ...  <[`dynamic-dots`][rlang::dyn-dots]> Supply any arguments to
#'   \code{\link[rmarkdown]{html_document}}. This allows arguments to be
#'   supplied in the YAML in the same was as with any standard format, just
#'   remember to use spaces to indent, not tabs.
#' @param new_styles TRUE/FALSE - HMRI branding, new (default) or old.
#'
#' @return `rmarkdown::html_document`
#' @export
#'
#' @importFrom rlang dots_list
#' @importFrom rmarkdown html_document
#'
#' @examples
format_html <- function(..., new_styles = TRUE) {
# args with defaults should go after dots apparently
  if (new_styles) {
    styles <- system.file(
      "rmarkdown/templates/html_template/styles.css",
      package = "conr"
    )
  } else {
    styles <- system.file(
      "rmarkdown/templates/rmd-template/syles-deprecated.css",
      package = "conr"
    )
  }
  arguments <- rlang::dots_list(
    theme = "default",
    toc = TRUE,
    toc_float = TRUE,
    number_sections = TRUE,
    css = styles,
    code_folding = "hide",
    ...,
    .homonyms = "last" # means the dots will overwrite defaults
  )
  do.call(rmarkdown::html_document, arguments)
}
# favicon:
### rmarkdown::pandoc_variable_arg()
### html_document(includes = rmarkdown::includes(before_body = "header.htm"))
### pandoc_args = rmarkdown::pandoc_include_args(
###   in_header =
### )
### favicon <- system.file(
###   "rmarkdown/templates/html_template/favicon.html",
###   package = "conr"
### )
# Misc:
### footer
### fix DT datetime outputs - too hard? Definitely, too many possibilities.
### background shade?
# Dots: potential alternatives to do.call:
### exec, do.call, inject, call2 + eval
