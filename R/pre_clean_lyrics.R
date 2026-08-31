pre_clean_lyrics <- function(tbl) {
  
  tbl |> 
    mutate(
      html = html |> 
        # un-italicize lyrics
        str_remove_all("^<i>(?=\u266a)") |> 
        str_remove_all("(?<=\u266a)</i>") |> 
        # replace "♪ / ♪" with "♪" for separate_longer in clean_transcripts()
        str_replace_all("\u266a\\s/\\s\u266a", "\u266a") |> 
        # remove trailing ♪ and potential ellipsis
        str_remove("\u266a(\\s\\.{3})?$")
    )
  
}
