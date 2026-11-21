top6_UI <- function(id) {
  card(
    card_header("Top 6 Speakers of the Series", class = "bg-secondary"),
    htmlOutput(NS(id, "tbl"))
  )
}

top6_server <- function(id, top6) {
  moduleServer(id, function(input, output, session) {
    output$tbl <- renderText(
      top6() |> 
        unite(character, first_name, last_name) |> 
        clean_chars_col() |> 
        pull(character) %>%
        str_c(1:6, ". ", ., collapse = "\n") |> 
        markdown()
    )
  })
}
