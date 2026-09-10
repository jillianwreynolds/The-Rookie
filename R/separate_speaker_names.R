separate_speaker_names <- function(tbl) {
  
  keep_together <- tibble(original = c(
    "DE LA CRUZ",
    "DEL MONTE",
    "VAN DOREN"
  )) |> 
    mutate(new = original |> str_replace_all("\\s", "_"))
  
  
  tbl |> 
    mutate(
      speaker = map_chr(speaker, \(x) {
        reduce2(keep_together$original, keep_together$new, \(acc, x, y) {
          str_replace_all(acc, coll(x), y)
        }, .init = x)
      })
    ) |> 
    separate_wider_delim(
      speaker, delim = " ", names = c("sp1", "sp2", "sp3", "sp4"),
      too_few = "align_end"
    ) |>
    relocate(matches("sp\\d"), .after = transcript)
  
}
