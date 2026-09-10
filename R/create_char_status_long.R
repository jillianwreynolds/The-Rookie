create_char_status_long <- function(main, recurring) {
  
  bind_rows(
    main |> mutate(type = "main"),
    recurring |> mutate(type = "recurring")
  ) |>
    select(-c(row, text)) |>
    relocate(type, .before = actor)
  
}
