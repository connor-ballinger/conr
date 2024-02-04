## code to prepare `fake_health_ec_data` dataset goes here

library(tidyverse)

set.seed(123)

sim_utility <- function(alpha, beta) {
  (1.5 * rbeta(n = 300, shape1 = alpha, shape2 = beta, ncp = 0)) - 0.5
  # EQ-5d goes to -1.5 ish
}

df1 <- tibble(
  id = 1:300,
  day = round(id * 3.3 + sample.int(7, size = 300, replace = TRUE)),
  cluster = sample(
    LETTERS[1:5],
    size = 300,
    replace = TRUE,
    prob = c(0.1, 0.35, 0.15, 0.25, 0.15)
  ),
  age = round(18 + 70 * rbeta(n = 300, shape1 = 3, shape2 = 2)),
  male = rbinom(n = 300, size = 1, prob = 0.66),
  utility0 = sim_utility(9, 2),
  utility1 = 0.1 * utility0 + sim_utility(0.8, 1.2),
  utility2 = 0.01 * utility0 + 0.1 * utility1 + sim_utility(2, 1),
  utility3 = 0.05 * utility1 + 0.1 * utility2 + sim_utility(6, 2),
  cost = 100000 *
    round(
      rbeta(n = 300, shape1 = 0.3, shape2 = 0.9) *
        (1.5 - utility0) *
        (1.5 - utility3),
      3
    )
)

# create tmt dummy, note clusters transition once each.

portions <- c(0.7, 0.6, 0.5, 0.4, 0.3) # later clusters "treat" fewer patients
clusters <- sort(unique(df1$cluster))
df2 <- map2(
  .x = clusters,
  .y = portions,
  \(x, y)
  df1 |>
    filter(cluster == x) |>
    slice_tail(prop = y)
) |>
  list_rbind() |>
  mutate(tmt = "1", .before = age)


fake_health_ec_data <- df1 |>
  filter(!is.element(id, df2$id)) |>
  mutate(tmt = "0", .before = age) |>
  rbind(df2) |>
  arrange(id)

# create missing data
for (i in sample.int(300, size = 40, replace = TRUE)) {
  for (j in sample(c("utility0", "utility1", "utility2", "utility3"),
    size = 1, replace = TRUE
  )) {
    fake_health_ec_data[i, j] <- NA
  }
}

rm(list = setdiff(ls(), "fake_health_ec_data"))

usethis::use_data(fake_health_ec_data, overwrite = TRUE)
