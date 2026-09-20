library(shiny)
library(tidyverse)
library(DT)
library(bslib)

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
