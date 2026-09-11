additional_chars <- tribble(
  ~name,       ~replacement,
  "BLANCA",    "JUAREZ",
  "DIEGO",     "DE_LA_CRUZ",
  "DOMINIQUE", "GREY",
  "GENNIFER",  "BRADFORD",
  "JOY",       "BRADFORD",
  "KARLA",     "JUAREZ",
  "YVONNE",    "THORSEN"
)

move_first_add_last_tbl <- tibble(name = c(
  "ABIGAIL", "ABRIL",
  "BAILEY", "BEN", "BLANCA",
  "DIEGO", "DOMINIQUE", "DONOVAN",
  "ELIJAH", "EMMETT",
  "GENNIFER", "GENNY", "GRACE",
  "ISABEL",
  "JACKSON", "JESSICA", "JOY",
  "KARLA",
  "LILA", "LUNA",
  "NELL",
  "OSCAR",
  "PERCY",
  "RANDY", "RODGE", "ROSALIND", "RUBEN",
  "TAMARA", "TIM",
  "VIVIAN",
  "WESLEY",
  "YVONNE"
))

add_first_tbl <- tibble(name = c(
  "ANDERSEN", "ARMSTRONG",
  "BISHOP", "BRADFORD",
  "CHEN", "COLINS",
  "DE_LA_CRUZ", "DEL_MONTE", "DERIAN", "DYER",
  "ECKERT",
  "FREEMAN",
  "GLASSER", "GREY",
  "HALL", "HARPER", "HUTCHINSON",
  "JUAREZ",
  "LANG", "LONDON", "LOPEZ",
  "NOLAN",
  "PENN",
  "RIDLEY", "RUSSO", "RYAN",
  "SAWYER", "SMITTY", "STANTON", "STONE",
  "THORSEN",
  "VESTRI",
  "WALSH", "WEST", "WOLFE", "WYLER"
))

lookup_chars <- bind_rows(
  move_first_add_last_tbl |> mutate(type = "move_first_add_last"),
  add_first_tbl |> mutate(type = "add_first")
) |>
  mutate(
    replacement = if_else(
      type == "move_first_add_last",
      name |> recode_values(
        from = characters$first_name,
        to   = characters$last_name
      ),
      NA_character_
    ),
    replacement = if_else(
      type == "add_first",
      name |> recode_values(
        from = characters$last_name,
        to   = characters$first_name
      ),
      replacement
    ),
    replacement = if_else(
      is.na(replacement),
      name |> recode_values(
        from = additional_chars$name,
        to = additional_chars$replacement
      ),
      replacement
    ),
    replacement = replacement |> str_replace_all("NICHOLAS", "NICK")
  ) |>
  relocate(replacement, .after = name)

lookup_chars |> print_inf()

