#' Reactable table wrapper
#'
#' This function is intended to simplify printing of tables from .Rmd or .qmd
#' into HTML format. See \code{\link[reactable]{reactable}} documentation.
#'
#' The following arguments of \code{\link[reactable]{reactable}} have been
#' specified, but they can be changed by supplying named arguments to the dots.
#' Using the \code{defaultColDef} argument may be useful to define colDef for
#' all/most columns.
#'
#' ```
#' filterable = FALSE,
#' searchable = TRUE,
#' defaultColDef = reactable::colDef(format = reactable::colFormat(digits = 2)),
#' defaultPageSize = 5,
#' showPageSizeOptions = TRUE,
#' pageSizeOptions = c(5, 10, 25),
#' paginationType = "numbers",
#' highlight = TRUE,
#' compact = TRUE,
#' wrap = TRUE,
#' showSortIcon = TRUE,
#' showSortable = TRUE,
#' fullWidth = FALSE,
#' language = reactable::reactableLang(
#'   pagePrevious = "\u276e",
#'   pageNext = "\u276f",
#'   pagePreviousLabel = "Previous page", # accessible labels
#'   pageNextLabel = "Next page"
#' ),
#' theme = reactable::reactableTheme(
#'   style = list(
#'     fontFamily = "Roboto, Helvetica, Arial",
#'     searchInputStyle = list(width = "140px", fontSize = "10px")
#'   ),
#'   paginationStyle = list(fontsize = "0.85em")
#'   ),
#' )
#' ```
#'
#' @param df Dataframe.
#' @param ...  <[`dynamic-dots`][rlang::dyn-dots]> Supply any arguments to
#'   \code{\link[reactable]{reactable}}. This allows any of the defaults to be
#'   changed.
#' @param downloadable TRUE/FALSE - should a download button be provided for
#'   this table?
#' @param filename Name of the csv file which can be downloaded from the table.
#' @param table_id Unique table identifier, required for the download option. By
#'   default, a random string is produced.
#'
#' @importFrom rlang dots_list
#'
# @importFrom htmltools browsable
# @importFrom htmltools tagList
# @importFrom reactable reactable
# @importFrom reactable reactableLang
# @importFrom reactable reactableTheme
# @returns \code{\link[htmltools]{browsable}} which includes a reactable table
#   and a download button.
#'
#' @export
#'
#' @examples
#' wrap_reactable(penguins)
#' wrap_reactable(
#'   penguins, downloadable = TRUE, filename = "penguins.csv",
#'   table_id = "penguins", compact = FALSE, outlined  = TRUE
#' )
#' # Formatting columns preserves the underlying data but changes the display.
#' # Formatting can be applied to a subset of columns and the other columns will
#' # still print.
#' wrap_reactable(
#'   penguins,
#'   downloadable = FALSE,
#'   columns = list(
#'     bill_len = reactable::colDef(
#'       format = reactable::colFormat(
#'         prefix = "$",
#'         separators = TRUE,
#'         digits = 2
#'       )
#'     ),
#'     bill_dep = reactable::colDef(
#'       format = reactable::colFormat(percent = TRUE, digits = 0)
#'     )
#'   )
#' )
#' @examplesIf requireNamespace("labelled") & requireNamespace("stringr")
#' library(labelled)
#' library(stringr)
#' # Anchor a column. Pretend you already have labelled variables and want the
#' # labels to be printed.
#' penguins <- penguins |>
#'   labelled::set_variable_labels(
#'     .labels = stringr::str_to_title(colnames(penguins))
#'   )
#' # reactable does not automatically display labels... is there a better way to
#' # make them appear?
#' colnames(penguins) <- unlist(labelled::var_label(penguins))
#' penguins |>
#'   wrap_reactable(
#'     columns = list(
#'       Species = reactable::colDef(
#'         sticky = "left",
#'         # Add a right border style to visually distinguish the sticky column
#'         style = list(borderRight = "1px solid #eee"),
#'         headerStyle = list(borderRight = "1px solid #eee")
#'       )
#'     ),
#'     width = 400 # limit width just to demonstrate the anchored column
#'   )
wrap_reactable <- function(df, ..., downloadable = !interactive(),
                           filename = "data.csv", table_id = NULL) {
  if(!requireNamespace("reactable", quietly = TRUE)) {
    stop(
      "Package 'reactable' is needed for this function. Please install it.",
      call. = FALSE
    )
  }
  if (downloadable) {
    # Generate unique table ID if not provided
    if (is.null(table_id)) {
      table_id <- paste0(
        "table-",
        format(Sys.time(), "%Y-%m-%d_%H-%M-%S_"),
        sample(1000:9999, 1)
      )
    }
    # Create the download button with a simple download icon (Unicode)
    download_button <- htmltools::tags$button(
      class = "btn btn-reactable-download",
      style = paste(
        "background-color: #fff",
        "color: rgb(82, 46, 145)",
        "border: 1px solid transparent",
        "border-color: #ccc",
        "border-radius: 4px",
        "cursor: pointer;",
        "height: 30px",
        "width: 60px",
        sep = "; "
      ),
      htmltools::tagList( # Unicode download arrow
        htmltools::tags$span("\u2913", style = "margin-right: 5px;"),
        ".csv"
      ),
      onclick = sprintf(
        "Reactable.downloadDataCSV('%s', '%s')",
        table_id,
        filename
      )
    )
  }
  # inherit any labels here
  if (requireNamespace("labelled", quietly = TRUE)) {
    colnames(df) <- labelled::var_label(df, unlist = TRUE, null_action = "fill")
  }
  n_row <- nrow(df)
  # args for reactable
  arguments <- rlang::dots_list(
    data = df,
    elementId = table_id,
    filterable = FALSE,
    searchable = n_row > 10,
    defaultColDef = reactable::colDef(format = reactable::colFormat(digits = 2)),
    defaultPageSize = ifelse(n_row <= 10, n_row, 5),
    showPageSizeOptions = TRUE,
    pageSizeOptions = c(5, 10, 25),
    paginationType = "numbers",
    highlight = TRUE,
    compact = TRUE,
    wrap = TRUE,
    showSortIcon = TRUE,
    showSortable = TRUE,
    fullWidth = TRUE,
    language = reactable::reactableLang(
      pagePrevious = "\u276e",
      pageNext = "\u276f",
      pagePreviousLabel = "Previous page", # accessible labels
      pageNextLabel = "Next page"
    ),
    theme = reactable::reactableTheme(
      style = list(
        fontFamily = "Roboto, Helvetica, Arial",
        marginTop = "20px",
        boxShadow = "0px 0px 12px rgba(0,0,0,0.1)",
        broderRadius = "6px"
      ),
      searchInputStyle = list(
        width = "120px", height = "20px", fontSize = "12px", opacity = 0.7,
        padding = "2px 8px"
      ),
      paginationStyle = list(
        fontSize = "12px", opacity = 0.7, padding = "4px 0"
      )
    ),
    ...,
    .homonyms = "last" # means the dots can overwrite defaults
  )
  # Create the reactable table
  table <- do.call(reactable::reactable, arguments)
  # Download button - y/n
  output <- if (downloadable) {
    htmltools::tagList(table, download_button)
  } else {
    htmltools::tagList(table)
  }
  # Make browsable if interactive
  if (interactive()) {
    htmltools::browsable(output) # required to work inside RStudio
  } else {
    output
  }
}
