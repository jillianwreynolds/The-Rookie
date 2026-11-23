output$ratings_animation <- renderPlot({
    
    data <- ratings_dist() |> mutate(season = season |> as_factor())
    
    if (input$ratings_slider != 0) {
      data <- data |> filter(season == input$ratings_slider)
    }
    
    plot <- data |> 
      ggplot(aes(rating, n)) + 
      labs(x = "Rating", y = "Number of Episodes") +
      scale_y_continuous(expand = expansion(c(0, 0.05))) +
      gg_theme
    
    if(input$ratings_slider == 0) {
      plot <- plot + 
        geom_col(aes(fill = season)) +
        scale_fill_viridis_d() +
        labs(fill = "Season") +
        theme(
          legend.position = c(0.005, 0.995),
          legend.justification = c(0, 1)
        )
    }
    
    if (input$ratings_slider != 0) {
      plot <- plot + geom_col(fill = viridis[input$ratings_slider])
    }
    
    break_skip <- if (input$full_rating_scale2) 1 else 0.5
    
    if (input$full_rating_scale2) {
      plot <- plot + 
        scale_x_continuous(
          breaks = seq(0, 10, break_skip),
          expand = expansion(c(0, 0))
        ) +
        coord_cartesian(xlim = c(0, 10), ylim = c(0, 20)) +
        theme(plot.margin = margin(5.5, 10, 5.5, 5.5))
    } else {
      plot <- plot +
        scale_x_continuous(breaks = seq(0, 10, break_skip)) +
        coord_cartesian(xlim = c(min_rating(), max_rating()), ylim = c(0, 20))
    }
    
    plot
    
  })
