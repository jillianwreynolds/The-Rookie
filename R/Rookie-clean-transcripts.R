#' Clean transcript lines
#'
#' Cleans and labels lines by type. For scene headings, indicates type of location. For dialogue, indicates speaker and whether dialogue was recorded.
#' @param tbl A table with transcripts already split into lines.
#'
#' @returns A tibble with cleaned data.
#' @export
#'
#' @examples
#' 
clean_transcripts <- function(tbl) {
  
  speaker_name_patterns <- c(
    "^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+$",
    "^ACTOR![A-Z]+$",
    "^[A-Z][a-z]{1,2}[A-Z]+$",
    # identifies speakers whose name is followed by () description
    "^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+\\s[\\[|\\(].+[\\]|\\)]$"
  ) |> 
    str_flatten(collapse = "|")
  
  not_speaker_patterns <- c(
    "^(OK|NO)[,\\.!\\?]?\\s?(OK|NO)?[\\.!\\?]?$",
    "^LAP-$",
    "^LAPD[\\.!,]?$"
    ) |> 
    str_flatten(collapse = "|")
  
  tbl <- tbl |> 
    mutate(
      transcript = transcript |> 
        str_trim() |> 
        # Move <i> from middle to beginning of word
        str_replace_all("(\\w+)<i>", "<i>\\1") |> 
        # remove ":\\s" separating name and dialogue; names from lower to upper
        str_replace("(^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+):\\s", "\\1") |> 
        str_replace(
          "^([A-Z][a-zA-Z0-9\\s#/,]+):\\s",
          \(x) str_remove(str_to_upper(x), ":\\s")
        ) |> 
        # un-italicize lyrics
        str_remove("^<i>(?=\u266a)") |> 
        str_remove("(?<=\u266a)</i>") |> 
        # fix inconsistent lyrics break
        str_replace_all("\u266a\\s/\\s\u266a", "\u266a \u266a") |> 
        # remove trailing ellipsis
        str_remove("\u266a(\\s\\.{3})?$") |> 
        # replace description with speaker name and note
        str_replace(coll("[ Kai singing low in Italian ]"), "KAI (singing low in Italian)") |> 
        # fix typo, set up split
        str_replace(coll("La gente pa♪a"), "La gente paga")
    ) |> 
    # create `type` variable
    mutate(
      type = case_when(
        str_detect(transcript, "Previously") &
          str_detect(transcript, "(?i)Rookie")           ~ "previously",
        transcript %in% captions                         ~ "caption",
        transcript %in% other_descriptions               ~ "desription",
        str_detect(transcript, "(INT|EXT)(\\.|,)")       ~ "scene_heading",
        str_detect(transcript, "^(INT|EXT)(\\.|,|\\s)")  ~ "scene_heading",
        str_detect(transcript, "PATROL\\sCAR")           ~ "scene_heading",
        transcript %in% other_scene_headings             ~ "scene_heading",
        str_detect(transcript, "MID-WILSHIRE\\sSTATION") ~ "scene_heading",
        transcript %in% other_type_patterns              ~ "other"
      ),
      is_speaker = if_else(         # identify speakers
        is.na(type),
        str_detect(transcript, speaker_name_patterns) &
          !str_detect(transcript, not_speaker_patterns),
        FALSE
      ),
      type = type |> replace_when(str_detect(transcript, "^<i>") ~ "italics"),
      is_break = is_speaker | !is.na(type),
      group_id = cumsum(is_break),
      .by = c(season, episode)
    ) |>
    summarise(
      speaker = first(transcript[is_speaker] |> str_trim()),
      transcript = transcript[!is_speaker] |> str_flatten(collapse = " "),
      type = first(type),
      .by = c(season, episode, group_id)
    ) |> 
    mutate(
      type = replace_when(type, !is.na(speaker) ~ "dialogue"),
      line = row_number(),
      .by = c(season, episode)
    ) |>
    select(-group_id) |>
    relocate(c(line, type), .after = episode) |> 
    # split mixed dialogue/lyrics lines
    separate_longer_delim(transcript, delim = regex("(?=♪)")) |> 
    mutate(
      speaker = speaker |> 
        str_replace("^V/O", "VOICEOVER"),
      # specify different types of dialogue
      type = type |> 
        replace_when(
          str_detect(speaker, "\\s(AND)\\b|&\\s") ~ "dialogue_multi",
          str_detect(speaker, "[A-Z]+,\\s[A-Z]+") ~ "dialogue_multi",
          str_detect(speaker, "(BRADFORD/JAKE)|(CHEN/SAVA)") ~ "dialogue_UC",
          str_detect(speaker, str_flatten(aliases$pattern, "|")) 
          ~ "dialogue_alias",
          str_detect(speaker, "[A-Z]+/[A-Z]+") ~ "dialogue_multi"
        ),
      speaker = speaker |> 
        replace_values(from = aliases$pattern, to = aliases$name)
    ) |> 
    mutate(
      # clean "Previously on..."
      transcript = transcript |> str_trim() |> replace_when(
        type == "previously" & !str_detect(transcript, "Feds") 
        ~ "Previously on \"The Rookie\"",
        type == "previously" & str_detect(transcript, "Feds") 
        ~ "Previously on \"The Rookie\" and \"The Rookie: Feds\""
      ),
      # extract notes from speaker name
      speaker_note = speaker |> str_extract("(?<=[\\[|\\(]).+(?=[\\]\\)]$)"),
      speaker = speaker |> str_remove("\\s[\\[|\\(].+[\\]\\)]$")
    ) |> 
    # separate speaker name into start and end pieces
    separate_wider_regex(
      speaker,
      patterns = c(
        speaker_start = "^[A-Za-z0-9'-\\.]+\\s?[A-Z]*",
        speaker_end   = "\\s[A-Za-z'-0-9]+$"
      ),
      too_few = "align_start",
      cols_remove = FALSE
    ) |> 
    mutate(
      speaker_end = if_else(is.na(speaker_end), speaker_start, speaker_end),
      speaker_start = speaker_start |> replace_when(
        str_equal(speaker_start, speaker_end) ~ NA_character_
      )
    ) |> 
    mutate(
      speaker_end = str_trim(speaker_end),
      # specify scene type
      scene_type = case_when(
        type == "scene_heading" & str_detect(transcript, "INT") ~ "INT",
        type == "scene_heading" & str_detect(transcript, "EXT") ~ "EXT",
        type == "scene_heading" & 
          str_detect(transcript, "PATROL\\sCAR") ~ "shop",
        type == "scene_heading" & 
          str_detect(transcript, "MID-WILSHIRE\\sSTATION") ~ "station",
      ),
      transcript = transcript |> str_trim()
    ) |> 
    mutate(
      transcript = transcript |> str_replace("\\s(?=\\[)", "\u2757")
    ) |> 
    separate_longer_delim(transcript, regex("\u2757")) |> 
    mutate(type = type |> replace_when(
      type == "scene_heading" & str_detect(transcript, "\\[") ~ "description"
    ))
  
  line_split <- tbl |> 
    filter(speaker == "KAI", str_detect(transcript, "gente")) |> 
    separate_longer_delim(transcript, regex("\\s(?=\\[)"))
  
  row_location <- tbl |> 
    mutate(row_num = row_number()) |> 
    filter(speaker == "KAI", str_detect(transcript, "gente")) |> 
    pull(row_num)
    
  tbl |> 
    add_row(line_split, .after = row_location) |> 
    filter_out(
      str_detect(transcript, "gente") & str_detect(transcript, "Gunshots")
    ) |> 
    filter_out(season == 1 & episode == 3 & speaker == "CREDITS")

}
