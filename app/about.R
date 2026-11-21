
# Project -----------------------------------------------------------------

about_project_cards <- list(
  project = card(
    card_header("About This Project", class = "bg-secondary"),
    p(
      "This project uses HTML downloads of episode transcripts from ", tags$a(href="https://the-rookie.fandom.com/", "the-rookie.fandom.com", .noWS = "after", target = "_blank"), ". It uses various ", code("R"), " packages and functions to parse the HTML, extract information, and clean and analyze the data. The tables on this site were not a product of manual typing and counting or copying and pasting information from existing lists."
    )
  ),
  status = card(
    card_header("Project Status", class = "bg-secondary"),
    "This project is still in progress."
  ),
  objectives = card(
    card_header("Objectives", class = "bg-secondary"),
    markdown("
    Explore *The Rookie* with data
    - Exploratory data analysis
    - Text analysis
    - ...
    
    Practice/learn skills
      - Strings and regular expressions
      - Working with large data sets
      - Web development
        - Shiny and Shinylive
        - HTML
        - CSS
    ")
  )
)

about_project <- nav_panel(
  title = "Project",
  layout_column_wrap(
    about_project_cards$project,
    about_project_cards$status,
    about_project_cards$objectives
  )
)

# Data --------------------------------------------------------------------

about_data_cards <- list(
  transcripts = card(
    card_header("Transcripts", class = "bg-secondary"),
    p(
      "Episode transcripts were downloaded as page source (HTML) from ", tags$a(href="https://the-rookie.fandom.com/", "the-rookie.fandom.com", .noWS = "after", target = "_blank"), "."
    )
  ),
  characters = card(
    card_header("Characters", class = "bg-secondary"),
    p("Lists of characters (main, recurring, guest) were scraped from", em("The Rookie", .noWS = "after"), "'s", tags$a(href="https://en.wikipedia.org/wiki/The_Rookie", "Wikipedia", target = "_blank"), "page between September 10 and 14, 2026.", .noWS = "after")
  ),
  ratings = card(
    card_header("Episode Ratings", class = "bg-secondary"),
    p("Episode rating data comes from IMDb data downloaded on July 31, 2026 from", tags$a(href="https://datasets.imdbws.com", "https://datasets.imdbws.com", .noWS = "after", target = "_blank"), ".")
  )
)

about_data <- nav_panel(
  title = "Data",
  layout_column_wrap(
    about_data_cards$transcripts,
    about_data_cards$characters,
    about_data_cards$ratings
  )
)


# Methodology -------------------------------------------------------------

packages_tooltip <- tooltip(
  bsicons::bs_icon("info-circle"),
  "This list is not exhaustive; see GitHub repository for a full list of packages used in this project.",
  placement = "right"
)

about_methodology_cards <- list(
  R = card(
    card_header("R", class = "bg-secondary"),
    markdown("I use `R`, `RStudio`, and `Quarto` to plan the project and explore and analyze the data. I use the former two for analyzing the data and publishing the results. I use `renv` for package version control. The project combines R, markdown, HTML and CSS.")
  ),
  github = card(
    card_header("GitHub", class = "bg-secondary"),
    "I use GitHub for version tracking and GitHub Pages to publish this website.",
    tags$a(href="https://github.com/jillianwreynolds/The-Rookie/", "GitHub repository", .noWS = "after", target = "_blank")
  ),
  website = card(
    card_header(
      "R packages used for website",
      class = "bg-secondary",
      packages_tooltip
    ),
    markdown("
      - Shiny
      - Shinylive
      - bslib
      - shinyjs
      - nanoparquet
      - glue
      - DT
    ")
  ),
  analysis = card(
    card_header(
      "R packages used for analysis",
      class = "bg-secondary",
      packages_tooltip
    ),
    markdown("
      - tidyverse
      - targets
      - arrow
    ")
  ),
  notes = card(
    card_header("Notes", class = "bg-secondary"),
    markdown('
      - Dialogue that was recorded and replayed in an episode may be counted more than once. This includes lines from clips shown after "Previously on *The Rookie*..."
      - Most descriptions within a transcript were transcribed such that I was able to use punctuation or HTML code to mark descriptsions as description. Some descriptions were indistinguishable from dialogue, however. I manually coded many descriptions as description rather than dialogue, but it is possible I have not found all instances.
     ')
  )
)

about_methodology <- nav_panel(
  title = "Methodology",
  layout_column_wrap(
    about_methodology_cards$R,
    about_methodology_cards$github,
    about_methodology_cards$website,
    about_methodology_cards$analysis
  ),
  about_methodology_cards$notes
)

about_menu <- nav_menu(
  "About",
  about_project,
  about_data,
  about_methodology
)
