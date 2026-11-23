write_words_rating_lm_tbl <- function(input, output, data) {
  
  output$words_rating_lm <- render_gt({
    
    data <- data |> 
      nest(.by = sp4, .key = "data") |> 
      mutate(
        model = map(data, \(x) lm(rating ~ prop, data = x)),
        tidy  = map(model, \(x) broom::tidy(x))
      ) |> 
      select(sp4, tidy) |>
      unnest(tidy) |> 
      mutate(
        sp4 = sp4 |> str_to_title(),
        term = term |> replace_when(
          term == "(Intercept)" ~ "Intercept",
          term == "prop" ~ "Slope"
        ),
        across(estimate:statistic, ~format_value(.)),
        p.value = p.value |> format_p(name = NULL) |> str_remove("^0")
      ) |>
      group_by(sp4) |> 
      select(-statistic)
    
    if (input$filter_words_rating_lm_tbl != "All") {
      data <- data |> 
        ungroup() |> 
        filter(term == input$filter_words_rating_lm_tbl)
    }
    
    data |> 
      rename(Character = sp4, SE = std.error, p = p.value) |> 
      rename_with(.cols = c(term, estimate), str_to_title) |>
      gt() |> 
      cols_align(columns = p, "right") |> 
      tab_options(column_labels.padding = px(0)) |> 
      opt_interactive(
        use_sorting = TRUE,
        use_pagination = FALSE,
        use_compact_mode = TRUE
      )
    
  })
  
}

draw_words_rating_plot <- function(data) {
  
  data |> 
    ggplot(aes(prop, rating, color = sp4)) +
    geom_point() + 
    geom_smooth(aes(fill = sp4), method = "lm") +
    scale_x_continuous(labels = \(x) format_percent(x, digits = 0)) +
    scale_color_viridis_d(
      end = 0.9, direction = -1, labels = \(x) x |> str_to_title()
    ) +
    scale_fill_viridis_d(
      end = 0.9, direction = -1, labels = \(x) x |> str_to_title()
    ) +
    facet_wrap(~sp4, ncol = 2) +
    labs(x = "Proportion of Words in an Episode", y = "Rating") +
    gg_theme +
    theme(
      legend.position = "none",
      strip.text = element_text(size = 14, color = "white"),
      strip.background = element_rect(fill = dark_teal)
    )
  
}
