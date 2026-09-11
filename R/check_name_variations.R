check_name_variations <- function(tbl = df_raw, pattern) {
  
  tbl |> 
    select(speaker) |> 
    filter(str_detect(speaker, pattern)) |> 
    collect() |> 
    distinct(speaker)
  
}
