library(shiny)
library(shinyjs)
library(tidyverse)
library(DT)
library(bslib)

# read data ---------------------------------------------------------------

tbl_transcripts <- nanoparquet::read_parquet("transcripts_parquet.parquet")
tbl_episode_ratings <- nanoparquet::read_parquet("episode_ratings.parquet")
tbl_characters <- nanoparquet::read_parquet("characters_parquet.parquet")

# Number of seasons
n_seasons <- 8

# functions ---------------------------------------------------------------

clean_col_names <- function(tbl, ...) {
  tbl |> 
    rename_with(
      \(x) x |> str_replace_all("_", " ") |> str_to_title(),
      ...
    )
}


# tibbles -----------------------------------------------------------------

ratings <- tbl_episode_ratings |> 
  left_join(tbl_transcripts, join_by(season, episode)) |> 
  select(-ep_number) |> 
  relocate(title, .after = episode) |> 
  arrange(season, episode)

# themes ------------------------------------------------------------------

## bs ---------------------------------------------------------------------

dark_teal   <- "#0a333f"
dark_teal2  <- "#0a333f30"
teal        <- "#2f8b9d"
teal2       <- "#2f8b9d30"
code_color  <- "#7c13ba"
yellow      <- "#facf21"
light_green <- "#b9d4bd"

theme <- bs_theme(
  version = 5,
  bootswatch = "cosmo",
  primary = dark_teal,
  secondary = teal
) |>
  bs_add_variables(
    "headings-color"     = dark_teal,
    "link-color"         = teal,
    "code-color"         = code_color,
    "card-title-color"   = teal
  ) |> 
  bs_add_rules(
    glue::glue(
      "
    .card {
      border-radius: var(--bs-border-radius-lg);
    }
    .accordion {
      --bs-accordion-btn-bg: {{teal2}};
      --bs-accordion-active-bg: {{light_green}};
    }
    .btn-reset {
      background-color: {{teal2}};
      border-color: var(--bs-border-color);
      color: {{dark_teal}};
    }
    .btn-reset:hover {
      background-color: {{yellow}};
      border-color: {{dark_teal}};
      color: {{dark_teal}};
    }
    ",
      .open = "{{",
      .close = "}}"
    )
  )


# ggplot ------------------------------------------------------------------

gg_theme <- theme(
  axis.title = element_text(size = 15),
  axis.text = element_text(size = 14),
  legend.title = element_text(size = 14),
  legend.text = element_text(size = 13)
)

# plots -------------------------------------------------------------------

plot_ratings_code <- tbl_episode_ratings |> 
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
  labs(x = "Season", y = "Rating", color = "Statistic", linetype = "Statistic") +
  theme_light() +
  coord_cartesian(ylim = c(0, 10)) +
  gg_theme

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


cards_home <- list(
  directory = card(
    card_header("Episode Directory", class = "bg-secondary"),
    accordion(
      open = FALSE,
      accordion_panel(
        "Filter by Season",
        fluidRow(
          column(4, selectInput(
            "filter_season",
            label = NULL,
            choices = 1:n_seasons,
            multiple = TRUE
          )),
          column( 3, actionButton(
              "reset_season_filter", "Reset Filter", class = "btn-reset"
          ))
        )
      )
    ),
    DTOutput("episodes"),
    min_height = "670px"
  ),
  n_episodes = card(
    card_header("Number of Episodes by Season", class = "bg-secondary"),
    tableOutput("n_episodes")
  )
)

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
    cards_home$ratings,
    col_widths = c(6, 2, 4),
    fillable = FALSE
  )
)


## characters panel --------------------------------------------------------

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

characters_panel <- nav_panel(
  title = "Characters",
  layout_columns(
    cards_characters$note,
    cards_characters$table,
    col_widths = c(3, 5),
    fillable = FALSE
  )
)

## ratings panel -----------------------------------------------------------

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
    min_height = "640px"
  ),
  plot = card(
    full_screen = TRUE,
    card_header("Summary Statistics by Season", class = "bg-secondary"),
    plotOutput("plot_ratings")
  )
)

vbs <- list(
  highest = value_box(
    "Highest Rating",
    value = ratings$rating |> max(),
    p(
      ratings |> slice_max(rating) |> 
        pull(title) |>str_flatten(collapse = ", ", last = " and "),
      style = "font-size:15px"
    )
  ),
  lowest = value_box(
    "Lowest Rating",
    value = ratings$rating |> min(),
    p(
      ratings |> slice_min(rating) |> 
        pull(title) |> str_flatten(collapse = ", ", last = " and "),
      style = "font-size:15px"
    )
  ),
  average = value_box(
    "Average Rating",
    value = ratings$rating |> mean() |> round(1),
    p(
      ratings |> filter(rating == round(mean(rating), 1)) |> 
        pull(title) |> str_flatten(collapse = ", ", last = " and "),
      style = "font-size:15px"
    )
  )
)

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
    cards_ratings$plot
  ),
  # layout_columns(
  #   cards_ratings$note,
  #   vbs$highest,
  #   cards_ratings$plot,
  #   col_widths = c(3, 3, 6),
  #   fillable = FALSE
  # ),
  # layout_columns(
  #   vbs$average,
  #   vbs$lowest,
  #   col_widths = c(3, 3, 6),
  #   fillable = FALSE
  # ),
  layout_columns(
    cards_ratings$ratings,
    # cards_ratings$plot,
    fillable = FALSE
  )
)

# UI ----------------------------------------------------------------------

ui <- page_navbar(
  theme = theme,
  fillable = FALSE,
  navbar_options = navbar_options(bg = dark_teal),
  title = h1(
    em("The Rookie"), " Transcript Analysis",
    style = "color:#facf21"
  ),
  nav_spacer(),
  home_panel,
  characters_panel,
  ratings_panel
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  

## home -------------------------------------------------------------------
  
  observeEvent(input$reset_season_filter, reset("filter_season"))
  
  output$episodes <- renderDT(
    {
      tbl <- tbl_transcripts |> 
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
    tbl_transcripts |>
      select(season, episode) |>
      count(season) |>
      rename(Season = season, Episodes = n)
  )

# characters -------------------------------------------------------------
  
  output$characters_tbl <- renderDT(
    tbl_characters |> 
      select(1:2) |> 
      mutate(across(
        everything(),
        \(x) x |> str_replace_all("_", " ") |>  str_to_title()
      )) |> 
      clean_col_names()
  )

## ratings ----------------------------------------------------------------
  
  output$ratings <- renderDT(
    ratings |> 
      rename(number_of_votes = n_votes) |> 
      clean_col_names()
  )
  
  output$plot_ratings <- renderPlot(
    plot_ratings_code
  )
  
}

shinyApp(ui, server)
