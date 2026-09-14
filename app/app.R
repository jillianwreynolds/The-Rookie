library(shiny)
library(shinyjs)
library(tidyverse)
library(DT)
library(bslib)

# read data ---------------------------------------------------------------

tbl_transcripts <- nanoparquet::read_parquet("transcripts_parquet.parquet")
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

# UI setup ----------------------------------------------------------------

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
    col_widths = c(6, -1, 2),
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
  characters_panel
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  
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
  
  output$characters_tbl <- renderDT(
    tbl_characters |> 
      select(1:2) |> 
      mutate(across(
        everything(),
        \(x) x |> str_replace_all("_", " ") |>  str_to_title()
      )) |> 
      clean_col_names()
  )
  
}

shinyApp(ui, server)
