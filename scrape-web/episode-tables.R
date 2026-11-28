# Originally scraped on November 27, 2026 between 4 and 5 pm

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
  write_parquet("data/Wikipedia/episodes_table_parquet.parquet")
