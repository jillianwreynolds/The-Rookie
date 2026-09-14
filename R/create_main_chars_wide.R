create_main_chars_wide <- function(file_path) {
  
  file_path |> 
    read_parquet() |> 
    rename(first_name = character_first, last_name = character_last) |> 
    relocate(actor, .after = last_col())
  
}
