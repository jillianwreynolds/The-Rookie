library(shiny)
library(shinyjs)
library(tidyverse)
library(glue)
library(DT)
library(bslib)
library(patchwork)

list(
  "themes.R",
  "styles.R",
  "functions.R",
  "about.R",
  "draw_chars_gender_plot.R",
  "plot_ratings_stats_code.R"
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
        )
      )
    ),
    DTOutput("episodes"),
    min_height = "600px"
  ),
  series_stats = card(
    card_header("Series Statistics", class = "bg-secondary"),
    tableOutput("series_stats")
  ),
  top6 = card(
    card_header("Top 6 Speakers of the Series", class = "bg-secondary"),
    htmlOutput("series_T6")
  )
)


### nav_panel -------------------------------------------------------------

home_panel <- nav_panel(
  useShinyjs(), # triggers warning about expected contents of nav containers
  title = "Home",
  p("By Jillian W. Reynolds", style = "font-size:22px"),
  layout_column_wrap(
    cards_home$series_stats,
    cards_home$top6,
    cards_home$directory,
    style = css(grid_template_columns = "2fr 1fr 3fr"),
    fillable = FALSE
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
    DTOutput("words_by_chars"),
    min_height = "600px"
  ),
  top6_plot = card(
    full_screen = TRUE,
    card_header(
      "Top 6 Speakers",
      class = "bg-secondary",
      tooltip(
        bsicons::bs_icon("info-circle"),
        '"Count" shows total number of words spoken by each character in each season. "Proportion" shows the proportion of words spoken by each character in each season (character\'s number of words in a season divided by total words in the season).',
        placement = "right"
      )
    ),
    radioButtons(
      "word_stat",
      label = "Statistic",
      choices = c("Count" = "n", "Proportion" = "prop"),
      selected = "n"
    ),
    plotOutput("T6_plot")
  ),
  gender_plot = card(
    full_screen = TRUE,
    card_header("Character Genders by Character Type", class = "bg-secondary"),
    plotOutput("chars_gender_plot")
  )
)

### nav_panel -------------------------------------------------------------

characters_panel <- nav_panel(
  title = "Characters",
  layout_column_wrap(
    width = 1/2,
    # cards_characters$table,
    cards_characters$words_by_character,
    cards_characters$top6_plot,
    heights_equal = "row"
  ),
  layout_columns(
    fillable = FALSE,
    # card(tableOutput("characters")),
    # card(tableOutput("chars_long")),
    cards_characters$gender_plot,
    col_widths = c(6)
  )#,
  # textOutput("chars_vec")
)

## ratings panel -----------------------------------------------------------

### cards ------------------------------------------------------------------

cards_ratings <- list(
  note = card(
    p(
      "Episodes rating data was downloaded from ",
      a(
        "IMDb",
        href = "https://data.imdb.com/non-commercial-datasets/",
        target = "_blank"
      ),
      "on July 31, 2026"
    )
  ),
  ratings = card(
    card_header("Episode Ratings", class = "bg-secondary"),
    DTOutput("ratings")
  ),
  plot_stats = card(
    full_screen = TRUE,
    card_header("Summary Statistics by Season", class = "bg-secondary"),
    plotOutput("plot_ratings_stats")
  ),
  plot_counts = card(
    full_screen = TRUE,
    card_header(
      "Distribution of Ratings",
      class = "bg-secondary d-flex align-items-center gap-1",
      tooltip(
        bsicons::bs_icon("info-circle"),
        "To filter by season, compare seasons, or change plot settings, click the gear icon to the right."
      ),
      popover(
        bsicons::bs_icon("gear", title = "Settings", class = "ms-auto"),
        title = "View Options",
        checkboxInput("view_full_scale", "View full rating scale (0 to 10)?"),
        selectInput(
          "filter_season2",
          "Filter by Season",
          choices = 1:n_seasons,
          multiple = TRUE
        ),
        checkboxInput("compare_seasons", "Compare seasons?"),
        uiOutput("compare_options"),
        actionButton("reset_plot_ratings_dist", "Reset", class = "btn-reset")
      )
    ),
    uiOutput("ratings_slider_ui"),
    plotOutput("plot_ratings_dist"),
    min_height = "640px"
  ),
  speakers_prop = card(
    full_screen = TRUE,
    card_header("Proportions of Words in Highest and Lowest Rated Episodes for the Top 6 Speakers of the Series", class = "bg-secondary"),
    plotOutput("best_worst_eps_speakers")
  )
)

