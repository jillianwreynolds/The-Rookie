replace_italics2 <- function(tbl) {
  
  tbl |> 
    mutate(
      transcript = transcript |> 
        str_replace_all("<i>", green_square) |> 
        str_replace_all("</i>", green_square)
    )
  
}
