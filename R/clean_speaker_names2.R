clean_speaker_names2 <- function(tbl) {
  
  tbl |>
    mutate(
      sp4 = if_else(
        is.na(sp3),
        # replace first name with last name
        sp4 |> replace_when(
          sp4 == "ANGELA" ~ "LOPEZ",
          sp4 == "BAILEY" ~ "NUNE",
          sp4 == "TIM"    ~ "BRADFORD",
          sp4 == "WESLEY" ~ "EVERS"
        ),
        sp4
      ),
      sp3 = if_else(
        is.na(sp3),
        sp3 |> replace_when(
          # add first name in sp3
          sp4 == "ANDERSEN" ~ "ZOE",
          sp4 == "BRADFORD" ~ "TIM",
          sp4 == "CHEN"     ~ "LUCY",
          sp4 == "HARPER"   ~ "NYLA",
          sp4 == "NOLAN"    ~ "JOHN",
          sp4 == "RUSSO"    ~ "JESSICA",
          # add first name (sp4 originally first name)
          sp4 == "BRADFORD" ~ "TIM",
          sp4 == "EVERS"    ~ "WESLEY",
          sp4 == "LOPEZ"    ~ "ANGELA",
          sp4 == "NUNE"     ~ "BAILEY"
        ),
        sp3
      ),
      sp4 = if_else(
        when_all(is.na(sp3), season == 4, episode == 9),
        sp4 |> replace_when(
          sp4 == "TOM" ~ "BRADFORD"
        ),
        sp4
      ),
      sp3 = if_else(
        when_all(is.na(sp3), season == 4, episode == 9),
        sp3 |> replace_when(
          sp4 == "BRADFORD" ~ "TOM"
        ),
        sp3
      ),
      sp4 = if_else(
        when_all(is.na(sp3), season == 4, episode == 16),
        sp4 |> replace_when(
          sp4 == "LINCOLN" ~ "THORSEN"
        ),
        sp4
      ),
      sp3 = if_else(
        when_all(is.na(sp3), season == 4, episode == 16),
        sp3 |> replace_when(
          sp4 == "THORSEN" ~ "LINCOLN"
        ),
        sp3
      )
    )
  
}
