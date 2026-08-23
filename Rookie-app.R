library(shiny)
library(targets)
library(arrow)
library(DT)

tar_config_yaml()
tar_load(transcripts)
transcripts <- transcripts |> select(season, episode, title)
transcripts_clean <- open_dataset(
  here::here("data/The-Rookie/transcripts_clean.parquet"), format = "parquet"
) |> 
  left_join(transcripts, by = join_by(season, episode))


# vars, options, funs -----------------------------------------------------

count_vars <- c("type", "speaker_end", "none")

group_vars <- c("episode", "character")

main_chars <- c("NOLAN", "CHEN", "BRADFORD", "HARPER", "GREY", "LOPEZ")  

line_types <- c(
  "previously", "scene_heading", "caption", "dialogue", "lyrics", "other", "NA"
)

options(DT.options = list(
  pageLength = 10,
  lengthMenu = c(5, 10, seq(20, 50, 10))
))

clean_cols <- function(tbl) {
  tbl <- tbl |> 
    rename_with(\(x) x |> str_replace("_", " ") |> str_to_title())
  
  if ("Na" %in% colnames(tbl))  {
    tbl <- tbl |> rename(`NA` = `Na`)
  } 
  if("N" %in% colnames(tbl)) {
    tbl <- tbl |> rename("n" = "N")
  }
  tbl
}


# UI ----------------------------------------------------------------------

ui <- fluidPage(
  h1("Episode Directory"),
  fluidRow(
    # column(0),
    column(6, DTOutput("episodes")),
    column(2),
    column(4,
           selectInput("type_filter", "Type of line", line_types),
           selectInput("count_var", "Count", count_vars),
           selectInput("group_var", "By", c("season", "episode", "none")),
           radioButtons("by_char", "And by character?", c("No", "Yes"))
    )
  ),
  h2("EDA"),
  fluidRow(
    column(6, DTOutput("counts_char")),
    column(6, renderPlot("plot"))
  ),
  
)


# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  output$episodes <- renderDT(
    transcripts |> rename_with(\(x) str_to_title(x))
  )
  
  output$counts_char <- renderDT({
    group_cols <- switch(input$group_var,
                         "none"    = character(0),
                         "season"  = "season",
                         "episode" = c("season", "episode")
    )
    tbl <- transcripts_clean |> 
      select(season, episode, title, type, speaker_end) 
    if (input$type_filter != "NA") {
      tbl <- tbl |> filter(type == input$type_filter)
    }
    tbl <- tbl |> group_by(across(all_of(group_cols)))
    if (input$count_var == "none") {
      tbl <- tbl |> count()
    } else {
      tbl <- tbl |> count(.data[[input$count_var]])
    }
    tbl |> 
      collect() |> 
      clean_cols()
  })
  
  output$plot <- renderPlot({
    
  })

}

shinyApp(ui, server)
