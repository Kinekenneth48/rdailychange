data("sample_data")
sample_data = force(sample_data)
sample_data = as.data.table(sample_data)

t = sample_data[ID == "USW00023062"][, head(.SD, 200)]


test <- list(c(22.55386229, 7.34369854, 13.67618618, 0.06114788, 5.27577624,
               20.31926993, 0.03138523, 0.01574044, 0.01563051, 0.01552242,
               31.56057577, 0.06424583, 0.05159091, 11.57542606, 21.09025254,
               0.05916445, 0.02465813, 12.36608807, 6.39794186, 37.63296685,
               0.03546841),
             c(29.89756084, 13.73733407, 0.03137095, 32.66567860, 37.66843526),
             c(10.5955019,  26.74611491, 16.0924683))


#test for day_1
day.1 <- extract_observations(t, day = 1)
day1 <- list(data.frame(day.1)[, 6])

testthat::test_that("day 1 works well", {
  expect_equal(day1, test[1])
})

#test for day_2
day.2 <- extract_observations(t, day = 2)
day2 <- list(data.frame(day.2)[, 6])

testthat::test_that("day 2 works well", {
  expect_equal(day2, test[2])
})

#test for day_3
day.3 <- extract_observations(t, day = 3)
day3 <- list(data.frame(day.3)[, 6])

testthat::test_that("day 3 works well", {
  expect_equal(day3, test[3])
})
