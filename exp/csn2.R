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
      sp3 = if_else(is.na(sp3) & !is.na(new_first), new_first, sp3),
      sp3 = if_else(sp3 == "GENNIFER" & sp4 == "BRADFORD", "GENNY", sp3),
      # RACHEL HALL
      sp3 = if_else(
        when_all(is.na(sp3), season != 1, episode != 11),
        sp3 |> replace_when(sp4 == "RACHEL" ~ "RACHEL"),
        sp3
      ),
      sp4 = if_else(
        when_all(season != 1, episode != 11),
        sp4 |> replace_when(sp4 == "RACHEL" ~ "HALL"),
        sp4
      ),
      # COLIN HALL
      sp3 = if_else(
        when_all(is.na(sp3), season == 2, episode == 15),
        sp3 |> replace_when(sp4 == "COLIN" ~ "COLIN"),
        sp3
      ),
      sp4 = if_else(
        when_all(season == 2, episode == 15),
        sp4 |> replace_when(sp4 == "COLIN" ~ "HALL"),
        sp4
      ),
      # SIMON SAWYER
      sp3 = if_else(
        when_all(is.na(sp3), season == 2, episode == 18),
        sp3 |> replace_when(sp4 == "SIMON" ~ "SIMON"),
        sp3
      ),
      sp4 = if_else(
        when_all(season == 2, episode == 18),
        sp4 |> replace_when(sp4 == "SIMON" ~ "SAWYER"),
        sp4
      ),
      # MICHAEL MURRAY
      sp3 = if_else(
        when_all(is.na(sp3), season == 3, episode == 2),
        sp3 |> replace_when(sp4 == "MICHAEL" ~ "MICHAEL"),
        sp3
      ),
      sp4 = if_else(
        when_all(is.na(sp3), season == 3, episode == 2),
        sp4 |> replace_when(sp4 == "MICHAEL" ~ "MURRAY"),
        sp4
      ),
      # AARON MURRAY
      sp3 = if_else(
        when_all(is.na(sp3), season == 3, episode == 2),
        sp3 |> replace_when(sp4 == "AARON" ~ "AARON"),
        sp3
      ),
      sp4 = if_else(
        when_all(is.na(sp3), season == 3, episode == 2),
        sp4 |> replace_when(sp4 == "AARON" ~ "MURRAY"),
        sp4
      ),
      # JAMES MURRAY
      sp3 = if_else(
        when_all(is.na(sp3), season <= 3, episode <= 6),
        sp3 |> replace_when(sp4 == "MURRAY" ~ "JAMES"),
        sp3
      ),
      # FIONA RYAN
      sp3 = if_else(
        when_all(is.na(sp3), season == 3, episode %in% 6:14),
        sp3 |> replace_when(sp4 == "RYAN" ~ "FIONA"),
        sp3
      ),
      # MARK MURRAY
      sp3 = if_else(
        when_all(is.na(sp3), season == 3, episode == 13),
        sp3 |> replace_when(sp4 == "MURRAY" ~ "MARK"),
        sp3
      ),
      # CHRIS SANFORD
      sp3 = if_else(
        when_all(is.na(sp3), season %in% 4:5),
        sp3 |> replace_when(sp4 == "SANFORD" ~ "CHRIS"),
        sp3
      ),
      # JASON WYLER
      sp3 = if_else(
        when_all(is.na(sp3), season %in% c(4, 7)),
        sp3 |> replace_when(sp4 == "JASON" ~ "JASON"),
        sp3
      ),
      sp4 = if_else(
        season %in% c(4, 7),
        sp4 |> replace_when(sp4 == "JASON" ~ "WYLER"),
        sp4
      ),
      # TOM BRADFORD
      sp3 = if_else(
        when_all(is.na(sp3), season == 4, episode == 9),
        sp3 |> replace_when(sp4 == "TOM" ~ "TOM"),
        sp3
      ),
      sp4 = if_else(
        when_all(season == 4, episode == 9),
        sp4 |> replace_when(sp4 == "TOM" ~ "BRADFORD"),
        sp4
      ),
      # MONICA STEVENS
      sp3 = if_else(
        when_all(is.na(sp3), season %in% 5:8),
        sp3 |> replace_when(sp4 == "MONICA" ~ "MONICA"),
        sp3
      ),
      sp4 = if_else(
        season %in% 5:8,
        sp4 |> replace_when(sp4 == "MONICA" ~ "STEVENS"),
        sp4
      ),
      sp3 = if_else(
        when_any(
          when_all(is.na(sp3), season == 5, episode == 12),
          season %in% 6:7
        ),
        sp3 |> replace_when(sp4 == "STEVENS" ~ "MONICA"),
        sp3
      ),
      # TYLER BRADFORD
      sp3 = if_else(
        when_all(is.na(sp3), season == 5, episode == 11),
        sp3 |> replace_when(sp4 == "TYLER" ~ "TYLER"),
        sp3
      ),
      sp4 = if_else(
        when_all(season == 5, episode == 11),
        sp4 |> replace_when(sp4 == "TYLER" ~ "BRADFORD"),
        sp4
      ),
      # TYLER and AUSTIN BRADFORD
      sp3 = if_else(
        when_all(is.na(sp3), season == 7, episode == 8),
        sp3 |> replace_when(
          sp4 == "TYLER" ~ "TYLER",
          sp4 == "AUSTIN" ~ "AUSTIN"
        ),
        sp3
      ),
      sp4 = if_else(
        when_all(season == 7, episode == 8),
        sp4 |> replace_when(
          sp4 == "TYLER"  ~ "BRADFORD",
          sp4 == "AUSTIN" ~ "BRADFORD"
        ),
        sp4
      ),
      # LINCOLN THORSEN
      sp3 = if_else(
        when_all(is.na(sp3), season == 4, episode == 16),
        sp3 |> replace_when(sp4 == "LINCOLN" ~ "LINCOLN"),
        sp3
      ),
      sp4 = if_else(
        when_all(season == 4, episode == 16),
        sp4 |> replace_when(sp4 == "LINCOLN" ~ "THORSEN"),
        sp4
      ),
      # MALCOLM WALSH
      sp3 = if_else(
        when_all(is.na(sp3), season == 8),
        sp3 |> replace_when(sp4 == "MALCOLM" ~ "MALCOLM"),
        sp3
      ),
      sp4 = if_else(
        season == 8,
        sp4 |> replace_when(sp4 == "MALCOLM" ~ "WALSH"),
        sp4
      ),
      # LEAH MURRAY
      sp3 = if_else(
        when_all(is.na(sp3), season == 8, episode == 7),
        sp3 |> replace_when(sp4 == "LEAH" ~ "LEAH"),
        sp3
      ),
      sp4 = if_else(
        when_all(season == 8, episode == 7),
        sp4 |> replace_when(sp4 == "LEAH" ~ "MURRAY"),
        sp4
      )
    ) |>
    select(-new_first)
  
}
