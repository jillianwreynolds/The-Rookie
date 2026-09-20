create_crossover_chars_wide <- function(tbl) {
  
  rows_order <- tbl |> 
    mutate(row = row_number()) |> 
    select(ends_with("name"), row)
  
  tbl |> 
    mutate(
      season = str_c("season_", season)
    ) |>
    arrange(season) |> 
    pivot_wider(
      id_cols = c(first_name, last_name, actor),
      names_from = season,
      values_from = status
    ) |>
    left_join(rows_order) |> 
    arrange(row) |> 
    select(-row) |> 
    distinct(first_name, last_name, .keep_all = TRUE) |> 
    relocate(actor, .after = last_col())
  
}
