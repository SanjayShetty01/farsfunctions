# farsfunctions

[![R-CMD-check](https://github.com/SanjayShetty01/farsfunctions/workflows/R-CMD-check/badge.svg)](https://github.com/SanjayShetty01/farsfunctions/actions)

[![Build Status](https://app.travis-ci.com/SanjayShetty01/farsfunctions.svg?branch=main)](https://app.travis-ci.com/SanjayShetty01/farsfunctions)


The package is to be used for manipulating the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System [data](https://www.nhtsa.gov/), which is a nationwide census providing the American public yearly data regarding fatal injuries suffered in motor vehicle traffic crashes. All the operations are done as per the instructions given in the [Cousera: Building R Packages Course](https://www.coursera.org/learn/r-packages/home/welcome).

## Installation

To load the package. You must first install `devtools` package from CRAN.

```
install.packakes('devtools') # installing devtools

devtools::install_github('SanjayShetty01/farsfunctions')
```


## Usage

About the functions,

`fars_read` : the function can be used to read the `.csv.bz2` fileformat into a tibble

`make_filename` : the function is used to create a name for the accident file based on the year provided.

`fars_read_year` : This funciton utilizes the `make_filename(YEAR)` function to turn the years for which data is required into the character format. If a csv file for the given year does not exist the function with produce a warning message and return a NULL

`fars_summarize_years` : The function returns the monthly number of accident in each months in the years mentioned

`fars_map_state` : The function visualizes the location of accidents in given state for a given year


Use `browseVignettes` read the `vignette` provided in this package.

