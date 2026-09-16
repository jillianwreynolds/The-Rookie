library(shiny)
library(targets)
library(arrow)
library(DT)

tar_load(transcripts)
transcripts <- transcripts |> select(season, episode, title)
transcripts_clean <- open_dataset(
  here::here("data/transcripts_clean.parquet"), format = "parquet"
)


# vars, options, funs -----------------------------------------------------

choices_count <- c("Lines" = "type", "Speakers" = "speaker_end")

choices_group <- c("Season" = "season", "Episode" = "episode")

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

# alone, characters vector doesn't account for "Henry Nolan" or "Mrs. Chen"
chars <- c("NOLAN", "CHEN", "BRADFORD", "LOPEZ", "GREY", "HARPER")
characters <- set_names(chars, chars |> str_to_title())

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
    column(1),
    column(2, DTOutput("n_episodes", width = "10%"))
  ),
  h2("EDA"),
  h3("Counts"),
  sidebarLayout(
    sidebarPanel(
      selectInput("count_var", "Count", choices_count),
      uiOutput("type_option"),
      selectInput(
        "group_var", "By", c("", "All", choices_group), selected = ""
      ),
      uiOutput("char_option"),
      width = 3
    ),
    mainPanel(
      DTOutput("counts")
    )
  ),
  headerPanel(""),
  fluidRow(
    column(1),
    column(2, selectInput(
      "choices_char", "Select Character", 
      choices = characters),
      DTOutput("n_lines", width = "15%")
    ),
    column(6, plotOutput("plot", height = "500px")),
    column(3)
  ),
  headerPanel(""),
  headerPanel("")
)


# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  output$type_option <- renderUI(
    if (input$count_var == "type") {
      selectInput(
        "type_filter", "Type of line",
        c("All", line_types), selected = "All"
      )
    }
  )
  
  output$char_option <- renderUI(
    if (input$count_var == "speaker_end") {
      radioButtons(
        "filter_char", "Include only main characters?", c("Yes", "No")
      )
    }
  )
  
  output$n_lines <- renderDT(
    transcripts_clean |> 
      select(season, episode, type, speaker_start, speaker_end) |> 
      collect() |> 
      filter_chars() |> 
      filter(speaker_end == input$choices_char) |> 
      group_by(season) |> 
      count() |> 
      rename(Season = season, Lines = n),
    options = list(dom = "t")
  )
  
  output$n_episodes <- renderDT(
    transcripts_clean |> 
      select(season, episode) |> 
      distinct() |>  
      count(season) |> 
      collect() |> 
      rename(Season = season, Episodes = n),
    options = list(dom = "t")
  )
  
  output$episodes <- renderDT(
    transcripts |> rename_with(\(x) str_to_title(x))
  )
  
  output$counts <- renderDT({
    group_cols <- switch(input$group_var,
                         "All"    = character(0),
                         "season"  = "season",
                         "episode" = c("season", "episode")
    )
    tbl <- transcripts_clean |> 
      select(season, episode, title, type, speaker_start, speaker_end)
    if (input$count_var == "type" && !is.null(input$type_filter) && input$type_filter != "All" && input$type_filter != "NA") {
      tbl <- tbl |> filter(type == input$type_filter)
    }
    if (input$count_var == "type" && !is.null(input$type_filter) && input$type_filter == "NA") {
      tbl <- tbl |> filter(is.na(type))
    }
    if (input$count_var == "speaker_end" && input$filter_char == "Yes") {
      tbl <- tbl |> filter_chars()
    }
    tbl <- tbl |> group_by(across(all_of(group_cols)))
    if (input$count_var == "type") {
      tbl <- tbl |> count(type)
    }
    if (input$count_var == "speaker_end") {
      tbl <- tbl |> 
        count(speaker_end) |> 
        mutate(speaker_end = speaker_end |> str_to_title()) |> 
        rename(Character = speaker_end)
    }
    if (input$group_var == "season") {
      tbl <- tbl |> arrange(season)
    }
    if (input$group_var == "episode") {
      tbl <- tbl |> arrange(season, episode)
    }
    tbl <- tbl |> collect() 
    tbl |> 
      clean_cols()
  })
  
  observeEvent(input$count_var, {
    updateSelectInput(session, "group_var", selected = "")
  })
  
  output$plot <- renderPlot({
    transcripts_clean |>
      select(season, episode, title, type, speaker_start, speaker_end) |>
      filter_chars() |>
      group_by(season) |>
      count(speaker_end) |>
      collect() |>
      mutate(
        season = as_factor(season),
        speaker_end = fct_reorder(speaker_end, desc(n))
      ) |>
      ggplot(aes(season, n)) +
      geom_point(aes(season, n, color = speaker_end, group = speaker_end), size = 2) +
      geom_line(aes(season, n, color = speaker_end, group = speaker_end)) +
      # scale_y_continuous(expand = expansion(c(0, 0.5))) +
      scale_colour_viridis_d(labels = \(x) str_to_title(x), end = 0.9) +
      labs(x = "Season", y = "Count", color = "Character") +
      theme_light() +
      theme(
        axis.title = element_text(size = 15),
        axis.text = element_text(size = 13),
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 12)
      )
  })
  
}

shinyApp(ui, server)
