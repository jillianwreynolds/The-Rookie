# originally scraped on September 10, 2026 between 1 am and 2 am

recurring_characters_text <- "https://en.wikipedia.org/wiki/The_Rookie" |> 
  read_html() |> 
  html_elements("#mwARg") |> 
  html_text()

recurring_characters_text |>
  str_split("\n") |> 
  tibble(text = _) |> 
  unnest(text) |> 
  write_csv("recurring_characters.csv")
