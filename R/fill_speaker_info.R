fill_speaker_info <- function(tbl) {
  
  update_italics <- function(x) {
    x |> 
      mutate(
        speaker = if_else(
          italicized_dialogue,
          lag(speaker),
          speaker
        ),
        speaker_note = if_else(
          italicized_dialogue,
          lag(speaker_note),
          speaker_note
        ),
        type = if_else(italicized_dialogue, "dialogue", type)
      )
  }
  
  update_dialogue <- function(x) {
    x |> 
      mutate(
        speaker = if_else(
          description_dialogue,
          lag(speaker, n = 2),
          speaker
        ),
        speaker_note = if_else(
          description_dialogue,
          lag(speaker_note, n = 2),
          speaker_note
        ),
        type = if_else(description_dialogue, "dialogue", type)
      )
  }
  
  tbl |> 
    mutate(
      italicized_dialogue = type == "italics" & lag(transcript) == "",
      description_dialogue = type == "dialogue" & is.na(speaker),
      .after = transcript
    ) |> 
    update_italics() |> 
    update_dialogue() |> 
    # Repeat for when speaker's line is split by italics more than once
    update_dialogue() |> 
    update_dialogue() |> 
    # If pre-split line was description then dialogue, pass speaker name
    mutate(
      speaker = if_else(
        type == "description" & lag(transcript) == "",
        lag(speaker),
        speaker
      )
    ) |> 
    filter_out(when_all(
      type == "dialogue",
      transcript == ""
    ))

}
