clean_episodes_table <- function(data) {
  
  data |> 
    mutate(
      title = title |> str_remove("^\"") |> str_remove("\"$"),
      director = director |> str_remove("-\n"),
      release_date = release_date |> 
        str_extract("(?<=\\().+(?=\\))") |> 
        ymd(),
      season = prod_code |> str_extract("^."),
      US_viewers = US_viewers |> 
        str_remove("\\[.+$") %>% 
        replace_when(str_detect(., "N/A") ~ NA_character_) |> 
        as.double()
    ) |> 
    relocate(season, .after = number_in_series)
  
}
