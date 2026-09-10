run_cleaning_pipe <- function(tbl, clean = FALSE) {
  
  tbl <- tbl |> 
    pre_clean() |> 
    clean_speaker_names() |>
    remove_translations() |> 
    add_brackets() |>
    replace_italics() |> 
    add_space()
  
  if (clean) {
    tbl <- tbl |> clean_proper_nouns()
  }
  
  tbl |> 
    split_transcripts() |>
    shift_italics_tags() |>
    clean_previously() |> 
    clean_scene_headings() |> 
    clean_captions() |> 
    clean_other() |> 
    pre_clean_lyrics() |> 
    assign_speaker_names() |> 
    extract_speaker_note() |> 
    insert_sentinels() |> 
    unitalicize_descriptions() |> 
    unify_sentinels() |> 
    separate_at_sentinels() |> 
    reclassify_type() |>
    clean_dispatch_names() |> 
    fill_speaker_info() |>
    clean_multispeaker_names() |> 
    separate_speaker_names() |> 
    unitalicize_descriptions2() |> 
    replace_italics2()
}
