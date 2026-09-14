library(shiny)
library(tidyverse)
library(DT)
library(bslib)

# setup -------------------------------------------------------------------

c(
  "R/theme.R",
  "R/utils.R",
  "R/home_panel.R",
  "R/characters_panel.R"
) |> 
  walk(\(x) source(x))

tbl_transcripts <- nanoparquet::read_parquet("data/transcripts_parquet.parquet")
tbl_characters <- nanoparquet::read_parquet("data/characters_parquet.parquet")

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
