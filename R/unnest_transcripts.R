unnest_transcripts <- function(tbl, token = "words", n = NULL) {
  
  if (token == "words") {
    tbl <- tbl |> unnest_tokens(unnested, transcript, to_lower = FALSE)
  } else {
    tbl <- tbl |> unnest_tokens(
      unnested, transcript, token = token, n = n, to_lower = FALSE
    )
  }
  
  tbl |> 
    mutate(word = unnested |> str_to_lower(), .after = unnested)
  
}
