#' Identify and clean scene headings
#'
#' Identifies scene headings, specifies scene type, and cleans text.
#' @param tbl A table with each episode's transcript split into lines.
#'
#' @returns
#' @export
#'
#' @examples
clean_scene_headings <- function(tbl) {
  
  other_scene_headings <- tribble(
    ~text,      ~type,
    # 1x7
    "PAYNE'S HOUSE - NIGHT",                                       "INT",
    # 2x1
    "CLIPS FROM SEASON 1, EPISODE 20, \"FREE FALL\"",              "previously",
    "AERIAL VIEW OF CARAVAN ESCORTED BY 2 POLICE UNITS",           "EXT",
    # 2x12
    "OUTSIDE, TRAILER PARK",                                       "EXT",
    # 3x1
    "LOPEZ/EVERS HOME, NIGHT - BEDROOM",                           "INT",
    "CEMETERY, DAY - REBECCA ARMSTRONG'S GRAVESITE",               "EXT",
    # 4x17
    "RESIDENTIAL STREET, DAY",                                     "EXT",
    # 8x15
    "NEWS CLIP - DECEMBER 5, 2022, COAST GUARD SEARCH FOR MISSING OFFICER","AV",
    "VIDEO CALL WITH INTERVIEWER, ABIGAIL, JENSEN ACKLES, JARED PADALECKI","AV"
  )
  
  prefix_lookup <- setNames(other_scene_headings$type, other_scene_headings$text)
  
  tbl |> 
    mutate(
      type = type |> replace_when(
        when_all(
          when_any(
            str_detect(transcript, "(INT|EXT)(\\.|,)"),
            str_detect(transcript, "^(INT|EXT)(\\.|,|\\s)"),
            str_detect(transcript, "PATROL\\sCAR"),
            transcript %in% other_scene_headings$text,
            str_detect(transcript, "MID-WILSHIRE\\sSTATION")
          ),
          !str_detect(transcript, "^<i>")
        ) ~ "scene_heading"
      ),
      scene_type = if_else(
        type == "scene_heading",
        case_when(
          str_detect(transcript, "PATROL\\sCAR")           ~ "shop",
          str_detect(transcript, "MID-WILSHIRE\\sSTATION") ~ "station",
          str_detect(transcript, "INT/EXT")                ~ "other",
          str_detect(transcript, "EXT(?=\\.|,|\\-)")       ~ "EXT",
          str_detect(transcript, "INT(?=\\.|,|\\-)")       ~ "INT",
          str_detect(transcript, "^EXT\\s")                ~ "EXT",
          str_detect(transcript, "^INT\\s")                ~ "INT",
          str_detect(transcript, "^AV\\.")                 ~ "AV",
          .default = "other"
        ),
        NA_character_
      ),
      # Remove parentheses from patrol car scene headings in 4x8
      transcript = if_else(
        str_detect(transcript, "^EXT.+PATROL\\sCAR\\s\\([A-Z]+/[A-Z]+\\)"),
        transcript |> str_replace("\\s\\(", ", ") |> 
          str_remove("\\)$"),
        transcript
      ),
      transcript = if_else(
        transcript %in% names(prefix_lookup),
        str_c(prefix_lookup[transcript], ". ", transcript),
        transcript
      )
    ) |> 
    relocate(scene_type, .after = type)
}
