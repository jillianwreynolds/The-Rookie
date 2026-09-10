create_main_chars_long <- function(tbl) {
 
  tbl |> 
    pivot_longer(
      starts_with("season"), names_to = "season", values_to = "status"
    ) |> 
    relocate(actor, .after = last_col()) |> 
    mutate(
      across(ends_with("name"), str_to_upper),
      season = season |> str_remove("season_") |> as.integer()
    )
   
}
