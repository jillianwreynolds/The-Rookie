library(shiny)
library(shinyjs)
library(tidyverse)
library(glue)
library(DT)
library(gt)
library(bslib)
library(patchwork)
library(plotly)
library(insight)

list(
  "colors.R",
  "themes.R",
  "styles.R",
  "functions.R",
  "top6_card.R",
  "median_season_ratings.R",
  "about.R",
  "draw_chars_gender_plot.R",
  "write_top6_summary_stats_tbl.R",
  "draw_ratings_stats_plot.R",
  "write_ratings_stats_tbl.R",
  "draw_best_worst_eps_speakers_plot.R",
  "words_rating.R"
) |> 
  walk(\(x) source(x))

# Number of seasons
n_seasons <- 8


# UI nav_panels -----------------------------------------------------------

## home panel --------------------------------------------------------------

### cards ------------------------------------------------------------------

cards_home <- list(
  directory = card(
    card_header(
      "Episode Directory",
      class = "bg-secondary",
      tooltip(
        bsicons::bs_icon("info-circle"),
        "To filter episodes by season, click the gear icon to the right.",
        placement = "right"
      ),
      popover(
        bsicons::bs_icon("gear", title = "Settings", class = "ms-auto"),
        title = "Filter by Season",
        selectInput(
          "filter_season",
          label = NULL,
          choices = 1:n_seasons,
          multiple = TRUE
        ),
        actionButton(
          "reset_season_filter", "Reset Filter", class = "btn-reset"
        ),
        placement = "right"
      )
    ),
    gt_output("episodes"),
    min_height = "600px"
  ),
  series_stats = card(
    card_header("Series Statistics", class = "bg-secondary"),
    gt_output("series_stats")
  )
)


### value boxes -----------------------------------------------------------

home_vbs <- list(
  n_episodes = value_box(
    id = "n_episodes_vb",
    glue("episodes across {n_seasons} seasons"),
    textOutput("n_episodes"),
    showcase = bsicons::bs_icon("camera-reels"),
    # showcase_layout = "top right",
    class = "value-first"
  ),
  ratings = median_season_ratings_UI("msr_home")
)

### nav_panel -------------------------------------------------------------

home_panel <- nav_panel(
  useShinyjs(), # triggers warning about expected contents of nav containers
  title = "Home",
  p("By Jillian W. Reynolds", style = "font-size:22px"),
  layout_column_wrap(
    layout_column_wrap(
      cards_home$series_stats,
      layout_column_wrap(width = 1, home_vbs$n_episodes, home_vbs$ratings),
      top6_UI("top6_home"),
      # style = css(grid_template_columns = "4fr 1fr 1fr")
    ),
    fillable = FALSE
  ),
  layout_column_wrap(
    width = 1/3,
    card(class = "empty-card"),
    cards_home$directory,
    style = css(grid_template_columns = "1fr 2fr 1fr")
  )
)


## characters panel --------------------------------------------------------

### cards ------------------------------------------------------------------

char_types <- c("Main" = "main", "Recurring" = "recurring")

cards_characters <- list(
  words_by_character = card(
    card_header(
      "Number of Words by Character",
      class = "bg-secondary",
      tooltip(
        bsicons::bs_icon("info-circle"),
        "This table lists characters from *The Rookie*'s Wikipedia page, specifically those in the lists of main or recurring characters. Future analysis will focus on a subset of these characters.",
        placement = "right"
      )
    ),
    layout_column_wrap(
      checkboxGroupInput(
        "char_type_filter",
        "Filter by Character Type",
        choices = char_types,
        selected = char_types
      ),
      uiOutput("char_selection")
    ),
    gt_output("words_by_chars")
  ),
  top6_plot = card(
    full_screen = FALSE,
    card_header(
      "Words per Season for the Top 6 Speakers",
      class = "bg-secondary",
      tooltip(
        bsicons::bs_icon("info-circle"),
        '"Count" shows total number of words spoken by each character in each season. "Proportion" shows the proportion of words spoken by each character in each season (character\'s number of words in a season divided by total words in the season) as a percent.',
        placement = "right"
      )
    ),
    radioButtons(
      "word_stat",
      label = "Statistic",
      choices = c("Count" = "n", "Proportion" = "prop"),
      selected = "n"
    ),
    plotlyOutput("top6_plot")
  ),
  gender_plot = card(
    full_screen = TRUE,
    card_header("Character Genders by Character Type", class = "bg-secondary"),
    plotOutput("chars_gender_plot")
  ),
  top6_stats = card(
    card_header(
      "Summary Statistics for the Top 6 Speakers",
      class = "bg-secondary",
      tooltip(
        bsicons::bs_icon("info-circle"),
        "Click column headings to sort values in ascending or descending order.",
        placement = "right"
      )
    ),
    uiOutput("filter_top6_stats_UI"),
    gt_output("top6_stats")
  )
)

