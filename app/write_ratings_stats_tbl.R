write_ratings_stats_tbl <- function(data) {
  
  data |> 
    mutate(
      season = season |> as.character()
    ) |> 
    relocate(max, .after = q3) |> 
    rename(minimum = min, maximum = max) |>
    clean_col_names() |> 
    rename(SD = Sd) |> 
    gt() |> 
    fmt_number(drop_trailing_zeros = FALSE) |> 
    opt_interactive(
      use_pagination = FALSE,
      use_sorting = TRUE,
      use_highlight = TRUE
    )  
  
}
