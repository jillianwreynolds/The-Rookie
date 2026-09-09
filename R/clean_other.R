clean_other <- function(tbl) {
  
  other_type <- c(
    "FADE TO LATER",
    "OVERHEAD VIEW OF CARAVAN",
    "Clips from <i>300_Days_of_Hell</i>"
  )
  
  tbl |> 
    mutate(
      type = type |> replace_when(
        transcript %in% other_type ~ "other"
      )
    )
  
}
