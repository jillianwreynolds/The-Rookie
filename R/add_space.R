#' Add space between characters
#'
#' When a splace is missing between opening and closing parentheses and square brackets, this function adds a space. It also adds a space between `"]["`
#' @param tbl A table with each episode's transcript as a single string.
#'
#' @returns
#' @export
#'
#' @examples
add_space <- function(tbl) {
  
  lookbehind <- c("\\.", "\\-") |> str_flatten(collapse = "c")
  
  lookahead <- c("[A-Z]", "\"") |> str_flatten(collapse = "c")
  
  tbl |> 
    mutate(
      html = html |> 
        str_replace_all(coll(")("), ") (") |> 
        str_replace_all(coll("]["), "] [") |> 
        # when missing, add space between character and (
        str_replace_all("(?<=\\.|\\-)\\(", " (") |> 
        str_replace_all("(?<=\\.|\\-)\\[", " [") |> 
        # when missing, add space between ) and next character
        str_replace_all("\\)(?=[A-Z]|\")", ") ") |> 
        str_replace_all("\\](?=[A-Z]|\")", "] ")
    )
  
}

