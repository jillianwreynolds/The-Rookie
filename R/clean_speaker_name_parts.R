clean_speaker_name_parts <- function(tbl, lookup_data) {
  
  move_tbl <- lookup_data |>
    filter(type == "move_first_add_last") |>
    select(sp4_match = name, new_last = replacement)
  
  add_tbl <- lookup_data |>
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
      
      # season/episode-specific replacements
      # SARAH NOLAN
      sp3 = if_else(
        when_all(
          is.na(sp3),
          when_any(
            when_all(season == 1, episode == 8),
            when_all(season == 3, episode == 12)
          )
        ),
        sp3 |> replace_when(sp4 == "SARAH" ~ "SARAH"),
        sp3
      ),
      sp4 = if_else(
        when_any(
          when_all(season == 1, episode == 8),
          when_all(season == 3, episode == 12)
        ),
        sp4 |> replace_when(sp4 == "SARAH" ~ "NOLAN"),
        sp4
      ),
      # DETECTIVE MURPHY
      sp3 = if_else(
        when_all(sp4 == "MURPHY", season == 1, episode == 16),
        "DET.",
        sp3
      ),
      # RACHEL HALL
      sp3 = if_else(
        when_all(is.na(sp3), season %in% c(2, 7)),
        sp3 |> replace_when(
          sp4 == "HALL" ~ "RACHEL",
          sp4 == "RACHEL" ~ "RACHEL"
        ),
        sp3
      ),
      sp4 = if_else(
        season %in% c(2, 7),
        sp4 |> replace_when(sp4 == "RACHEL" ~ "HALL"),
        sp4
      ),
      # Season 2: COLIN HALL and SIMON SAWYER
      sp3 = if_else(
        when_all(is.na(sp3), season == 2),
        sp3 |> replace_when(
          sp4 == "COLIN" ~ "COLIN",
          sp4 == "SIMON" ~ "SIMON"
        ),
        sp3
      ),
      sp4 = if_else(
        season == 2,
        sp4 |> replace_when(
          sp4 == "COLIN" ~ "HALL",
          sp4 == "SIMON" ~ "SAWYER"
        ),
        sp4
      ),
      # Season 3: FIONA RYAN and EVELYN NOLAN and MICHAEL and AARON MURRAY
      sp3 = if_else(
        when_all(is.na(sp3), season == 3),
        sp3 |> replace_when(
          sp4 == "RYAN"    ~ "FIONA",
          sp4 == "MICHAEL" ~ "MICHAEL",
          sp4 == "AARON"   ~ "AARON",
          sp4 == "EVELYN"  ~ "EVELYN"
        ),
        sp3
      ),
      sp4 = if_else(
        season == 3,
        sp4 |> replace_when(
          sp4 == "MICHAEL" ~ "MURRAY",
          sp4 == "AARON"   ~ "MURRAY",
          sp4 == "EVELYN"  ~ "NOLAN"
        ),
        sp4
      ),
      # JAMES MURRAY
      sp3 = if_else(
        when_all(is.na(sp3), season == 3, episode <= 6),
        sp3 |> replace_when(sp4 == "MURRAY" ~ "JAMES"),
        sp3
      ),
      # MARK MURRAY
      sp3 = if_else(
        when_all(is.na(sp3), season == 3, episode == 13),
        sp3 |> replace_when(sp4 == "MURRAY" ~ "MARK"),
        sp3
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
      # LINCOLN THORSEN (in S4, only E16)
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
      # Seasons 5, 6, 7, 8: MONICA STEVENS and TYLER and AUSTIN BRADFORD
      sp3 = if_else(
        when_all(is.na(sp3), season %in% 5:8),
        sp3 |> replace_when(
          sp4 == "MONICA" ~ "MONICA",
          sp4 == "TYLER"  ~ "TYLER",
          sp4 == "AUSTIN" ~ "AUSTIN"
        ),
        sp3
      ),
      sp4 = if_else(
        season %in% 5:8,
        sp4 |> replace_when(
          sp4 == "MONICA" ~ "STEVENS",
          sp4 == "TYLER"  ~ "BRADFORD",
          sp4 == "AUSTIN" ~ "BRADFORD"
        ),
        sp4
      ),
      # Season 8: MALCOLM WALSH and LEAH MURRAY
      sp3 = if_else(
        when_all(is.na(sp3), season == 8),
        sp3 |> replace_when(
          sp4 == "MALCOLM" ~ "MALCOLM",
          sp4 == "LEAH"    ~ "LEAH"
        ),
        sp3
      ),
      sp4 = if_else(
        season == 8,
        sp4 |> replace_when(
          sp4 == "MALCOLM" ~ "WALSH",
          sp4 == "LEAH"    ~ "MURRAY"
        ),
        sp4
      ),
      
      # move title, add first name
      sp2 = if_else(
        when_any(
          when_all(
            sp3 %in% c("DET.", "DETECTIVE"),
            sp4 %in% c("VESTRI", "WOLFE")
          ),
          when_all(sp3 == "GRACE", sp4 == "SAWYER")
        ),
        sp2 |> replace_when(
          sp4 %in% c("VESTRI", "WOLFE") ~ "DETECTIVE",
          sp4 == "SAWYER"               ~ "DR."
        ),
        sp2
      ),
      sp3 = if_else(
        when_any(
          when_all(
            sp3 %in% c("DET.", "DETECTIVE"),
            sp4 %in% c("VESTRI", "WOLFE")
          ),
          when_all(sp3 == "SGT.", sp4 == "GREY")
        ),
        case_when(
          sp4 == "VESTRI" ~ "ELIJAH",
          sp4 == "WOLFE"  ~ "KEVIN",
          sp4 == "GREY"   ~ "WADE"
        ),
        sp3
      ),
      
      # un-abbreviate titles
      across(sp2:sp3, \(x) {
        x |> 
          str_replace("DET\\.", "DETECTIVE") |> 
          str_replace("SGT\\.?", "SERGEANT")
      })
    ) |>
    select(-new_first)
  
}
