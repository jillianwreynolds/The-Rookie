draw_viewers_stats_plot <- function(data) {
  
  data |> 
    pivot_longer(2:last_col(), names_to = "stat", values_to = "value") |> 
    filter_out(stat == "SD") |> 
    ggplot(aes(season, value, color = stat, group = stat)) +
    geom_point(aes(color = fct_reorder2(stat, season, value))) +
    geom_line(
      aes(
        color = fct_reorder2(stat, season, value),
        linetype = fct_reorder2(stat, season, value)
      ),
      linewidth = 0.75,
      alpha     = 0.5
    ) +
    scale_x_continuous(breaks = 1:8, minor_breaks = NULL) +
    scale_color_viridis_d(end = 0.9, labels = \(x) x |> str_to_title()) +
    scale_linetype_manual(
      values = c(
        "max" = "solid", "q3" = "dotdash", "median" = "dashed",
        "mean" = "dotted", "q1" = "twodash", "min" = "longdash"
      ),
      labels = \(x) x |> str_to_title()
    ) +
    labs(
      x = "Season", y = "Number of US Viewers (in Millions)",
      color = "Statistic", linetype = "Statistic"
    ) +
    gg_theme
  
}

write_viewers_stats_tbl <- function(data) {
  
  data |> 
    clean_col_names() |> 
    gt() |> 
    fmt_number(2:last_col()) |> 
    cols_align("center", 1) |> 
    cols_label("Sd" ~ "SD") |> 
    opt_interactive(
      use_sorting = TRUE,
      use_pagination = FALSE
    )
  
}
