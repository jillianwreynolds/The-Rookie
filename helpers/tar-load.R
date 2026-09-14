tar_load(matches("^main_chars_[lw]"))
tar_load(matches("^recurring_chars_[lw]"))
tar_load(matches("^crossover_chars_[lw]"))
tar_load(notable_guest_chars)
tar_load(matches("char_stat"))
tar_load(characters)


tar_load(transcripts_html)

tar_load(transcripts)
transcripts <- open_dataset(transcripts)


tar_load(starts_with("df"))
df_raw           <- open_dataset(df_raw)
df_clean         <- open_dataset(df_clean)


tar_load(matches("^tokens_"))
tokens_raw       <- open_dataset(tokens_raw)
tokens_clean     <- open_dataset(tokens_clean)
tokens_bi_raw    <- open_dataset(tokens_bi_raw)
tokens_bi_clean  <- open_dataset(tokens_bi_clean)
tokens_tri_raw   <- open_dataset(tokens_tri_raw)
tokens_tri_clean <- open_dataset(tokens_tri_clean)



# old ---------------------------------------------------------------------

tar_load(transcripts_lines)
tar_load(transcripts_clean)
transcripts_lines <- open_dataset(transcripts_lines, format = "parquet")
transcripts_clean <- open_dataset(transcripts_clean, format = "parquet")
