separate_at_sentinels <- function(tbl, sentinel = red_circle) {
  
  tbl |> 
    separate_longer_delim("transcript", sentinel)
  
}
