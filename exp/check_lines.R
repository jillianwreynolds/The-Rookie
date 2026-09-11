transcripts_html$transcript[41] |> peek_match("totally playing mind games", before = 104)

transcripts$html[85] |> peek_match("until we know for")

transcripts_lines |>
  select(season, episode, transcript) |>
  filter(season == 8, episode == 15) |>
  filter(str_detect(transcript, "Clips from")) |> 
  collect()

transcripts_lines |>
  select(season, episode, transcript) |>
  # filter(season == 8, episode == 1) |>
  collect() |>
  peek_rows(transcript, "VAN DOREN", fmt = "g", after = 2)

transcripts_clean |> 
  select(season, episode, line, type, speaker, speaker_note, transcript) |> 
  filter(season == 8, episode == 15) |>
  collect() |> 
  peek_rows(speaker, "INTERVIEWER", fmt = "g", before = 2, after = 2)


# Test --------------------------------------------------------------------

test |> 
  select(season, episode, type, scene_type, transcript) |>
  # select(season:transcript) |> select(-c(title, pdf, html)) |> 
  # filter(season == 2) |> 
  # filter(season == 1, episode == 1) |>
  # filter(type == "scene_heading") |> 
  collect() |> 
  # filter(str_detect(transcript, "INT(?![.])"))
  # collect() |> 
  peek_rows(transcript, "Cello Suite No", fmt = "g")

test2 |> 
  select(season, episode, type, speaker, speaker_note, transcript) |>
  # filter(season == 2) |> 
  filter(season == 1, episode == 16) |>
  collect() |> 
  peek_rows(transcript, "LATER", fmt = "g")

test3 |> 
  select(season, episode, type, speaker, speaker_note, transcript) |>
  # filter(season == 2) |> 
  # filter(season == 2, episode == 10) |>
  collect() |> 
  peek_rows(transcript, "Cello", fmt = "g")

test3a |> 
  select(season, episode, type, speaker, speaker_note, transcript) |>
  # filter(season == 2) |> 
  # filter(season == 2, episode == 16) |>
  collect() |> 
  peek_rows(transcript, "Cello", fmt = "g")

test4 |> 
  select(season, episode, type, speaker, speaker_note, transcript) |>
  # filter(season == 2) |> 
  # filter(season == 2, episode == 16) |>
  collect() |> 
  peek_rows(transcript, "Cello", fmt = "g")

test4 |> 
  select(season, episode, type, speaker, speaker_note, transcript) |>
  # filter(season == 1) |>
  # filter(season == 2, episode == 10) |>
  # filter(type == "dialogue") |>
  # filter(str_detect(speaker, "RUTH")) |>
  # filter(str_detect(speaker, ",|&|\\s(?i)and\\s|/")) |> 
  # filter(str_detect(transcript, "DB on scene")) |> 
  collect() |> 
  peek_rows(transcript, "Cello", before = 2)
  # gt()

test4a |> 
  select(season, episode, type, speaker, speaker_note, transcript) |>
  collect() |> 
  peek_rows(transcript, "Cello", before = 2)

test4b |> 
  select(season, episode, type, speaker, speaker_note, transcript) |>
  collect() |> 
  peek_rows(transcript, "Cello", before = 2)

test5 |> 
  select(season, episode, type, speaker, speaker_note, transcript) |>
  # filter(season == 1) |>
  # filter(season == 2, episode == 10) |>
  # filter(type == "dialogue") |>
  # filter(str_detect(transcript, "catching up on")) |>
  # filter(str_detect(speaker, ",|&|\\s(?i)and\\s|/")) |> 
  collect() |> 
  peek_rows(transcript, "Cello")
  # gt()

test6 |> 
  # select(season, episode, type, speaker, speaker_note, transcript) |>
  select(season:transcript) |> 
  # filter(season == 1) |>
  # filter(season == 1, episode == 16) |>
  # filter(type == "italics") |>
  # filter(str_detect(transcript, "^[^<]")) |>
  # collect() |> gt()
  collect() |>
  peek_rows(speaker, "\\s(?i)and\\s")

test7 |> 
  select(season:transcript) |> 
  # filter(season == 1, episode == 1) |> 
  filter(type == "caption") |>
  collect()
  # collect() |>
  # peek_rows(transcript, "(?i)HI-RISE", after = 2)
