#' Basic bootstrap
#'
#' @param df dataframe
#' @param tmt treatment arm identifier - currently only assuming two arms
#' @param effect effect column(s)
#' @param cost cost column (not multiple currently)
#' @param periods vector of weeks between each QoL measure, if applicable
#' @param i needed for `boot::boot`
#'
#' @return A named vector of mean incremental effect and cost and icer.
#' @export
#'
#' @examples
#' # pass named args of bootstrap_basic to boot::boot
#' df <- fake_health_ec_data
#' if (requireNamespace("boot")) { # check boot is installed
#'   boot <- boot::boot(
#'     df,
#'     bootstrap_basic,
#'     R = 100,
#'      strata = df$tmt,
#'     tmt = "tmt",
#'     effect = starts_with("utility"),
#'     cost = "cost",
#'     periods = c(10, 5, 20)
#'   )
#' }
bootstrap_basic <- function(df, tmt, effect, cost, periods = NULL, i) {
  sampled <- df[i, ]

  means <- sampled |>
    summarise(
      across(
        .cols = c({{ effect }}, {{ cost }}),
        .fns = ~ mean(.x, na.rm = TRUE)
      ),
      .by = {{ tmt }}
    )

  if (!is.null(periods)) {
    # implying a qaly is required

    means$qaly <- calc_qaly(means, {{ effect }}, periods)
    effect_inc <- fn_calc_increment(means, qaly)
  } else {
    # implying we are dealing with a plain effect estimate

    effect_inc <- fn_calc_increment(means, {{ effect }})
  }

  cost_inc <- fn_calc_increment(means, {{ cost }})

  c(
    "effect" = effect_inc,
    "cost" = cost_inc,
    "icer" = cost_inc / effect_inc
  )
}

# helper function for second row minus first row
fn_calc_increment <- function(df, col) { # tidyselect is handy
  dplyr::pull(df, {{ col }}) |>
    diff()
}
