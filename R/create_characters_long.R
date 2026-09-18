create_characters_long <- function(main, recurring, crossover, notable) {
  
  bind_rows(
    main      |> mutate(type = "main"),
    recurring |> mutate(type = "recurring"),
    crossover |> mutate(type = "crossover"),
    notable   |> mutate(type = "notable")
  ) |>
    relocate(c(type, status), .before = actor)
  
}
