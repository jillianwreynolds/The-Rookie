unnest_transcripts <- function(tbl, ...) {
  
  tbl |> 
    unnest_tokens(unnested, transcript, ..., to_lower = FALSE) |> 
    mutate(word = unnested |> str_to_lower(), .after = unnested)
  
}