### value boxes -----------------------------------------------------------

vbs <- list(
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
      cards_ratings$note,
      vbs$highest,
      vbs$average,
      vbs$lowest,
      width = 1/2
    ),
    cards_ratings$plot_stats
  ),
  layout_column_wrap(
    cards_ratings$ratings,
    cards_ratings$plot_counts
  ),
  layout_column_wrap(
    width = 1/2,
    cards_ratings$speakers_prop
  )
)

# UI ----------------------------------------------------------------------

ui <- page_navbar(
  theme = rookie_theme,
  tags$style(type = "text/css", rookie_slider_css),
  fillable = FALSE,
  navbar_options = navbar_options(bg = dark_teal),
  title = h1(
    em("The Rookie"), " Transcript Analysis",
    style = glue("color:{yellow}")
  ),
  nav_spacer(),
  home_panel,
  about_menu,
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
  
  ratings <- reactive(
    data()$ratings |> 
      left_join(data()$episodes, join_by(season, episode)) |> 
      select(-ep_number) |> 
      relocate(title, .after = episode) |> 
      arrange(season, episode)
  )
  
## home -------------------------------------------------------------------
  
  observeEvent(input$reset_season_filter, reset("filter_season"))
  
  output$episodes <- renderDT(
    {
      tbl <- data()$episodes |> 
        select(ep_number, season, episode, title)
      if (length(input$filter_season) > 0) {
        tbl <- tbl |> filter(season %in% input$filter_season)
      }
      tbl |> 
        rename(number = ep_number) |> 
        rename_with(str_to_title)
      
    },
    server = FALSE,
    options = list(
      pageLength = 10,
      lengthMenu = c(5, 10, seq(20, 40, 10))
    )
  )
  
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
  
  output$series_stats <- renderTable({
    
    n_episodes <- n_episodes() |> rename(episodes = n)
    n_words    <- n_words()    |> rename(words = n)
    
    left_join(n_episodes, n_words, join_by(season)) |> 
      mutate(average = (words / episodes) |> round(2)) |> 
      rename(`Average Words per Episode` = average) |> 
      clean_col_names()
    
  })
  
  output$series_T6 <- renderText({
    top6() |> 
      unite(character, first_name, last_name) |> 
      clean_chars_col() |> 
      pull(character) %>%
      str_c(1:6, ". ", ., collapse = "\n") |> 
      markdown()
  })

# characters -------------------------------------------------------------
  
  output$char_selection <- renderUI({
    
    if (when_any(
      length(input$char_type_filter) == 2,
      length(input$char_type_filter) == 0
    )) {
      choices_vec <- chars_vec()
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
  
  output$words_by_chars <- renderDT({
    
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
    
    tbl |> 
      group_by(sp3, sp4) |> 
      count(sort = TRUE) |> 
      ungroup() |> 
      mutate(across(
        where(is.character),
        \(x) x |> str_replace_all("_", " ") |> str_to_title()
      )) |> 
      rename("First Name" = sp3, "Last Name" = sp4)
  })
  
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
  
  output$T6_plot <- renderPlot({
    
    data <- top6_prop() |> mutate(season = season |> as_factor())

    if (input$word_stat == "n") {
      plot <- data |>
        ggplot(aes(season, n, group = sp4)) +
        geom_line(
          aes(y = n, color = fct_reorder2(sp4, season, n)),
          linewidth = 0.625
        ) +
        labs(y = "Number of Words")
    }

    if (input$word_stat == "prop") {
      plot <- data |>
        ggplot(aes(season, prop, group = sp4)) +
        geom_line(
          aes(color = fct_reorder2(sp4, season, prop)),
          linewidth = 0.625
        ) +
        labs(y = "Proportion of Words") +
        coord_cartesian(ylim = c(0, NA)) +
        scale_y_continuous(expand = expansion(c(0, 0.05)))
    }

    plot +
      scale_color_viridis_d(end = 0.85, labels = \(x) x |> str_to_title()) +
      labs(
        x = "Season",
        color = "Character"
      ) +
      gg_theme
    
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
  
  # output$chars_vec <- renderText(chars_vec())

## ratings ----------------------------------------------------------------
  
  output$ratings <- renderDT(
    ratings() |> 
      rename(number_of_votes = n_votes) |> 
      clean_col_names(),
    options = list(
      pageLength = 10,
      lengthMenu = c(5, 10, seq(20, 40, 10))
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
  output$plot_ratings_stats <- renderPlot(
    plot_ratings_stats_code(data()$ratings)
  )
  
  output$compare_options <- renderUI({
    if (input$compare_seasons) {
      radioButtons(
        "compare_view",
        "Compare seasons with",
        c(
          "Colored bar chart(s)" = 1,
          "Multiple bar charts"  = 2,
          "Violin plot"          = 3
        )
      )
    }
  })
  
  output$ratings_slider_ui <- renderUI({
    req(input$compare_seasons)
    req(input$compare_view)
    if (input$compare_view == 1) {
      tags$div(class = "rookie-slider", sliderInput(
        "ratings_slider",
        "Season",
        value = 0,
        min = 0,
        max = 8,
        step = 1,
        animate = animationOptions(interval = 1500, loop = TRUE)
      )) 
    }
  })
  
  output$plot_ratings_dist <- renderPlot({
    
    ratings_dist <- data()$ratings |> 
      group_by(season) |> 
      count(rating) |> 
      mutate(season = season |> as_factor())
    
    if (when_any(
      when_all(
        when_any(
          isTruthy(input$compare_seasons == FALSE),
          isTruthy(input$compare_view == 2)
        ),
        length(input$filter_season2) > 0
      ),
      when_all(
        isTruthy(input$compare_view == 1),
        length(input$filter_season2) > 0,
        isTruthy(input$ratings_slider == 0)
      )
    )) {
      ratings_dist <- ratings_dist |> filter(season %in% input$filter_season2)
    }
    if (when_all(
      isTruthy(input$compare_view == 1), isTruthy(input$ratings_slider != 0)
    )) {
      ratings_dist <- ratings_dist |> filter(season == input$ratings_slider)
    }
    
    break_skip <- if (when_any(
      input$view_full_scale,
      isTruthy(input$compare_view == 2)
    )) {
      1
    } else {
      0.5
    }
    
    plot <- ratings_dist |> 
      ggplot(aes(rating, n)) +
      labs(x = "Rating", y = "Number of Episodes") +
      scale_x_continuous(breaks = seq(0, 10, break_skip)) +
      gg_theme
    
    if (isTruthy(input$compare_seasons == FALSE)) {
      plot <- plot + geom_col(fill = teal)
    }
    
    if (isTruthy(input$compare_seasons)) {
      if (when_all(
        isTruthy(input$compare_view == 1),
        isTruthy(input$ratings_slider == 0)
      )) {
        plot <- plot +
          geom_col(aes(fill = season)) +
          scale_fill_viridis_d() +
          labs(fill = "Season") +
          theme(
            legend.position = c(0.005, 0.995),
            legend.justification = c(0, 1)
          )
        if (input$view_full_scale) {
          plot <- plot + coord_cartesian(xlim = c(0, 10))
        } else {
          plot <- plot + coord_cartesian(xlim = c(min_rating(), max_rating()))
        }
      }
      if (when_all(
        isTruthy(input$compare_view == 1),
        isTruthy(input$ratings_slider != 0)
      )) {
        plot <- plot + geom_col(fill = viridis[input$ratings_slider])
        if (input$view_full_scale) {
          plot <- plot + coord_cartesian(xlim = c(0, 10), ylim = c(0, 20))
        } else if (input$view_full_scale == FALSE) {
          plot <- plot + 
            coord_cartesian(xlim = c(min_rating(), max_rating()), ylim = c(0, 20))
        }
      }
      if (isTruthy(input$compare_view == 2)) {
        strip_labels <- setNames(str_c("Season ", 1:8), as.character(1:8))
        facet_cols <- if (length(input$filter_season2) %in% 2:3) 1 else NULL
        plot <- plot +
          geom_col(fill = teal) +
          facet_wrap(
            ~season,
            ncol = facet_cols,
            labeller = as_labeller(strip_labels),
            axes = "all_x"
          ) +
          theme(strip.text = element_text(size = 14))
      }
      if (isTruthy(input$compare_view == 3)) {
        plot <- ratings_dist |> 
          ggplot(aes(season, rating, fill = season)) + 
          geom_violin() +
          scale_fill_viridis_d(guide = NULL) +
          labs(x = "Season", y = "Rating") +
          gg_theme
      }
    }
    if (when_all(
      input$view_full_scale,
      when_any(
        isTruthy(input$compare_seasons == FALSE),
        isTruthy(input$compare_view == 2)
      )
    )) {
      plot <- plot + coord_cartesian(xlim = c(0, 10))
    }
    if (isTruthy(input$compare_view == 2)) {
      plot <- plot + 
        scale_y_continuous(
          expand = expansion(c(0, 0.05)),
          minor_breaks = NULL
        )
    } else if (!isTruthy(input$compare_view == 3)) {
      plot <- plot + scale_y_continuous(expand = expansion(c(0, 0.05)))
    }
    plot
  })
  
  observeEvent(input$reset_plot_ratings_dist, {
    reset("view_full_scale")
    reset("filter_season2")
    reset("compare_seasons")
    updateRadioButtons(session, "compare_view", selected = character(0))
    updateSliderInput(session, "ratings_slider", value = 0)
  })
  
  output$best_worst_eps_speakers <- renderPlot({
    word_count <- data()$tokens1_raw |>
      filter(type == "dialogue") |>
      group_by(season, episode) |>
      count() |>
      rename(total_words = n)

    data <- data()$tokens1_raw |>
      filter(type == "dialogue") |>
      filter_characters("top6") |>
      left_join(ratings(), join_by(season, episode))

    highest <- data |>
      slice_max(rating)

    lowest <- data |>
      slice_min(rating)

    draw_plot <- function(data) {
      data |>
        group_by(sp4, season, episode) |>
        count() |>
        left_join(word_count, join_by(season, episode)) |>
        mutate(
          prop = n / total_words,
          episode = str_c(season, "x", episode),
          sp4 = sp4 |> str_to_title()
        ) |>
        ggplot(aes(episode, prop)) +
        geom_col(aes(fill = sp4), position = "dodge") +
        scale_y_continuous(expand = expansion(c(0, 0.05))) +
        scale_fill_viridis_d(end = 0.9, direction = -1) +
        labs(
          x = "Episode", y = "Proportion of Total Words", fill = "Character"
        ) +
        gg_theme
    }

    (draw_plot(highest) + labs(title = "Highest Rated")) +
      (draw_plot(lowest) + labs(title = "Lowest Rated")) +
      plot_layout(
        guides = "collect", axis_titles = "collect_y", axes = "collect_y"
      ) &
      coord_cartesian(ylim = c(0, 0.175)) &
      theme(plot.title = element_text(size = 17), legend.position = "bottom")
    
  })
  
}

shinyApp(ui, server)
