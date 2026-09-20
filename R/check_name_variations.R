check_name_variations <- function(tbl = df_raw, pattern) {
  
  if (!str_detect(pattern, "Ma?c[A-Z]") && str_detect(pattern, "[a-z]")) {
    pattern <- pattern |> str_to_upper()
  }
  
  tbl |> 
    select(season, episode, speaker) |> 
    filter(str_detect(speaker, pattern)) |> 
    collect() |> 
    distinct(season, episode, speaker) |> 
    arrange(season, episode)
  
}
