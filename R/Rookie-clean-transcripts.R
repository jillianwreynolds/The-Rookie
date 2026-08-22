#' Split transcripts into lines
#'
#' Splits transcripts line by line. First
#' @param tbl 
#'
#' @returns
#' @export
#'
#' @examples
transcripts_to_lines <- function(tbl) {
  
  tbl |> 
    mutate(
      transcript = html |> 
        str_replace_all("(\u201c|\u201d)", "\"") |>
        str_replace_all("\u2018|\u2019", "'") |>
        str_remove_all("\u2028") |> 
        str_remove(                   # remove title block info
          "^(THE\\sROOKIE[\\s\\S]+?\"[^\"\\n]+\"[^\\S\\n]*\\n+|[\\s\\n]+)"
        ) |> 
        str_remove(
          "^(THE\\sROOKIE[\\s\\S]+?\"[^\"\\n]+\"[^\\S\\n]*\\n+|[\\s\\n]+)"
        ) |> 
        str_split("\n")
    ) |> 
    unnest(transcript) |> 
    filter_out(transcript == "")
  
}

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
        ) |> 
        # remove descriptions denoted by [] and ()
        str_remove_all("(?<=[A-Z])\\s?\\([^)]+\\)\\s?") |>
        str_remove_all("(?<=[A-Z])\\s?\\[[^]]+\\]\\s?") |> 
        str_remove_all("(?=\\s?)\\([^\\)]+\\)\\s?") |> 
        str_remove_all("(?=\\s?)\\[[^]]+\\]\\s?"),
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
        str_detect(transcript, "^<i>")                   ~ "italics"
      ),
      is_speaker = if_else(
        is.na(type),
        str_detect(transcript, speaker_name_patterns),
        FALSE
      ),
      is_break = is_speaker | !is.na(type),
      group_id = cumsum(is_break),
      .by = c(season, episode)
    ) |>
    summarise(
      speaker = first(transcript[is_speaker]),
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


# str_detect(transcript, speaker_name_patterns) ~ "speaker_name"
# str_detect(transcript, "^ACTOR![A-Z]+")       ~ "dialogue_recorded",
# str_detect(transcript, speaker_name_patterns) ~ "dialogue"

clean_transcripts_newer <- function(tbl) {
  
  tbl |> 
    mutate(
      transcript = transcript |> 
        # scoot <i> from middle to beginning of word
        str_replace_all("(\\w+)<i>", "<i>\\1") |> 
        # remove ":\\s" separating name and dialogue; names from lower to upper
        str_replace("(^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+):\\s", "\\1") |> 
        str_replace(
          "^([A-Z][a-zA-Z0-9\\s#/,]+):\\s",
          \(x) str_remove(str_to_upper(x), ":\\s")
        ) |> 
        # remove descriptions denoted by [] and ()
        str_remove_all("(?<=[A-Z])\\s?\\([^)]+\\)\\s?") |>
        str_remove_all("(?<=[A-Z])\\s?\\[[^]]+\\]\\s?") |> 
        str_remove_all("(?=\\s?)\\([^\\)]+\\)\\s?") |> 
        str_remove_all("(?=\\s?)\\[[^]]+\\]\\s?")
    ) |> 
    mutate(
      # create type "previously"
      type = case_when(
        str_detect(
          transcript,
          "Previously\\son\\s(\"?The Rookie\"?|THE\\sROOKIE)"
        ) ~ "previously",
        str_detect(transcript, "\u266a") ~ "lyrics"
      ),
      # clean "Previously on..." lines; remove "</?i>"
      transcript = case_when(
        type == "previously" ~ transcript |> 
          str_remove("\\.{3}") |> 
          str_remove_all("</?i>") |> 
          str_remove(":$") |>
          str_replace("(?<=\\s)The\\sRookie|THE\\sROOKIE", "\"The Rookie\"") |> 
          str_remove("ANNOUNCER"),
        type == "lyrics" ~ transcript |> str_remove_all("</?i>"),
        .default = transcript
      )
    ) |> 
    mutate(
      transcript = transcript |> 
        str_split("\u266a{2}|(\u266a\\s/\\s\u266a)")
    ) |> 
    unnest(transcript) |> 
    mutate(transcript = transcript |> str_remove_all("\u266a\\s?")) |> 
    filter_out(transcript == "" | str_starts(transcript, "<i>")) |>
    mutate(line = row_number(), .by = c(season, episode), .after = episode)
  
}

clean_transcripts_err <- function(tbl) {
  
  lookahead <- "(?=[\"$♪\'\\.a-z]|[A-Z][\\s-]|\\d(?![-A-Z#]))"
  
  full_pattern <- c(
    str_c("^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+", lookahead),
    str_c("^ACTOR![A-Z]+", lookahead),
    str_c("^[A-Z][a-z]{1,2}[A-Z]+", lookahead)
  ) |> 
    str_flatten(collapse = "|")
  
  tbl |> 
    mutate(
      # remove ":\\s" separating name and dialogue; converts lower to upper
      transcript = transcript |> 
        str_replace("(^[A-Z0-9][A-Z0-9\\s\\.\\-\\'#&,/]+):\\s", "\\1") |> 
        str_replace(
          "^([A-Z][a-zA-Z0-9\\s#/,]+):\\s",
          \(x) str_remove(str_to_upper(x), ":\\s")
        ) |> 
        # remove descriptions denoted by [] and ()
        str_remove_all("(?<=[A-Z])\\s?\\([^)]+\\)\\s?") |>
        str_remove_all("(?<=[A-Z])\\s?\\[[^]]+\\]\\s?") |> 
        str_remove_all("(?=\\s?)\\([^\\)]+\\)\\s?") |> 
        str_remove_all("(?=\\s?)\\[[^]]+\\]\\s?")
    ) |> 
    mutate(
      # create type "previously"
      type = case_when(
        str_detect(
          transcript,
          "Previously\\son\\s(\"?The Rookie\"?|THE\\sROOKIE)"
        ) ~ "previously",
        str_detect(transcript, "\u266a") ~ "lyrics"
      ),
      # clean "Previously on..." lines; remove "</?i>"
      transcript = case_when(
        type == "previously" ~ transcript |> 
          str_remove("\\.{3}") |> 
          str_remove_all("</?i>") |> 
          str_remove(":$") |>
          str_replace("(?<=\\s)The\\sRookie|THE\\sROOKIE", "\"The Rookie\"") |> 
          str_remove("ANNOUNCER"),
        type == "lyrics" ~ transcript |> str_remove_all("</?i>")
      )
    ) |> 
    mutate(
      transcript = transcript |> 
        str_split("\u266a{2}|(\u266a\\s/\\s\u266a)")
    ) |> 
    unnest(transcript) |> 
    mutate(transcript = transcript |> str_remove_all("\u266a\\s?")) |> 
    filter_out(str_starts(transcript, "<i>")) |> 
    mutate(
      transcript = transcript |> str_remove_all("</?i>"),
      # categorize lines by type 
      type = case_when(
        transcript %in% captions ~ "caption",
        str_detect(transcript, "(INT|EXT)(\\.|,)") ~ "scene_heading",
        str_detect(transcript, "PATROL\\sCAR") ~ "scene_heading",
        str_detect(transcript, "^ACTOR![A-Z]+") ~ "dialogue_recorded",
        str_detect(transcript, all_caps_pattern) ~ "dialogue",
        str_detect(transcript, full_pattern) ~ "dialogue"
      ),
      # categorize scenes by type
      scene = case_when(
        type == "scene_heading" & str_detect(transcript, "EXT") ~ "EXT",
        type == "scene_heading" & str_detect(transcript, "INT") ~ "INT",
        type == "scene_heading" & 
          str_detect(transcript, "PATROL\\sCAR") ~ "shop"
      )
    ) |> 
    filter_out(transcript == "") |> 
    mutate(
      rowID = row_number()
    ) |> 
    mutate(line = row_number(), .by = c(season, episode), .after = episode)
  
}
