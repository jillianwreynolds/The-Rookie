remove_translations <- function(tbl) {
  
  tbl |> 
    mutate(
      html = html |> 
        # 1x4
        str_remove("(?<=<i>quinceañera</i>\\.)\\s\\-\\s15th\\sbirthday\\.") |> 
        str_remove("(?<=<i>abuelo</i>\\.)\\s\\-\\sHer\\sdad\\.") |> 
        # 7x17
        str_remove("(?<=verruckt)\\s\\(crazy\\)") |> 
        # 8x11
        str_remove("(?<=<i>Sumpfland</i>\\.)\\s\\[marshland\\]") |> 
        str_remove("(?<=Wunderbar)\\s\\(wonderful\\)")
    )
  
}
