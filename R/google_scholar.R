library(tidyverse)
library(scholar)
library(here)

boyi_id <- "gzkXHEIAAAAJ"
profile <- get_profile(boyi_id)

g_pubs <- as_tibble(get_publications(boyi_id)) |> 
  select(-cid)


# Merge New Pubs ----------------------------------------------------------
if(!file.exists(here("data", "pubs.csv"))){
  data.frame(
    g_pubs,
    first_author = NA,
    type = NA_character_, # c("Collab", "Method"),
    preprint = NA
  ) |> 
    readr::write_csv(file = here("data", "pubs.csv"))
}


sorted_pub <- read_csv(file = here("data", "pubs.csv"))



## Remove Dissertation/Abstract ------------------------------------------

rm_pubid <- c(
  "qxL8FJ1GzNcC", 
  "roLk4NBRz8UC",
  "WF5omc3nYNoC",
  "eQOLeE2rZwMC",
  "YsMSGLbcyi4C",
  "W7OEmFMy1HYC",
  "Y0pCki6q_DkC")


sorted_pub |> 
  left_join(g_pubs, by = colnames(g_pubs)) |> 
  filter(
    ! (pubid %in% rm_pubid)
  ) |> View()

stopifnot("Please organize publication CVS file (path: data/pubs.csv)" = sorted_pub |> 
            select(first_author, type, preprint) |> 
            complete.cases() |>
            all())


