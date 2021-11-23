#'Reading the Fars Data
#'
#'@description reading the csv file and returning a dataframe
#'
#'@param filename name of the file of the dataset
#'
#'@return dataframe converted from the read csv
#'
#'@import readr
#'@import tibble
#'
#'
#'@examples
#' \dontrun{
#'   fars_read("accident_2013.csv.bz2")
#' }
#'@export
#'

fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  tibble::as_tibble(data)
}


#'Create a file for the dataset
#'
#'@description creates a name for the accident file based on the year provided.
#'
#'@param year the year to be added to the filename
#'
#'@return a filename with the year entered
#'
#'@examples
#' \dontrun{
#' make_filename(2018)
#' }
#'
#'@export
#'


make_filename <- function(year) {
  year <- as.integer(year)

data =   system.file('extdata',
        sprintf("accident_%d.csv.bz2", year), package = "farsfucntions")
return(data)
}

#'Read FARS data from multiple years
#'
#'if the years provided are valid, then the function would load the years
#'
#'@param years a string vector of years
#'
#'@return A dataframe of the fars data in month and year, if the invalid year in
#'entered then NULL would be returned
#'
#'@examples
#'\dontrun{
#'fars_read_years(c(2012,2013))
#'}
#'
#'@import dplyr
#'@export

fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, YEAR) %>%
        dplyr::select(MONTH, YEAR)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#'Summarizing the farsdata by months
#'
#'Monthly number of accident in each months in the years mentioned
#'
#'@param years the values of years to be summarizied
#'
#'@return a dataframe with monthly number of accidents and years
#'
#'@import tidyr
#'@import dplyr
#'
#'@examples
#'\dontrun{
#' fars_summarize_years(c(2012,2013))
#'}
#'
#'@export



fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(YEAR, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(YEAR, n)
}

#'Visualize the location of accidents in given state for a given year
#'
#'@param state.num The state numeric code
#'@param year The year of interest
#'
#'@return plot of the occurance of the accidents
#'
#'@import maps
#'@import graphics
#'
#'@examples
#'\dontrun{
#'fars_map_state(15, 2013)
#'}
#'
#'@export



fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)
  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state",
              ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
