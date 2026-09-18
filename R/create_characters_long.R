create_char_status_long <- function(main, recurring, crossover, notable) {
  
  bind_rows(
    main      |> mutate(type = "main"),
    recurring |> mutate(type = "recurring"),
    crossover |> mutate(type = "crossover"),
    notable   |> mutate(type = "notable")
  ) |>
    select(-c(row, text)) |>
    relocate(c(type, status), .before = actor)
  
}
