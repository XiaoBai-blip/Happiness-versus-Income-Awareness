#### Preamble ####
# Purpose: Clean the survey data downloaded from The American Economic Review
# Author: Xiao Bai & Yichun Zhang
# Data: 27 February 2022
# Contact: x.bai@mail.utoronto.ca
# License: MIT



#### Workspace setup ####
# Use R Projects, not setwd().
library(tidyverse)
library(haven)
library(tidyr)
library(reshape2)
# Read in the raw data. 

survey_data = read_dta("Raw-Norwegian-Monitor-Survey-Data.dta", encoding = 'latin1')
country_data = read_dta("google_searches_by_country.dta", encoding = 'latin1')
time_data = read_dta("google_searches_over_time.dta", encoding = 'latin1')
#names_data = read_dta("names_browsing_skattelister.dta", encoding = 'latin1')

# Just keep some variables that may be of interest
# Since the original data contain many observations that exceed the maximum 
# load and are useless for further analysis, we create a new table with the 
# corresponding variables and then plot a bar graph.
country_hah <- read.table(text = "keyword    Norway    Sweden
                  'Skattelister'   21.686750      0
                  'Tax'  7.228915      2.325581
                  'Weather'   18.072290      23.255819
                  'Youtube'   100.000000      100.000000
                  ",
                          header = TRUE, stringsAsFactors = FALSE)

# We try to let R read the variables, so we use gather function
df2 <- country_hah %>% 
  gather(Country, Value,-keyword)

#Since the author use Stata to conduct analysis, the format of data is quite 
#different than conducting using R, so we use melt function to takes data in wide format 
#and stacks a set of columns into a single column of data, and save it into time_data3
time_date3 = melt(time_data, id.vars = "edate", measure.vars = c("tax", "weather","skattelister","youtube"))
#This section we mutate a new variable called transparency to separate the 
#time interval
survey_data1 = survey_data %>%
  mutate(transparency = if_else(year %in% 2001:2013, 1,0))


         