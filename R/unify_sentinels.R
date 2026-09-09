unify_sentinels <- function(tbl, symbol = red_circle) {
  
  symbols_list <- c(
    # non-italics lines
    red_circle, brown_square, brown_circle, red_loop, red_cross,
    # italics lines
    blue_square,
    blue_circle, purple_circle,
    blue_diamond, red_square, orange_diamond
  )
  
  tbl |> 
    mutate(
      transcript = reduce(symbols_list, \(acc, s) {
        str_replace_all(acc, s, symbol)
      }, .init = transcript)
    )
  
}
