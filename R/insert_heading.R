#' Insert New Heading
#'
#' @description Create a new heading for a script by inserting hyphens from
#' cursor position to the 80 character limit.
#' Function is linked to a .dcf file, thereby creating an Addin.
#' Create a keyboard shortcut (e.g. Ctrl + H) for the Addin.
#'
#' Credit to \url{https://github.com/mnist91/shoRtcut}.
#'
#' @importFrom rstudioapi getActiveDocumentContext
#' @importFrom rstudioapi insertText
#'
#' @return Hyphens up to the 80 character limit.
#' @export
#'
#' @examples
insert_heading <- function(){
  nchars <- 81

  # grab current document information
  context <- rstudioapi::getActiveDocumentContext()
  # extract courser position in document
  context_col <- context$selection[[1]]$range$end["column"]

  # if line has less than 81 characters, insert hyphens at the current line
  # up to 80 characters
  if (nchars > context_col) {
    rstudioapi::insertText(strrep("-", nchars - context_col))
  }
}
