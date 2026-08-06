#' Rename transcript files
#'
#' This function cleans the names of episode transcripts. Transcripts came from https://the-rookie.fandom.com/wiki/The_Rookie_Wiki and were downloaded by opening Reader on Safari and saving to PDF via the Print menu.
#' @param season The season to indicate which episode transcripts are to be renamed.
rename_transcripts <- function(season) {
  
  beginning <- paste0(
    "data/The-Rookie/Season-",
    season,
    "/"
  )
  
  file_list <- list.files(paste0(beginning))
  
  walk(file_list, \(x) {
    
    clean_name <- x |> 
      str_remove_all("\"") |> 
      str_extract(".+(?=(:|\\s)(T|t)ranscript)")
    
    new_name <- paste0(
      beginning,
      clean_name,
      ".pdf"
    )
  file.rename(paste0(beginning, x), new_name)
  })
}

rename_transcripts(1)
# walk(2:7, \(x) rename_transcripts(x))
