#' Fix Cell Types From Excel
#'
#' @param df dataframe.
#' @param cols columns which are formatted as strings but should be numeric.
#'
#' @return a nicer dataframe.
#' @export
#'
#' @examples
fix_excel_cols <- function(df, cols) {
  mutate(
    df,
    across(
      .cols = {{ cols }},
      .fns = ~ as.numeric(gsub("\\%|\\,|\\$", "", .))
    )
  )
}
