library(shiny)
library(tidyverse)
library(DT)
library(bslib)
library(nanoparquet)

source("my_theme.R")

# UI ----------------------------------------------------------------------

ui <- fluidPage(
  theme = my_theme,
  h1("Title here", style = glue::glue("color:{yellow}")),
  p("Some UI here"),
  tableOutput("episodes"),
  tableOutput("characters"), 
  tableOutput("ratings"),
  p("Some more UI here")
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  my_data <- reactive({
    withProgress(
      {
        tbl_episodes <- nanoparquet::read_parquet("transcripts_parquet.parquet")
  #       # Sys.sleep(3)
        incProgress(1 / 4)
        
        tbl_characters <- nanoparquet::read_parquet("characters_parquet.parquet")
        incProgress(1 / 4)

        tbl_ratings <- nanoparquet::read_parquet("episode_ratings.parquet")
        incProgress(1 / 4)
        
        tbl_raw <- nanoparquet::read_parquet("df_raw.parquet")

        list(
          # episodes = datasets::mtcars
          episodes = tbl_episodes,
          characters = tbl_characters,
          ratings = tbl_ratings,
          df_raw = tbl_raw
        )
      },
      message = "Loading data...",
      detail = "This may take several seconds...",
      value = 0
    )
  })
  
  output$episodes <- renderTable(my_data()$episodes |> head())
  output$characters <- renderTable(my_data()$characters |> head())
  output$ratings <- renderTable(my_data()$ratings |> head())
}

shinyApp(ui, server)