### nav_panel -------------------------------------------------------------

characters_panel <- nav_panel(
  title = "Characters",
  layout_column_wrap(
    fillable = FALSE,
    top6_UI("top6_chars_panel"),
    cards_characters$top6_plot,
    cards_characters$gender_plot,
    style = css(grid_template_columns = "3fr 7fr 7fr")
  ),
  layout_column_wrap(
    width = 1/2,
    # cards_characters$table,
    cards_characters$words_by_character,
    cards_characters$top6_stats,
    heights_equal = "row",
    style = css(grid_template_columns = "5fr 7fr")
  ),
  layout_column_wrap(
    fillable = FALSE,
    width = 1/2,
    # card(tableOutput("characters")),
    # card(tableOutput("chars_long")),
    # cards_characters$top6_stats,
    style = css(grid_template_columns = "3fr 4fr")
  ),#,
  # textOutput("chars_vec")
)

## ratings panel -----------------------------------------------------------

### cards ------------------------------------------------------------------

cards_ratings <- list(
  ratings = navset_card_pill(
    title = "Episode Ratings",
    full_screen = TRUE,
    nav_spacer(),
    nav_panel(
      "Plot",
      checkboxInput("full_rating_scale", "View full rating scale?"),
      plotOutput("ratings_plot")
    ),
    nav_panel(
      "Animation",
      checkboxInput("full_rating_scale2", "View full rating scale?"),
      tags$div(class = "rookie-slider", sliderInput(
        "ratings_slider",
        "Season",
        value = 0,
        min = 0,
        max = 8,
        step = 1,
        animate = animationOptions(interval = 1500, loop = TRUE)
      )),
      plotOutput("ratings_animation")
    ),
    nav_panel(
      "Table", gt_output("ratings")
    )
  ),
  ratings_stats = navset_card_pill(
    full_screen = TRUE,
    title = "Summary Statistics by Season",
    nav_spacer(),
    nav_panel("Plot", plotOutput("ratings_stats_plot")),
    nav_panel("Table", gt_output("ratings_stats_tbl"))
  ),
  speakers_prop = card(
    full_screen = TRUE,
    card_header("Proportions of Words in Highest and Lowest Rated Episodes for the Top 6 Speakers of the Series", class = "bg-secondary"),
    plotOutput("best_worst_eps_speakers")
  ),
  words_rating = card(
    card_header(
      "Proportion of Words vs. Episode Ratings",
      class = "bg-secondary",
      tooltip(
        bsicons::bs_icon("info-circle"),
        "lm(rating ~ percent)"
      )
    ),
    markdown("The association between proportion of words spoken in an episode (displayed as percentage in the figure) and average episode rating was not significant for any of *The Rookie*'s top six speakers."),
    layout_column_wrap(
      navset_card_pill(
          nav_spacer(),
          nav_panel("Plots", plotOutput("words_rating_plot")),
          nav_panel(
            "Table",
            toolbar(
              "Filter Rows",
              toolbar_input_select(
                "filter_words_rating_lm_tbl",
                label = "Filter Rows",
                choices = c(
                  "All", "Slopes" = "Slope", "Intercepts" = "Intercept"
                ),
                selected = "All"
              )
            ),
            gt_output("words_rating_lm")
          )
        )
    )
  )
)

