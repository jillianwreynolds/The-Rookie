separate_at_sentinels <- function(tbl) {
  
  tbl |> 
    separate_longer_delim("transcript", "\u2757")
  
}
