library(testthat)

test_that('The data loaded is a tibble', {

data = system.file('extdata', 'accident_2013.csv.bz2', package = 'farsfunction')
farsData = fars_read(data)
      expect_s3_class(farsData, 'tbl')
})


test_that('the year is added as mentioned in the documentation', {

  fileName = make_filename(2013)
    expect_that(fileName, 'accident_2013.csv.bz2')
})






