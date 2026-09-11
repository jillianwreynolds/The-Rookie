clean_speaker_names2 <- function(tbl) {
  
  # vec_first_names <- characters |> pull(first_name)
  # 
  # add_last_name <- tibble(first = c(
  #   "ANGELA",
  #   "BAILEY",
  #   "TIM"
  # )) |> 
  #   mutate(
  #     new = first,
  #     new = new |> replace_values(from = characters$first_name, to = characters$last_name),
  #   ) |> 
  #   unite(full, first, new, sep = " ", remove = FALSE) |> 
  #   mutate(detect = str_c("^", first, "$"))
  
  # characters who are referred to by only last name and 
  # share a surname with another character
  # last_name_only <- tibble(last_name = c(
  #   "BRADFORD",
  #   "CHEN",
  #   "GREY",
  #   "LOPEZ",
  #   "WEST"
  # ))
  
  ## sp4 == "AARON" is not Thorsen
  
  # character referred to by first name only
  # Tim
  
  # if using this block, names need to be separated wider again
  # tbl |> 
  #   mutate(
  #     speaker_new = map_chr(speaker, \(x) {
  #     # speaker = map_chr(speaker, \(x) {
  #       reduce2(add_last_name$first, add_last_name$full, \(acc, x, y) {
  #         str_replace_all(acc, x, y)
  #       }, .init = x)
  #     })
  #   )
  
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
