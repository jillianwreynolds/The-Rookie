library(shiny)
library(tidyverse)
library(DT)
library(bslib)

# setup -------------------------------------------------------------------

tbl_transcripts <- nanoparquet::read_parquet("transcripts_parquet.parquet")
tbl_characters <- nanoparquet::read_parquet("characters_parquet.parquet")


clean_col_names <- function(tbl, ...) {
  tbl |> 
    rename_with(
      \(x) x |> str_replace_all("_", " ") |> str_to_title(),
      ...
    )
}

# UI setup ----------------------------------------------------------------

dark_teal  <- "#0a333f"
teal       <- "#2f8b9d"
code_color <- "#7c13ba"

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
    ".card { border-radius: 8px !important; }"
  )

cards_home <- list(
  directory = card(
    card_header("Episode Directory", class = "bg-secondary"),
    DTOutput("episodes"),
    min_height = "600px"
  ),
  n_episodes = card(
    card_header("Number of Episodes by Season", class = "bg-secondary"),
    tableOutput("n_episodes")
  )
)

home_panel <- nav_panel(
  title = "Home",
  p("By Jillian W. Reynolds", style = "font-size:22px"),
  fluidRow(
    column(
      3,
      tags$details(
        tags$summary(
          "About This Project", style = "display: list-item; font-size:20px"
        ),
        p(
          "This project uses HTML downloads of episode transcripts from ", tags$a(href="https://the-rookie.fandom.com/", "the-rookie.fandom.com", .noWS = "after", target = "_blank"), ". It uses various ", code("R"), " packages and functions to parse the HTML, extract information, and clean and analyze the data. The tables below were not a product of manual typing and counting or copying and pasting information from existing lists. This project is still in progress.",
          style = "font-size:16px"
        )
      )
    ),
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


cards_characters <- list(
  note = card(markdown(
    "This table lists characters from *The Rookie's* Wikipedia page, specifically those in the lists of main or recurring characters. Analysis will focus on a subset of these characters."
  )),
  table = card(
    card_header("Main and Recurring Characters", class = "bg-secondary"),
    tableOutput("characters_tbl"),
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
  title = h1(em("The Rookie"), " Transcript Analysis", style = "color:#fff"),
  nav_spacer(),
  home_panel,
  characters_panel
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  output$episodes <- renderDT(
    tbl_transcripts |> 
      tibble() |> 
      select(ep_number, season, episode, title) |>
      rename(number = ep_number) |> 
      rename_with(str_to_title),
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
