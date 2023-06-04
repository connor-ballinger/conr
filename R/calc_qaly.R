# # Calculate QALY with Dataframe Inputs
# #
# # description Calculate quality-adjusted life-years using utility scores from
# #   a dataframe and the trapezium method.
# # Either a qaly for each person, or use the function on a summarised dataframe, to calculate a qaly for each arm.
#
# calc_qaly <- function (
#     df,
#     qol,
#     periods # need to check that this is longer than 2 elements
# ) {
#
#   multiplier = seq
#
#   mutate(
#     df,
#     qaly =
#   )
#
#
#   # mutate(
#   #   df,
#   #   qaly = sum(
#   #     (0 + {{ var1 }}) * p1 +
#   #       ({{ var1 }} + {{ var2 }}) * p2 +
#   #       ({{ var2 }} + {{ var3 }}) * p3
#   #   ) / 104
#   # )
#
# }
#
# # to extend periods prior to element-wise multiplication
# rep(periods, times = c(1, 2*is.numeric(periods[2:length(periods)-1]), 1))
#
#
# testdf <- tribble(
#   ~id, ~u1, ~u2, ~u3,
#     1, 0.8, 0.9, 0.4
# )
# weeks <- c(4, 5)
#
#
# # need u1, u2, u2, u3 such that we have 4 * (u1+u2) + 5 * (u2+u3) = 4*u1 + 4*u2 + 5*u2 + 5*u3
# # so, need to make duplicate columns for all utilities except first and last. Or is there a better way?
#
# testdf |> mutate(qaly = sum(weeks * c(u1, u2, u3)))
#
# # only works if >2 periods
# rep(v, times = c(1, 2*is.numeric(v[2:length(v)-1]), 1))
