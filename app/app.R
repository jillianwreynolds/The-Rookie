library(shiny)
library(shinyjs)
library(tidyverse)
library(glue)
library(DT)
library(bslib)

source("themes.R")
source("styles.R")
source("functions.R")

# Number of seasons
n_seasons <- 8

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
    ggplot() +
    geom_line(
      aes(
        season, value,
        color = fct_reorder2(stat, season, value),
        linetype = fct_reorder2(stat, season, value)
      ),
      linewidth = 0.75
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

# UI setup ----------------------------------------------------------------

## About section -----------------------------------------------------------

about_section <- tagList(
  tags$details(
    tags$summary(
      "About This Project", style = "display: list-item; font-size:20px"
    ),
    p(
      "This project uses HTML downloads of episode transcripts from ", tags$a(href="https://the-rookie.fandom.com/", "the-rookie.fandom.com", .noWS = "after", target = "_blank"), ". It uses various ", code("R"), " packages and functions to parse the HTML, extract information, and clean and analyze the data. The tables below were not a product of manual typing and counting or copying and pasting information from existing lists. This project is still in progress.",
      style = "font-size:16px"
    )
  )
)


## home panel --------------------------------------------------------------

### cards ------------------------------------------------------------------

cards_home <- list(
  directory = card(
    card_header(
      "Episode Directory",
      class = "bg-secondary",
      tooltip(
        bsicons::bs_icon("question-circle"),
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
  n_episodes = card(
    card_header("Number of Episodes by Season", class = "bg-secondary"),
    tableOutput("n_episodes")
  )
)


### nav_panel -------------------------------------------------------------

home_panel <- nav_panel(
  useShinyjs(),
  title = "Home",
  p("By Jillian W. Reynolds", style = "font-size:22px"),
  fluidRow(
    column(3, about_section),
    column(9)
  ),
  p(),
  titlePanel(""),
  layout_columns(
    cards_home$directory,
    cards_home$n_episodes,
    col_widths = c(6, 2),
    fillable = FALSE
  )
)


## characters panel --------------------------------------------------------

### cards ------------------------------------------------------------------

cards_characters <- list(
  note = card(markdown(
    "This table lists characters from *The Rookie's* Wikipedia page, specifically those in the lists of main or recurring characters. Analysis will focus on a subset of these characters."
  )),
  table = card(
    card_header("Main and Recurring Characters", class = "bg-secondary"),
    DTOutput("characters_tbl"),
    min_height = "600px"
  )
)

### nav_panel -------------------------------------------------------------

characters_panel <- nav_panel(
  title = "Characters",
  layout_columns(
    cards_characters$note,
    cards_characters$table,
    col_widths = c(3, 6),
    fillable = FALSE
  )
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
    DTOutput("ratings"),
    min_height = "600px"
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
        bsicons::bs_icon("question-circle"),
        "To filter by season, compare seasons, or change plot settings, click the gear icon to the right.",
        placement = "right"
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
  layout_columns(
    cards_ratings$ratings,
    cards_ratings$plot_counts,
    fillable = FALSE
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
  characters_panel,
  ratings_panel
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  data <- reactive({
    withProgress(
      {
        tbl_episodes = nanoparquet::read_parquet("transcripts_parquet.parquet")
        incProgress(1 / 3)
        tbl_chars = nanoparquet::read_parquet("characters_parquet.parquet")
        incProgress(1 / 3)
        tbl_ratings = nanoparquet::read_parquet("episode_ratings.parquet")
        incProgress(1 / 3)
        list(
          episodes = tbl_episodes,
          characters = tbl_chars,
          ratings = tbl_ratings
        )
      },
      message = "Loading data...",
      detail = "This may take several seconds...",
      value = 0
    )
  })
  
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
  
  output$n_episodes <- renderTable(
    data()$episodes |>
      select(season, episode) |>
      count(season) |>
      rename(Season = season, Episodes = n)
  )

# characters -------------------------------------------------------------
  
  output$characters_tbl <- renderDT(
    data()$characters |> 
      select(ends_with("name"), type) |> 
      filter(type %in% c("main", "recurring")) |> 
      select(-type) |> 
      mutate(across(
        everything(),
        \(x) x |> str_replace_all("_", " ") |>  str_to_title()
      )) |> 
      clean_col_names()
  )

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
  
  min_rating <- reactive(ratings()$rating |> min())
  max_rating <- reactive(ratings()$rating |> max())
  mean_rating <- reactive(ratings()$rating |> mean() |> round(1))
  
  output$lowest_rating <- renderText(min_rating())
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
  
  output$compare_options <- renderUI(
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
  )
  
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
  
}

shinyApp(ui, server)
