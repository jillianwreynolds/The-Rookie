# Load packages required to define the pipeline:
library(targets)
library(arrow)
library(gt)

tar_option_set(
  packages = c("tidyverse")
)

tar_source()

list(
  tar_target(
    transcript_list,
    list.files("data/", pattern = "\\.pdf$", recursive = TRUE)
  ),
  tar_target(
    transcripts_raw, read_pdfs(transcript_list), packages = "pdftools"
  ),
  tar_target(
    transcripts_html, parse_episode_html(), packages = c("rvest", "xml2")
  ),
  tar_target(
    transcripts, join_pdf_html(transcripts_raw, transcripts_html)
  ),
  tar_target(
    transcripts_parquet,
    {
      transcripts |> 
        select(season, episode, title) |> 
        write_parquet("data/transcripts_parquet.parquet")
      "data/transcripts_parquet.parquet"
    },
    format = "file"
  ),
  tar_target(
    transcripts_lines,
    {
      transcripts |> 
        pre_split_clean() |> 
        transcripts_to_lines() |>
        write_parquet("data/transcripts_lines.parquet")
      "data/transcripts_lines.parquet"
    },
    format = "file"
  ),
  tar_target(
    transcripts_clean,
    {
      open_dataset(transcripts_lines) |>
        collect() |>
        clean_transcripts() |>
        split_italics_dialogue() |> 
        split_dialogue_italicized_descriptions() |> 
        left_join(
          transcripts |> select(-c(pdf, html)),
          by = join_by(season, episode)
        ) |> 
        write_parquet("data/transcripts_clean.parquet")
      "data/transcripts_clean.parquet"
    },
    format = "file"
  ),
  tar_target(
    test_lines,
    {
      transcripts |> 
        pre_clean() |> 
        clean_speaker_names() |>
        remove_translations() |> 
        add_brackets() |>
        add_space() |> 
        split_transcripts() |>
        shift_italics_tags() |>
        clean_previously() |> 
        clean_scene_headings() |> 
        clean_captions() |> 
        clean_other() |> 
        write_parquet("data/test_lines.parquet")
      "data/test_lines.parquet"
    },
    format = "file"
  )#,
  # tar_target(
  #   test_clean,
  #   {
  #     open_dataset(transcripts_lines) |>
  #       collect() |>
  #       clean_transcripts() |>
  #       split_italics_dialogue() |> 
  #       split_dialogue_italicized_descriptions() |> 
  #       left_join(
  #         transcripts |> select(-c(pdf, html)),
  #         by = join_by(season, episode)
  #       ) |> 
  #       write_parquet("data/test_clean.parquet")
  #     "data/test_clean.parquet"
  #   },
  #   format = "file"
  # )
)
