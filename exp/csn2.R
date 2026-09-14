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

csn2 <- function(tbl) {
  
  move_tbl <- lookup_chars |>
    filter(type == "move_first_add_last") |>
    select(sp4_match = name, new_last = replacement)
  
  add_tbl <- lookup_chars |>
    filter(type == "add_first") |>
    select(sp4_match = name, new_first = replacement)
  
  tbl |>
    # handle move_first_add_last: sp4 is a first name, move to sp3, replace with last
    left_join(move_tbl, by = c("sp4" = "sp4_match")) |>
    mutate(
      do_move = is.na(sp3) & !is.na(new_last),   # evaluate once, before any mutation
      sp3 = if_else(do_move, sp4,      sp3),
      sp4 = if_else(do_move, new_last, sp4)
    ) |>
    select(-new_last, -do_move) |>
    # handle add_first: sp4 is a last name, fill sp3 with first name
    left_join(add_tbl, by = c("sp4" = "sp4_match")) |>
    mutate(
      sp3 = if_else(is.na(sp3) & !is.na(new_first), new_first, sp3)
    ) |>
    select(-new_first)
  
}
