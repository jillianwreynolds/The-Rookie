filter_characters <- function(
    tbl,
    filter = c("top6", "main", "recurring")
) {

  filter <- match.arg(filter)
  
  chars <- switch(filter,
                  top6      = main_chars,
                  main      = characters[characters$type == "main", ],
                  recurring = characters[characters$type == "recurring", ]
  )
  
  if (filter %in% c("top6", "main")) {
    tbl |> filter(when_all(
      when_any(
        sp3 %in% chars$first_name,
        is.na(sp3)
      ),
      sp4 %in% chars$last_name
    ))
  } else {
    warn("This filter misses instances where a recurring character is referred to by only their last name.")
    tbl |> filter(when_all(
      sp3 %in% chars$first_name,
      sp4 %in% chars$last_name
    ))
  }

}