### value boxes -----------------------------------------------------------

ratings_vbs <- list(
  median_season_ratings = median_season_ratings_UI("msr_ratings"),
  highest = value_box(
    "Highest Rating",
    value = textOutput("highest_rating"),
    textOutput("highest_rating_eps"),
    showcase = bsicons::bs_icon("arrow-up"),
    theme = "success-subtle"
  ),
  lowest = value_box(
    "Lowest Rating",
    value = textOutput("lowest_rating"),
    textOutput("lowest_rating_eps"),
    showcase = bsicons::bs_icon("arrow-down"),
    theme = "danger-subtle"
  ),
  average = value_box(
    "Average Rating",
    value = textOutput("average_rating"),
    textOutput("average_rating_eps"),
    theme = NULL,
    class = "vb-yellow"
  )
)

### nav_panel -------------------------------------------------------------

ratings_panel <- nav_panel(
  title = "Episode Ratings",
  layout_column_wrap(
    width = 1/2,
    heights_equal = "row",
    layout_column_wrap(
      width = 1/2,
      ratings_vbs$median_season_ratings,
      ratings_vbs$highest,
      ratings_vbs$average,
      ratings_vbs$lowest
    ),
    cards_ratings$ratings
  ),
  layout_column_wrap(
    cards_ratings$speakers_prop,
    cards_ratings$ratings_stats
  ),
  layout_column_wrap(
    width = 1/2,
    cards_ratings$words_rating
  )
)

# UI ----------------------------------------------------------------------

