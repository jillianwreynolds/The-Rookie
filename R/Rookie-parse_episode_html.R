parse_episode_html <- function(folder_path = "data/html") {
  
  file_list <- list.files(folder_path, full.names = TRUE, recursive = TRUE)
  
  parse_p <- function(p) {
    if (length(xml_children(p)) == 0) {
      return(html_text2(p))
    }
    
    xml_contents(p) |>
      map_chr(\(node) {
        if (xml_type(node) == "text") {
          xml_text(node)
        } else if (xml_name(node) == "i") {
          str_c("<i>", html_text2(node), "</i>")
        } else if (xml_name(node) == "br") {
          "\n"
        } else {
          html_text2(node)
        }
      }) |>
      str_flatten()
  }
  
  parse_single <- function(html_path) {
    read_html(html_path) |>
      html_element(".mw-parser-output") |>
      html_elements("p") |>
      map_chr(parse_p) |>
      str_flatten(collapse = "\n")
  }
  
  tibble(
    html_path = file_list,
    transcript = map_chr(file_list, possibly(parse_single, otherwise = NA_character_))
    # original = map_chr(file_list, possibly(parse_single, otherwise = NA_character_))
  ) |> 
    mutate(
      html_path = basename(html_path) |> 
        str_remove("\\.html") |> 
        str_remove("^\\d+x\\d+_")  #,
      # transcript = str_remove(original, "^[\\s\\S]+?\"[^\"]+\"\n{1,2}")
    ) |> 
    rename(title = html_path)

}
