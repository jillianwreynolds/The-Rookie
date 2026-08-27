library(shiny)
library(nanoparquet)
library(tidyverse)
library(DT)

tbl_transcripts <- nanoparquet::read_parquet("transcripts_parquet.parquet")

options(DT.options = list(
  pageLength = 10,
  lengthMenu = c(5, 10, seq(20, 50, 10))
))

ui <- fluidPage(
  titlePanel(h1(em("The Rookie"), " Transcript Analysis")),
  h2("Episode Directory"),
  fluidRow(
    column(6, DTOutput("episodes"))
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
  
}

shinyApp(ui, server)
