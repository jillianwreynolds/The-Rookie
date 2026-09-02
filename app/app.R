library(shiny)
library(nanoparquet)
library(tidyverse)
library(DT)

tbl_transcripts <- nanoparquet::read_parquet("transcripts_parquet.parquet")

options(DT.options = list(
  pageLength = 10,
  lengthMenu = c(5, 10, seq(20, 50, 10))
))

theme <- bslib::bs_theme(
  bootswatch = "cerulean",
  primary = "#0a333f"
)

ui <- fluidPage(
  theme = theme,
  titlePanel(h1(em("The Rookie"), " Transcript Analysis")),
  p("By Jillian W. Reynolds", style = "font-size:22px"),
  titlePanel(""),
  h2("Episode Directory"),
  fluidRow(
    column(6, DTOutput("episodes")),
    column(2, DTOutput("n_episodes", width = "10%"))
  ),
  titlePanel(""),
  titlePanel("")
)

server <- function(input, output, session) {
  
  output$episodes <- renderDT(
    tbl_transcripts |> 
      tibble() |> 
      select(ep_number, season, episode, title) |>
      rename(number = ep_number) |> 
      rename_with(str_to_title)
  )
  
  output$n_episodes <- renderDT(
    tbl_transcripts |> 
      select(season, episode) |> 
      distinct() |>  
      count(season) |> 
      collect() |> 
      rename(Season = season, Episodes = n),
    options = list(dom = "t")
  )
  
}

shinyApp(ui, server)

