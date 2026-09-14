library(shiny)
library(nanoparquet)
library(tidyverse)
library(DT)
library(bslib)

# setup -------------------------------------------------------------------

source("theme.R")

tbl_transcripts <- nanoparquet::read_parquet("transcripts_parquet.parquet")

# for testing tbl_transcripts
# tbl_transcripts <- nanoparquet::read_parquet("app/transcripts_parquet.parquet")

# UI ----------------------------------------------------------------------

ui <- fluidPage(
  theme = theme,
  titlePanel(h1(em("The Rookie"), " Transcript Analysis")),
  p("By Jillian W. Reynolds", style = "font-size:22px"),
  titlePanel(""),
  # tags$details(about_section),
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
  titlePanel(""),
  h2("Episode Directory", style = "font-size:26px"),
  titlePanel(""),
  fluidRow(
    column(7, DTOutput("episodes")),
    column(2, tableOutput("n_episodes"))
  ),
  titlePanel(""),
  titlePanel("")
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
  
}

shinyApp(ui, server)
