# originally scraped on September 10, 2026 between 12 am and 1 am
  
tables <- read_html("https://en.wikipedia.org/wiki/The_Rookie") |> 
  html_elements("table") |> 
  html_table()

season_tbl <- tables[[3]]

season_tbl_colnames <- season_tbl[1, ]

colnames(season_tbl) <- season_tbl_colnames

season_tbl |> 
  slice(-1) |> 
  rename_with(.cols = 1:2, str_to_lower) |> 
  rename_with(.cols = 3:10, \(x) str_c("season_", x)) |> 
  mutate(
    across(
      starts_with("season"), 
      \(x) x |> 
        str_remove_all("\\[[a-z]\\]") |>
        str_to_lower()
    ),
    across(starts_with("season"), \(x) na_if(x, "does not appear"))
  ) |>
  separate_wider_delim(
    character, delim = " ", names = c("character_first", "character_last")
  ) |>
  write_csv(file = "characters.csv")
