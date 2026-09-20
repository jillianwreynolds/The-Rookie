create_recurring_chars_wide <- function(tbl) {
  
  tbl |>
    arrange(season) |> 
    mutate(season = str_c("season_", season)) |> 
    pivot_wider(
      id_cols = c(first_name, last_name, actor),
      names_from = season,
      values_from = status
    ) |> 
    relocate(actor, .after = last_col())
  
}
