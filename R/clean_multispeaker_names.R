clean_multispeaker_names <- function(tbl) {
  
  aliases <- tribble(
    ~name,      ~alias,   ~type,    ~pattern,
    "BRADFORD", "JAKE",   "UC",     "BRADFORD/JAKE",
    "CHEN",     "SAVA",   "UC",     "CHEN/SAVA",
    "DEBBIE",   "AURORA", "alias",  "AURORA/DEBBIE",
    "FREEMAN",  "YOUNG",  "alias",  "FREEMAN/YOUNG",
    "KAILEY",   "NADIA",  "alias",  "KAILEY/NADIA",
    "ZACH",     "IGOR",   "alias",  "ZACH/IGOR"
  )
  
  multispeaker_patterns <- c(
    ",\\s",
    ""
  ) |> str_flatten("|")
  
  tbl |> 
    mutate(
      dialogue_type = dialogue_type |> replace_when(
        str_detect(speaker, "(BRADFORD/JAKE)|(CHEN/SAVA)") ~ "UC",
        str_detect(speaker, str_flatten(aliases$pattern, "|")) ~ "alias"
      ),
      speaker = speaker |> 
        replace_values(from = aliases$pattern, to = aliases$name),
      speaker = speaker |> 
        str_replace_all(",\\s", green_circle) |> 
        str_replace_all("/", green_circle) |> 
        str_replace_all("\\s?&\\s", green_circle) |> 
        str_replace_all("\\s?(?i)and\\s", green_circle) |> 
        str_remove_all("(?<=\U1f7e2)\U1f7e2"),
      dialogue_type = dialogue_type |> replace_when(
        str_detect(speaker, green_circle) ~ "multi"
      )
    )
  
}
