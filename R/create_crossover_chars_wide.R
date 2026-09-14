create_crossover_chars_wide <- function(tbl) {
  
  tbl |> 
    mutate(
      col_names = str_c("season_", season),
      season = season |> str_replace("\\d+", "appears")
    ) |>
    pivot_wider(names_from = col_names, values_from = season) |>
    select(-text) |>
    relocate(c(alias, actor), .after = season_8)
  
}
