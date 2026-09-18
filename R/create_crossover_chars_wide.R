create_crossover_chars_wide <- function(tbl) {
  
  tbl |> 
    mutate(
      col_names = str_c("season_", season),
      season = season |> str_replace("\\d+", "appears")
    ) |>
    pivot_wider(names_from = col_names, values_from = season) |>
    relocate(season_2, .before = season_4) |> 
    relocate(actor, .after = last_col())
  
}
