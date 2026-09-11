clean_speaker_names2 <- function(tbl) {
  
  tbl |>
    mutate(
      sp4 = if_else(
        is.na(sp3),
        # put last name in sp4
        sp4 |> replace_when(
          sp4 == "ANGELA" ~ "LOPEZ",
          sp4 == "TIM"    ~ "BRADFORD",
          sp4 == "BAILEY" ~ "NUNE"
        ),
        sp4
      ),
      sp3 = if_else(
        is.na(sp3),
        sp3 |> replace_when(
          # add first name in sp3
          sp4 == "ANDERSEN" ~ "ZOE",
          sp4 == "BRADFORD" ~ "TIM",
          sp4 == "RUSSO"    ~ "JESSICA",
          # update sp3 with first name
          sp4 == "BRADFORD" ~ "TIM",
          sp4 == "LOPEZ"    ~ "ANGELA",
          sp4 == "NUNE"     ~ "BAILEY"
        ),
        sp3
      )
      
    )
  
}