ui <- page_navbar(
  theme = rookie_theme,
  tags$style(type = "text/css", css),
  fillable = FALSE,
  navbar_options = navbar_options(bg = dark_teal),
  title = h1(
    em("The Rookie"), " Transcript Analysis",
    style = glue("color:{yellow}")
  ),
  nav_spacer(),
  home_panel,
  about_panel,
  characters_panel,
  ratings_panel
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  data <- reactive({
    withProgress(
      {
        tbl_episodes = nanoparquet::read_parquet("transcripts_parquet.parquet")
        incProgress(1 / 11)
        tbl_chars = nanoparquet::read_parquet("characters_parquet.parquet")
        incProgress(1 / 11)
        tbl_chars_long = nanoparquet::read_parquet("characters_long.parquet")
        incProgress(1 / 11)
        tbl_ratings = nanoparquet::read_parquet("episode_ratings.parquet")
        incProgress(1 / 11)
        tbl_tokens1_raw = nanoparquet::read_parquet("tokens1_raw.parquet")
        incProgress(7 / 11)
        list(
          episodes        = tbl_episodes,
          characters      = tbl_chars,
          characters_long = tbl_chars_long,
          ratings         = tbl_ratings,
          tokens1_raw     = tbl_tokens1_raw
        )
      },
      message = "Loading data...",
      detail = "This may take several seconds...",
      value = 0
    )
  })
  
  n_episodes <- reactive(
    data()$episodes |>
      select(season, episode) |>
      count(season)
  )
  
  n_words <- reactive(
    data()$tokens1_raw |> 
      filter(type == "dialogue") |> 
      group_by(season) |> 
      count()
  )  
  characters <- reactive(
    data()$characters |> 
      select(ends_with("name"), type) |> 
      mutate(first_name = first_name |> str_replace("NICHOLAS", "NICK")) |> 
      filter(type %in% c("main", "recurring"))
  )
  
  chars_tbl <- reactive(
    characters() |> 
      unite("character", c(first_name, last_name)) |> 
      clean_chars_col()
  )
  
  chars_vec <- reactive(chars_tbl() |> pull(character))
  
  main_chars_vec <- reactive(
    chars_tbl() |> filter(type == "main") |> pull(character)
  )
  recurring_chars_vec <- reactive(
    chars_tbl() |> filter(type == "recurring") |> pull(character)
  )
  
  top6 <- reactive(
    data()$tokens1_raw |> 
      group_by(sp3, sp4) |> 
      filter(type == "dialogue") |> 
      count(sort = TRUE) |> 
      ungroup() |> 
      head(6) |> 
      select(-n) |> 
      rename(first_name = sp3, last_name = sp4)
  )
  
  top6_server("top6_home", top6)
  top6_server("top6_chars_panel", top6)
  
  filter_characters <- function(
    data,
    filter = c("top6", "main", "recurring", "all")
  ) {
    
    filter <- match.arg(filter)
    
    chars <- switch(
      filter,
      top6      = top6(),
      main      = characters()[characters()$type == "main", ],
      recurring = characters()[characters()$type == "recurring", ],
      all       = characters()
    )
    
    data |> filter(when_all(
      sp3 %in% chars$first_name,
      sp4 %in% chars$last_name
    )) |> 
      filter_out(when_all(sp3 == "AARON", sp4 == "MURRAY"))
    
  }
  
  top6_data <- reactive(
    data()$tokens1_raw |>
      filter(type == "dialogue") |>
      filter_characters("top6")
  )
  
  top6_count <- reactive(
    data()$tokens1_raw |>
      filter(type == "dialogue") |>
      filter_characters("top6") |> 
      group_by(sp4, season) |>
      count()
  )
  
  top6_prop <- reactive(
    top6_count() |> 
      left_join(n_words() |> rename(season_total = n), join_by(season)) |> 
      mutate(prop = n / season_total)
  )
  
  ratings <- reactive(
    data()$ratings |> 
      left_join(data()$episodes, join_by(season, episode)) |> 
      select(-ep_number) |> 
      relocate(title, .after = episode) |> 
      arrange(season, episode)
  )
  
  ratings_stats <- reactive(
    data()$ratings |> 
      group_by(season) |> 
      summarise(
        min = min(rating),
        q1 = quantile(rating, 0.25),
        median = median(rating),
        q3 = quantile(rating, 0.75),
        max = max(rating),
        mean = mean(rating),
        sd = sd(rating)
      )
  )
  
## home -------------------------------------------------------------------
  
  observeEvent(input$reset_season_filter, reset("filter_season"))
  
  output$episodes <- render_gt({
    
    tbl <- data()$episodes |> 
      select(season, episode, title)
    
    if (length(input$filter_season) > 0) {
      tbl <- tbl |> filter(season %in% input$filter_season)
    }
    
    tbl |> 
      rename_with(str_to_title) |> 
      gt() |> 
      cols_width("Season" ~ px(100), "Episode" ~ px(100)) |> 
      cols_align("center", 1:2) |> 
      opt_interactive(
        use_sorting = TRUE,
        use_search = TRUE,
        use_page_size_select = TRUE,
        page_size_values = c(5, seq(10, 40, 10))
      )
    
  })
  
  output$series_stats <- render_gt({
    
    n_episodes <- n_episodes() |> rename(episodes = n)
    n_words    <- n_words()    |> rename(words = n)
    
    left_join(n_episodes, n_words, join_by(season)) |> 
      mutate(average = (words / episodes)) |> 
      rename(`Average Words per Episode` = average) |> 
      clean_col_names() |> 
      gt() |> 
      fmt_number(3, decimals = 0) |> 
      fmt_number(4, decimals = 2) |> 
      cols_align("center", 1:2) |> 
      cols_width(
        "Season" ~ px(100), "Episodes" ~ px(100), "Words" ~ px(100)
      ) |> 
      opt_interactive(use_sorting = TRUE, use_pagination = FALSE)
    
  })
  
  median_season_ratings_server("msr_home", ratings_stats)
  median_season_ratings_server("msr_ratings", ratings_stats)
  
  output$n_episodes <- renderText(
    data()$episodes |> nrow()
  )
  
# characters -------------------------------------------------------------
  
  output$char_selection <- renderUI({
    
    if (when_any(
      length(input$char_type_filter) == 2,
      length(input$char_type_filter) == 0
    )) {
      choices_vec <- list(
        Main = main_chars_vec(), Recurring = recurring_chars_vec()
      )
    }
    if (length(input$char_type_filter) == 1) {
      if ("main" %in% input$char_type_filter) {
        choices_vec <- main_chars_vec()
      }
      if ("recurring" %in% input$char_type_filter) {
        choices_vec <- recurring_chars_vec()
      }
    }
    selectInput(
      "char_select",
      "Filter by Character",
      choices = choices_vec,
      multiple = TRUE
    )
  })
  
  output$words_by_chars <- render_gt({
    
    tbl <- data()$tokens1_raw |> 
      filter(type == "dialogue") |> 
      filter_characters("all") |> 
      unite("character", c(sp3, sp4), remove = FALSE) |> 
      clean_chars_col()
    
    if (length(input$char_select) > 0) {
      tbl <- tbl |> filter(character %in% input$char_select)
    }
    
    if (length(input$char_select) == 0) {
      if (length(input$char_type_filter) == 1) {
        if ("main" %in% input$char_type_filter) {
          tbl <- tbl |> filter_characters("main")
        }
        if ("recurring" %in% input$char_type_filter) {
          tbl <- tbl |> filter_characters("recurring")
        }
      }
    }
    
    tbl <- tbl |> 
      group_by(sp3, sp4) |> 
      count(sort = TRUE) |> 
      ungroup() |> 
      mutate(across(
        where(is.character),
        \(x) x |> str_replace_all("_", " ") |> str_to_title()
      )) |> 
      rename("First Name" = sp3, "Last Name" = sp4, Words = n)
    
    tbl |> 
      gt() |> 
      fmt_number("Words", decimals = 0) |> 
      opt_interactive(
        use_sorting = TRUE,
        use_search = TRUE,
        use_page_size_select = TRUE,
        page_size_values = c(seq(10, 40, 10), 54)
      )
    
  })
  
  output$top6_plot <- renderPlotly({
    
    data <- top6_prop() |> 
      mutate(
        season = season |> as_factor(),
        sp4 = sp4 |> str_to_title()
      )

    if (input$word_stat == "n") {
      plot <- data |>
        ggplot(aes(
          season, n, group = sp4,
          text = str_c(
            sp4,
            "\nSeason: ", season,
            "\nWords: ", fmt_value(n, 0)
          )
        )) +
        geom_line(
          aes(y = n, color = fct_reorder2(sp4, season, n)),
          linewidth = 0.625
        ) +
        scale_y_continuous(
          labels = \(x) fmt_value(x, 0)
        ) +
        labs(y = "Number of Words")
    }

    if (input$word_stat == "prop") {
      plot <- data |>
        ggplot(aes(
          season, prop, group = sp4,
          text = str_c(
            sp4,
            "\nSeason ", season, 
            "\n", format_percent(prop)
          ))) +
        geom_line(
          aes(color = fct_reorder2(sp4, season, prop)),
          linewidth = 0.625
        ) +
        labs(y = "Proportion of Words") +
        coord_cartesian(ylim = c(0, NA)) +
        scale_y_continuous(
          expand = expansion(c(0, 0.05)), labels = \(x) format_percent(x, 0)
        )
    }

    plot <- plot +
      scale_color_viridis_d(end = 0.9) +
      labs(
        x = "Season",
        color = "Character"
      ) +
      theme_light()
      # gg_theme
    
    plot |> 
      ggplotly(tooltip = "text") |>
      config(displaylogo = FALSE, displayModeBar = FALSE) |>
      plotly_layout(dragmode = FALSE) |>
      htmlwidgets::onRender(
        "function(el) { Plotly.restyle(el, {'line.width': 1.5}); }"
      )
    
  })
  
  # output$characters <- renderTable(data()$characters)
  
  # output$chars_long <- renderTable(
  #   data()$characters_long |>
  #     group_by(season, gender) |>
  #     count(type)
  # )
  
  output$chars_gender_plot <- renderPlot({
    draw_chars_gender_plot(data()$characters_long)
  })
  
  output$filter_top6_stats_UI <- renderUI({
    selectInput(
      "filter_top6_stats_tbl",
      "Filter by Character",
      choices = top6() |> 
        mutate(last_name = str_to_title(last_name)) |> 
        arrange(last_name) |> 
        pull(last_name),
      multiple = TRUE
    )
  })
  
  write_top6_summary_stats_tbl(input, output, top6_data())
  
  # output$chars_vec <- renderText(chars_vec())

## ratings ----------------------------------------------------------------
  
  output$ratings <- render_gt(
    ratings() |> 
      rename(average_rating = rating, number_of_votes = n_votes) |> 
      clean_col_names() |> 
      gt() |> 
      fmt_number("Average Rating", decimals = 1) |> 
      fmt_number("Number of Votes", decimals = 0) |>
      cols_width(
        "Season"  ~ px(95),
        "Episode" ~ px(95),
        "Average Rating"  ~ px(130),
        "Number of Votes" ~ px(130)
      ) |> 
      cols_align("center", 1:2) |> 
      opt_interactive(
        use_sorting = TRUE,
        use_search = TRUE,
        use_pagination = TRUE,
        use_page_size_select = TRUE,
        page_size_values = c(5, seq(10, 40, 10))
      )
  )
  
  min_rating  <- reactive(ratings()$rating |> min())
  max_rating  <- reactive(ratings()$rating |> max())
  mean_rating <- reactive(ratings()$rating |> mean() |> round(1))
  
  output$lowest_rating  <- renderText(min_rating())
  output$highest_rating <- renderText(max_rating())
  output$average_rating <- renderText(mean_rating())
  
  output$lowest_rating_eps <- renderText(
    ratings() |> slice_min(rating) |> titles_to_string()
  )
  output$highest_rating_eps <- renderText(
    ratings() |> slice_max(rating) |> titles_to_string()
  )
  output$average_rating_eps <- renderText(
    ratings() |> filter(rating == round(mean(rating), 1)) |> titles_to_string()
  )
  
  output$ratings_stats_plot <- renderPlot(
    draw_ratings_stats_plot(ratings_stats())
  )
  
  output$ratings_stats_tbl <- render_gt(
    write_ratings_stats_tbl(ratings_stats())
  )
  
  ratings_dist <- reactive(
    data()$ratings |> 
      group_by(season) |> 
      count(rating)
  )
  
  output$ratings_plot <- renderPlot({
    tbl <- ratings_dist() |> 
      mutate(season = season |> as_factor())
      
    plot <- tbl |>   
      ggplot(aes(season, rating, fill = season)) +
      geom_violin() +
      scale_fill_viridis_d() +
      labs(x = "Season", y = "Rating", fill = "Season") +
      gg_theme
    
    if (input$full_rating_scale) {
      plot + scale_y_continuous(
        breaks = seq(0, 10, 1),
        minor_breaks = NULL,
        limits = c(0, 10),
        expand = expansion(c(0, 0))
      )
    } else {
      plot
    }
    
  })
  
  source("ratings_animation.R", local = TRUE)
  
  output$best_worst_eps_speakers <- renderPlot({
    draw_best_worst_eps_speakers_plot(
      data()$tokens1_raw, ratings, filter_characters
    )
  })
  
  top6_word_ratings_data <- reactive({
    counts <- top6_data() |> 
      group_by(sp4, season, episode) |> 
      count() |> 
      ungroup()
    totals <- top6_data() |> 
      group_by(season, episode) |> 
      count() |> 
      ungroup() |> 
      rename(episode_total = n)
    counts |> 
      left_join(totals, join_by(season, episode)) |> 
      mutate(prop = n / episode_total) |> 
      left_join(ratings() |> select(-title), join_by(season, episode))
    })
  
  write_words_rating_lm_tbl(input, output, top6_word_ratings_data()) 
  
  output$words_rating_plot <- renderPlot({
    draw_words_rating_plot(top6_word_ratings_data())
  })
  
}

shinyApp(ui, server)
