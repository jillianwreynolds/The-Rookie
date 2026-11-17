# plots -------------------------------------------------------------------

plot_ratings_stats_code <- function(data) { 
  data |> 
    group_by(season) |> 
    summarise(
      min = min(rating),
      q1 = quantile(rating, 0.25),
      median = median(rating),
      q3 = quantile(rating, 0.75),
      mean = mean(rating),
      max = max(rating)
    ) |> 
    pivot_longer(2:last_col(), names_to = "stat", values_to = "value") |> 
    ggplot(aes(season, value)) +
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
    scale_y_continuous(expand = expansion(c(0, 0))) +
    scale_color_viridis_d(end = 0.85, labels = \(x) x |> str_to_title()) +
    scale_linetype_manual(
      values = c(
        "max" = "solid", "q3" = "dotdash", "median" = "dashed",
        "mean" = "dotted", "q1" = "twodash", "min" = "longdash"
      ),
      labels = \(x) x |> str_to_title()
    ) +
    labs(
      x = "Season", y = "Rating", color = "Statistic", linetype = "Statistic"
    ) +
    coord_cartesian(ylim = c(0, 10)) +
    gg_theme
}
