#' Clean transcript lines
#'
#' Cleans and labels lines by type. For scene headings, indicates type of location. For dialogue, indicates speaker and whether dialogue was recorded.
#' @param tbl A table with transcripts split into lines.
#'
#' @returns A tibble with cleaned data.
#' @export
#'
#' @examples
#' 
clean_transcripts <- function(tbl) {
  
  speaker_name_patterns <- c(
    "^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+$",
    # "^ACTOR![A-Z]+$",
    "^[A-Z][a-z]{1,2}[A-Z]+$"
  ) |> 
    str_flatten(collapse = "|")
  
  not_speaker_patterns <- c(
    "^(OK|NO)[,\\.!\\?]?\\s?(OK|NO)?[\\.!\\?]?$",
    "^LAP-$",
    "^LAPD[\\.!,]?$"
    ) |> 
    str_flatten(collapse = "|")
  
  tbl |> 
    mutate(
      transcript = transcript |> 
        # Move <i> from middle to beginning of word
        str_replace_all("(\\w+)<i>", "<i>\\1") |> 
        # remove ":\\s" separating name and dialogue; names from lower to upper
        str_replace("(^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+):\\s", "\\1") |> 
        str_replace(
          "^([A-Z][a-zA-Z0-9\\s#/,]+):\\s",
          \(x) str_remove(str_to_upper(x), ":\\s")
        ), # replace comma with pipe if un-commenting description removals
        # remove descriptions denoted by [] and ()
        # str_remove_all("(?<=[A-Z])\\s?\\([^)]+\\)\\s?") |>
        # str_remove_all("(?<=[A-Z])\\s?\\[[^]]+\\]\\s?") |> 
        # str_remove_all("(?=\\s?)\\([^\\)]+\\)\\s?") |> 
        # str_remove_all("(?=\\s?)\\[[^]]+\\]\\s?"),
      type = case_when(
        str_detect(transcript, "Previously") &
          str_detect(transcript, "(?i)Rookie")           ~ "previously",
        str_detect(transcript, "\u266a")                 ~ "lyrics",
        transcript %in% captions                         ~ "caption",
        str_detect(transcript, "(INT|EXT)(\\.|,)")       ~ "scene_heading",
        str_detect(transcript, "^(INT|EXT)(\\.|,|\\s)")  ~ "scene_heading",
        str_detect(transcript, "PATROL\\sCAR")           ~ "scene_heading",
        transcript %in% other_scene_headings             ~ "scene_heading",
        str_detect(transcript, "MID-WILSHIRE\\sSTATION") ~ "scene_heading",
        str_detect(transcript, "^<i>")                   ~ "italics",
        transcript %in% other_type_patterns              ~ "other"
      ),
      is_speaker = if_else(
        is.na(type),
        str_detect(transcript, speaker_name_patterns) &
          !str_detect(transcript, not_speaker_patterns),
        FALSE
      ),
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
    # clean "Previously on..."
    mutate(transcript = transcript |> replace_when(
      type == "previously" & !str_detect(transcript, "Feds") 
        ~ "Previously on \"The Rookie\"",
      type == "previously" & str_detect(transcript, "Feds") 
        ~ "Previously on \"The Rookie\" and \"The Rookie: Feds\""
    )) |> 
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
      speaker_start = case_when(
        str_equal(speaker_start, speaker_end) ~ NA_character_,
        .default = speaker_start
      )
    ) |> 
    mutate(
      speaker_end = str_trim(speaker_end),
      scene_type = case_when(
        type == "scene_heading" & str_detect(transcript, "INT") ~ "INT",
        type == "scene_heading" & str_detect(transcript, "EXT") ~ "EXT",
        type == "scene_heading" & 
          str_detect(transcript, "PATROL\\sCAR") ~ "shop",
        type == "scene_heading" & 
          str_detect(transcript, "MID-WILSHIRE\\sSTATION") ~ "station",
      )
    )
}
