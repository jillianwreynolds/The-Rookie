clean_dispatch_names <- function(tbl) {
  
  dispatch_names <- tbl |> 
    select(speaker) |> 
    filter(str_detect(speaker, "(911|9\\-1\\-1)|(?i)(dispatch|operator)")) |> 
    unique() |> 
    filter_out(str_detect(speaker, "DRONE")) |> 
    pull(speaker)
  
  tbl |> mutate(speaker = speaker |> replace_when(
    speaker %in% dispatch_names ~ "9-1-1 DISPATCH"
  ))
  
}
