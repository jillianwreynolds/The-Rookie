check_sentinel <- function(tbl, sentinel, n = 20) {
  tbl |> 
    select(season, episode, type, speaker, speaker_note, transcript) |> 
    filter(str_detect(transcript, sentinel)) |> 
    collect() |> 
    slice_sample(n = n, by = season) |> 
    arrange(season, episode)
}
