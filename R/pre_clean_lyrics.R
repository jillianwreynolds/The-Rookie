pre_clean_lyrics <- function(tbl) {
  
  tbl |> 
    mutate(
      transcript = transcript |> 
        # un-italicize lyrics
        str_remove_all("^<i>(?=\u266a)") |>
        str_remove_all("(?<=\u266a)</i>") |> 
        # replace "♪ / ♪" with "♪" for separate_longer_delim()
        str_replace_all("\u266a\\s/\\s\u266a", "\u266a \u266a") |> 
        # remove trailing space and ellipsis
        str_remove("\\s?(\\.{3})?$") |> 
        str_replace(coll("♪ La gente paga"), "♪ La gente paga ♪") |> 
        str_replace(coll("Vuole qua ♪"), "♪ Vuole qua ♪")
    )
}
