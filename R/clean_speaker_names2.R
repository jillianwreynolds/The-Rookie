clean_speaker_names2 <- function(tbl) {
  
  tbl |>
    mutate(
      sp4 = if_else(
        is.na(sp3),
        # replace first name with last name
        sp4 |> replace_when(
          sp4 == "ANGELA" ~ "LOPEZ",
          sp4 == "BAILEY" ~ "NUNE",
          sp4 == "ELIJAH" ~ "STONE",
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
          sp4 == "NUNE"     ~ "BAILEY",
          sp4 == "STONE"    ~ "ELIJAH"
        ),
        sp3
      ),
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
      sp3 = ifelse(
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
    )
  
}
