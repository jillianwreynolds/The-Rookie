# Originally scraped on November 27, 2026 between 3 and 4 pm

url <- "https://en.wikipedia.org/wiki/List_of_The_Rookie_episodes#Episodes"

url |> 
  read_html() |> 
  html_elements(".wikiepisodetable .module-episode-list-row") |> 
  html_text2() |> 
  tibble() |> 
  separate_wider_delim(everything(), delim = "\t", names = c(
    "number_in_series", "episode", "title", 
    "director", "writer",
    "release_date", "prod_code",
    "US_viewers"
  )) |> 
  mutate(
    title = title |> str_remove("^\"") |> str_remove("\"$"),
    director = director |> str_remove("\n"),
    release_date = release_date |> 
      str_extract("(?<=\\().+(?=\\))") |> 
      ymd(),
    season = prod_code |> str_extract("^."),
    US_viewers = US_viewers |> 
      str_remove("\\[.+$") %>% 
      replace_when(str_detect(., "N/A") ~ NA_character_) |> 
      as.double()
  ) |> 
  relocate(season, .after = number_in_series) |> 
  write_parquet("data/Wikipedia/episodes_table.parquet")
