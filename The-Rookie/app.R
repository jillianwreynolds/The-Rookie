library(shiny)
library(targets)
library(arrow)
library(DT)

tar_config_yaml()
tar_load(transcripts)
tar_load(transcripts_clean)
transcripts <- transcripts |> select(season, episode, title)
transcripts_clean <- open_dataset(
  "../data/The-Rookie/transcripts_clean.parquet", format = "parquet"
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
    column(6)
  ),
  h2("EDA"),
  # h3("Count :"),
  fluidRow(
    column(4, selectInput("count_var", "Count", count_vars)),
    column(4, selectInput("group_var", "By", c("season", "episode", "none"))),
    column(4, radioButtons("by_char", "And by character?", c("No", "Yes")))
  ),
  # DTOutput("counts"),
  # h4("Type"),
  # DTOutput("counts_type"),
  selectInput("type_filter", "Type of line", line_types),
  DTOutput("counts_char")
)


# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  output$episodes <- renderDT(
    transcripts |> rename_with(\(x) str_to_title(x))
  )
  
  # output$counts <- renderDT({
  #   tbl <- transcripts_clean |>
  #     select(season, episode, type, speaker_end) 
  #   if (input$count_var == "speaker_end") {
  #     tbl <- tbl |> filter(speaker_end %in% main_chars)
  #   }
  #   tbl <- tbl |> 
  #     group_by(season, episode) %>%
  #     count(.data[[input$count_var]]) |>
  #     collect() %>%
  #     {left_join(transcripts, ., by = join_by(season, episode))}
  #   if (input$count_var == "type") {
  #     tbl <- tbl |> 
  #       pivot_wider(names_from = type, names_prefix = "n_", values_from = n) |> 
  #       mutate(across(starts_with("n_"), \(x) if_else(is.na(x), 0, x))) |> 
  #       rename_with(\(x) x |> str_remove("n_")) |> 
  #       relocate(title, .after = episode) |> 
  #       relocate(previously,    .after = title) |> 
  #       relocate(scene_heading, .after = previously) |> 
  #       relocate(caption,       .after = scene_heading) |> 
  #       relocate(lyrics,        .after = dialogue) |> 
  #       relocate(other,         .after = lyrics)
  #   }
  #   if (input$count_var == "speaker_end") {
  #     tbl <- tbl |> 
  #       relocate(title, .after = episode) |> 
  #       rename(character = speaker_end) |> 
  #       mutate(character = character |> str_to_title())
  #   }
  #   tbl |> clean_cols()
  #   
  # })
  
  # output$counts_type <- renderDT({
  #   transcripts_clean |> 
  #     select(season, episode, title, type) |> 
  #     collect() |> 
  #     group_by(season) |> 
  #     count(type) |> 
  #     pivot_wider(names_from = type, names_prefix = "n_", values_from = n) |> 
  #     mutate(across(starts_with("n_"), \(x) if_else(is.na(x), 0, x))) |> 
  #     rename_with(\(x) x |> str_remove("n_")) |> 
  #     left_join(transcripts, ., by = join_by(season, episode)) |> 
  #     relocate(title, .after = episode) |> 
  #     relocate(previously,    .after = title) |> 
  #     relocate(scene_heading, .after = previously) |> 
  #     relocate(caption,       .after = scene_heading) |> 
  #     relocate(lyrics,        .after = dialogue) |> 
  #     relocate(other,         .after = lyrics) |> 
  #     clean_cols()
  # })
  # 
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
    if (count_var == "none") {
      tbl <- tbl |> count()
    } else {
      tbl <- tbl |> count(.data[[input$count_var]])
    }
    tbl() |> 
      collect() |> 
      clean_cols()
  })
}

shinyApp(ui, server)
