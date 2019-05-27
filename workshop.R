# use gitignore if you don't want to version control any files
# can do this for large data which doesn't need any changes

data("mtcars")

# creates description and namespace files
usethis::use_description()
usethis::use_namespace()

# Create R directory
base::dir.create("R")

# creates Package-level documentation so you can run ?nameofpackage
usethis::use_package_doc()

# created README.Rmd for Github landing page
# an .Rbuildignore file gets created
usethis::use_readme_rmd()

# creates license file
usethis::use_mit_license("Sahir Bhatnagar")

# creates news file
usethis::use_news_md()

# setup continuous integration via travis-ci
usethis::use_travis()

# sets up testing infrastructure
usethis::use_testthat()

?rpkgs
rpkgs::
  pacman::p_functions(rpkgs)

#this will setup the folders needed for the data and raw-data
usethis::use_data_raw()

# load required packages ----
if (!require("pacman")) install.packages("pacman") 
pacman::p_load(magrittr, dplyr, usethis, data.table, here)

# clean data ----
epil <- read.csv(here::here("data-raw","epil.csv"))
DT <- epil %>% as.data.table
DT.base <- DT %>% distinct(subject, .keep_all = TRUE)
DT.base[,`:=`(period=0,y=base)]
DT.epil <- rbind(DT, DT.base)
setkey(DT.epil, subject, period)
DT.epil[,`:=`(post=as.numeric(period>0), tj=ifelse(period==0,8,2))]
df_epil <- as.data.frame(DT.epil) %>% dplyr::select(y, trt, post, subject, tj)

# write data in correct format to data folder ----
usethis::use_data(df_epil, overwrite = TRUE)

devtools::document()

pacman::p_load(sinew)
sinew::makeOxyFile("R/fit_models.R")

devtools::document()

usethis::use_package("lme4", type = "Imports")
usethis::use_package("lme4", type = "Suggests")

?df_epil


  