#' Print Regression Summary Table
#'
#' @description Use modelsummary and flextable to produce a regression table.
#'
#' @param models Regression model(s).
#' @param accuracy Argument in scales::label_number(accuracy = 1).
#' @param omit Argument in modelsummary::modelsummary(gof_omit = omit).
#'
#' @return Flextable::flextable.
#' @export
#' @importFrom flextable flextable
#' @importFrom flextable nrow_part
#' @importFrom modelsummary modelsummary
#' @importFrom scales label_number
#'
#' @examples
print_regrsn <- function(models = list(), accuracy = 1, omit = c("Num.Obs")) {
  if (gof_map[gof_map$raw == "icc", "fmt"] != 2) {
    gof_map[gof_map$raw == "icc", "fmt"] <- 2
    gof_map[grep("^R2", gof_map$clean), "fmt"] <- 2
    gof_map[gof_map$raw %in% c("aic", "bic", "F", "logLik", "rmse"), "fmt"] <- 0
  }

  mod_sum <- modelsummary::modelsummary(
    models = models,
    output = "flextable",
    fmt = scales::label_number(accuracy = accuracy, big.mark = ","),
    gof_omit = omit,
    stars = c("*" = .1, "**" = .05, "***" = 0.01)
  )
  flextable::bg(
    mod_sum,
    bg = "grey98",
    i = seq(from = 2, to = flextable::nrow_part(mod_sum), by = 2)
  )
}
