#' Read pdf text
#'
#' Read text from pdf files of transcripts.
#' @param file_list 
#'
read_pdfs <- function(file_list) {
  
  map(file_list, \(x) {
    
    path <- paste0("data/The-Rookie/", x)
    name <- x |> str_extract("(?<=\\d{1}/).+(?=\\.pdf)")
    
    text <- path |> 
      pdf_text() |> 
      str_flatten()
    
    tribble(
      ~ transcript,
      text
    )
    
  }) |> 
    bind_rows()
}
