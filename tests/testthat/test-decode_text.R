test_that("underscores replaced", {
  expect_equal(decode_text("A_B"), "A B")
})
test_that("title case", {
  expect_equal(decode_text("abc"), "Abc")
})
test_that("periods replaced", {
  expect_equal(decode_text("A.B"), "A B")
})
