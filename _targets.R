library(targets)
library(tarchetypes)
library(arrow)
library(gt)

tar_option_set(
  packages = c("tidyverse"),
  error = "trim"
)

tar_source()

token_values <- expand_grid(
  tibble(version = c("raw", "clean")),
  tibble(n = c(NA, 2, 3))
) |> 
  mutate(
    token = if_else(is.na(n), "words", "ngrams"),
    abbr = case_when(n == 2 ~ "bi", n == 3 ~ "tri"),
    suffix = if_else(is.na(n), str_c(version), str_c(abbr, "_", version)),
    path = if_else(
      is.na(n),
      paste0("data/tokens_", version, ".parquet"),
      paste0("data/tokens_", abbr, "_", version, ".parquet"),
    ),
    df = map(version, \(v) sym(paste0("df_", v)))
  )

list(
  tar_target(
    main_chars_parquet, "data/Wikipedia/characters.parquet", format = "file"
  ),
  tar_target(
    recurring_chars_parquet,
    "data/Wikipedia/recurring_characters.parquet",
    format = "file"
  ),
  tar_target(
    crossover_characters_txt,
    "data/Wikipedia/crossover_characters.txt",
    format = "file"
  ),
  tar_target(
    notable_guests_txt,
    "data/Wikipedia/notable_guests.txt",
    format = "file"
  ),
  tar_target(
    episode_ratings_data, "data/episode_ratings_data.parquet", format = "file"
  ),
  tar_target(
    episode_ratings,
    clean_episode_ratings(episode_ratings_data |> read_parquet())
  ),
  tar_target(
    episode_ratings_parqeut,
    {
      episode_ratings |> 
        write_parquet("data/episode_ratings.parquet")
      file.copy(
        "data/episode_ratings.parquet",
        "app/episode_ratings.parquet"
      )
      file.copy(
        "data/episode_ratings.parquet",
        "episode_ratings.parquet"
      )
      "data/episode_ratings.parquet"
    },
    format = "file"
  ),
  
  # Wikipedia cast and character lists
  tar_target(main_chars_wide, create_main_chars_wide(main_chars_parquet)),
  tar_target(main_chars_long, create_main_chars_long(main_chars_wide)),
  tar_target(
    recurring_chars_wide, create_recurring_chars_wide(recurring_chars_parquet)
  ),
  tar_target(
    recurring_chars_long, create_recurring_chars_long(recurring_chars_wide)
  ),
  tar_target(
    crossover_chars_long,
    create_crossover_chars_long(crossover_characters_txt)
  ),
  tar_target(
    crossover_chars_wide,
    create_crossover_chars_wide(crossover_chars_long)
  ),
  tar_target(
    notable_guest_chars, create_notable_guest_chars(notable_guests_txt)
  ),
  tar_target(
    char_status_long,
    create_char_status_long(main_chars_long, recurring_chars_long)
  ),
  tar_target(char_status_wide, create_char_status_wide(char_status_long)),
  tar_target(characters, create_characters_tbl(char_status_long)),
  tar_target(
    characters_parquet,
    {
      characters |> write_parquet("data/characters_parquet.parquet")
      file.copy(
        "data/characters_parquet.parquet",
        "app/characters_parquet.parquet",
        overwrite = TRUE
      )
      file.copy(
        "data/characters_parquet.parquet",
        "characters_parquet.parquet",
        overwrite = TRUE
      )
      "data/characters_parquet.parquet"
    },
    format = "file"
  ),
  tar_target(lookup_chars, create_lookup_chars(characters)),
  
  # transcripts
  
  tar_target(
    transcript_list,
    list.files("data/", pattern = "\\.pdf$", recursive = TRUE)
  ),
  tar_target(
    transcripts_pdf, read_pdfs(transcript_list), packages = "pdftools"
  ),
  tar_target(
    transcripts_html, parse_episode_html(), packages = c("rvest", "xml2")
  ),
  tar_target(
    transcripts,
    {
      join_pdf_html(transcripts_pdf, transcripts_html) |> 
        write_parquet("data/transcripts.parquet")
      "data/transcripts.parquet"
    },
    format = "file"
  ),
  tar_target(
    transcripts_parquet,
    {
      transcripts |>
        read_parquet() |> 
        select(ep_number, season, episode, title) |>
        write_parquet("data/transcripts_parquet.parquet")
      file.copy(
        "data/transcripts_parquet.parquet",
        "app/transcripts_parquet.parquet",
        overwrite = TRUE
      )
      file.copy(
        "data/transcripts_parquet.parquet",
        "transcripts_parquet.parquet",
        overwrite = TRUE
      )
      "data/transcripts_parquet.parquet"
    },
    format = "file"
  ),
  tar_target(
    df_raw,
    {
      transcripts |>
        read_parquet() |> 
        run_cleaning_pipe(char_lookup = lookup_chars) |>
        write_parquet("data/df_raw.parquet")
      "data/df_raw.parquet"
    },
    format = "file"
  )#,
  # tar_target(
  #   df_clean,
  #   {
  #     transcripts |>
  #       read_parquet() |> 
  #       run_cleaning_pipe(clean = TRUE) |>
  #       write_parquet("data/df_clean.parquet")
  #     "data/df_clean.parquet"
  #   },
  #   format = "file"
  # ),
  # tar_map(
  #   values = token_values,
  #   names = suffix,
  #   unlist = TRUE,
  #   tar_target(
  #     tokens,
  #     {
  #       read_parquet(df) |>
  #         unnest_transcripts(token = token, n = n) |>
  #         write_parquet(path)
  #       path
  #     },
  #     format = "file"
  #   )
  # )
)
