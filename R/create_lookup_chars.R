create_lookup_chars <- function(chars_data) {
  
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
    "PERCY", "PETE",
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
    "HARPER", "HUTCHINSON",
    "JUAREZ",
    "LANG", "LONDON", "LOPEZ",
    "NOLAN",
    "PENN",
    "RIDLEY", "RUSSO",
    "SANFORD", "SAWYER", "SMITTY", "STANTON", "STONE",
    "THORSEN",
    "VESTRI",
    "WALSH", "WEST", "WOLFE", "WYLER"
  ))
  
  additional_chars <- tribble(
    ~name,       ~replacement,
    # move first and add last
    "GENNIFER",  "BRADFORD",
    "JOY",       "BRADFORD",
    "SIMONE",    "CLARK",
    "DIEGO",     "DE_LA_CRUZ",
    "JACK",      "EVERS",
    "PATRICE",   "EVERS",
    "DOMINIQUE", "GREY",
    "BLANCA",    "JUAREZ",
    "KARLA",     "JUAREZ",
    "BENNY",     "LOPEZ",
    "DAMIEN",    "LOPEZ",
    "PETE",      "NOLAN",
    "YVONNE",    "THORSEN",
    # add first name
    "ACRES",     "BRENDAN",
    "HOPE",      "CARTER",
    "STENSEN",   "LAURA"
  )
  
  bind_rows(
    move_first_add_last_tbl |> mutate(type = "move_first_add_last"),
    add_first_tbl |> mutate(type = "add_first")
  ) |>
    mutate(
      replacement = if_else(
        type == "move_first_add_last",
        name |> recode_values(
          from = chars_data$first_name,
          to   = chars_data$last_name
        ),
        NA_character_
      ),
      replacement = if_else(
        type == "add_first",
        name |> recode_values(
          from = chars_data$last_name,
          to   = chars_data$first_name
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
  
}
