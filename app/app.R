library(shiny)
library(nanoparquet)
library(tidyverse)
library(DT)
library(bslib)

# setup -------------------------------------------------------------------

tbl_transcripts <- nanoparquet::read_parquet("transcripts_parquet.parquet")

# for testing tbl_transcripts
# tbl_transcripts <- nanoparquet::read_parquet("app/transcripts_parquet.parquet")

theme <- bs_theme(
  primary = "#0a333f",
  secondary = "#2f8b9d",
  base_font = "Helvetica"
) |>
  bs_add_variables(
    "headings-color" = "#0a333f",
    "link-color" = "#2f8b9d",
    "code-color" = "purple"
  )

# About section -----------------------------------------------------------

about_section <- htmltools::tagList(
  tags$summary("About This Project", style = "display: list-item; font-size:20px"),
  p(
    em("The Rookie"), "has 144 episodes. For each, fans have written transcripts on ", tags$a(href="https://the-rookie.fandom.com/", "the-rookie.fandom.com", .noWS = "after"), ". The goals of this project are to use an interest of mine to practice and improve my skills for working with text data and to create a Shiny web app. I have also been learning about html and, through the use of shinylive to create this Shiny application, the basics of web development.",
    style = "font-size:16px"
  ),
  p(
    "Each episode transcript has a webpage. I downloaded each webpage as an html file. To turn the html source text into useable text, I used xml2 and rvest. I also used pdftools to read the text from Safari Reader pdf files of the transcripts. Extraction of the season, episode, and title for each transcript came early on in my data cleaning process, resulting in a rather inelegant stringr regular expressions, such as ", code("\"(?<=THE\\\\sROOKIE\\\\n(Season|SEASON)\\\\s)\\\\d+\"", .noWS = "after"), ".",
    style = "font-size:16px"
  ),
  p(
    "After I finish cleaning the data, I will use packages like tidytext to convert the data into rows and columns such that each column is a variable and each word has a row. Splitting the transcripts into lines of scene headings, descriptions, and dialogue creates tens of thousands of rows; splitting transcripts by word would create an even larger data set. This takes up a lot of memory on the computer, so I use parquet files and arrow to minimize memory usage and speed up data storage and processing.",
    style = "font-size:16px"
  )
)

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
          "This project uses HTML downloads of episode transcripts from ", tags$a(href="https://the-rookie.fandom.com/", "the-rookie.fandom.com", .noWS = "after", target = "_blank"), ". It uses various ", code("R"), " packages and functions to parse the HTML, extract information, and analyze the data. The tables below were not a product of manual typing and counting or copying and pasting information from existing lists. This project is still in progress.",
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
