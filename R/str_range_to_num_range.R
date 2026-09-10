str_range_to_num_range <- function(string, sep = "") {
  
  map_chr(string, \(s) {
    if (is.na(s)) return(NA_character_)
    
    bounds <- s |> str_split(":") |> unlist()
    x      <- bounds[1] |> as.integer()
    y      <- bounds[2] |> as.integer()
    
    numbers <- seq(x, y) |> as.character() |> str_flatten(collapse = sep)
  })
  
}
