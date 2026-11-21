median_season_ratings_UI <- function(id) {
  value_box(
    id = id,
    title = "seasons with a median rating of 7.5 or higher",
    value = textOutput(NS(id, "seasons")),
    showcase = bsicons::bs_icon("star"),
    class = "median_season_ratings value-first"
  )
  
}

median_season_ratings_server <- function(id, ratings_stats) {
  moduleServer(id, function(input, output, session) {
    output$seasons <- renderText(
      ratings_stats() |> 
        filter(median >= 7.5) |> 
        nrow()
    )
  })
  
}
