library(shiny)
library(targets)
library(arrow)
library(DT)

tar_load(transcripts)
transcripts <- transcripts |> select(season, episode, title)
transcripts_clean <- open_dataset(
  here::here("data/The-Rookie/transcripts_clean.parquet"), format = "parquet"
) |> 
  left_join(transcripts, by = join_by(season, episode))


# vars, options, funs -----------------------------------------------------

choices_count <- c("Lines", "Speakers")

choices_group <- c("season", "episode")

main_chars <- tribble(
  ~name,             ~gender,
  "John Nolan",       "M",
  "Lucy Chen",        "F",
  "Tim Bradford",     "M",
  "Angela Lopez",     "F",
  "Wade Grey",        "M",
  "Nyla Harper",      "F"
) |> separate_wider_delim(
  name,
  delim = " ",
  names = c("first_name", "last_name"),
  too_many = "merge"
) |> 
  mutate(across(ends_with("name"), str_to_upper))

# currently doesn't account for "Henry Nolan" or "Mrs. Chen"
characters <- c("NOLAN", "CHEN", "BRADFORD", "HARPER", "GREY", "LOPEZ")  

line_types <- c(
  "previously", "scene_heading", "caption", "dialogue", "lyrics", "other", "NA"
)

options(DT.options = list(
  pageLength = 10,
  lengthMenu = c(5, 10, seq(20, 50, 10))
))

filter_chars <- function(tbl) {
  tbl |> 
    filter(when_any(
      speaker_start %in% main_chars$first_name & 
        speaker_end %in% main_chars$last_name,
      is.na(speaker_start) & speaker_end %in% main_chars$last_name
    ))
}

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
    column(6, DTOutput("episodes")),
    column(2, DTOutput("n_episodes", width = "10%")),
    column(4, selectInput("choices_char", "Select Character", choices = characters), DTOutput("n_lines", width = "15%"))
  ),
  h2("EDA"),
  fluidRow(
    column(6, DTOutput("counts")),
    column(6, selectInput("count_var", "Count", choices_count),
           uiOutput("type_option"),
           selectInput("group_var", "By", c("", "All", choices_group), selected = ""),
           radioButtons("filter_char", "Include only main characters?", c("Yes", "No")))
  ),
  renderPlot("plot")
)


# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  output$type_option <- renderUI(
    if (input$count_var == "Lines") {
      selectInput(
        "type_filter", "Type of line",
        c("All", line_types), selected = "All"
      )
    }
  )
  
  output$episodes <- renderDT(
    transcripts |> rename_with(\(x) str_to_title(x))
  )
  
  output$counts <- renderDT({
    group_cols <- switch(input$group_var,
                         "None"    = character(0),
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
