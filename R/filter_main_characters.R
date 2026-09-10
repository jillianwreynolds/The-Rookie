filter_main_characters <- function(tbl) {
  
  tbl |> filter(when_any(
    when_all(
      sp3 %in% main_chars$first_name,
      sp4 %in% main_chars$last_name
    ),
    when_all(
      is.na(sp3),
      sp4 %in% main_chars$last_name
    )
  ))
  
}
