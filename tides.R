library("tidyverse")
library("httr")

# function that takes a station_id string and a begin_date string in format of 20220708
# saves data to csv file, prints a message, and returns nothing.
# couldn't quite parse response to data frame directly, could be nice later.
get_station_data <- function(station_id, begin_date) {
  data_url <- sprintf("https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?product=water_level&application=NOS.COOPS.TAC.WL&begin_date=%s&end_date=20220709&datum=MLLW&station=%s&time_zone=GMT&units=english&format=csv", begin_date, station_id)
  resp <- httr::GET(data_url)
  c <- content(resp, "raw")
  dir.create("./output_data/", showWarnings = FALSE)
  writeBin(c, sprintf("output_data/%s_%s.csv", station_id, begin_date))
  print(sprintf("Saved data for: %s_%s", station_id, begin_date))
}

# data starting from:
begin_date <- "20220708"

# Bar Harbor, Maine
# station_id <- "8413320"

# The Battery New York, New York
station_id <- "8518750"

# data from https://tidesandcurrents.noaa.gov/waterlevels.html?id=8518750
# https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?product=water_level&application=NOS.COOPS.TAC.WL&begin_date=20220708&end_date=20220709&datum=MLLW&station=8518750&time_zone=GMT&units=english&format=csv
get_station_data(station_id, begin_date)

nyc_water_levels_raw <- read_csv(sprintf("./output_data/%s_%s.csv", station_id, begin_date))

nyc_water_levels <- nyc_water_levels_raw %>%
  rename(
    timestamp = "Date Time",
    water_level = "Water Level",
    sigma = "Sigma")

ggplot(data = nyc_water_levels, aes(x=timestamp, y=water_level)) +
  geom_line()
