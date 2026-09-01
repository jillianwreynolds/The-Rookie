remove_translations <- function(tbl) {
  
  tbl |> 
    mutate(
      html = html |> 
        # 1x4
        str_remove("(?<=<i>quinceañera</i>\\.)\\s\\-\\s15th\\sbirthday\\.") |> 
        str_remove("(?<=<i>abuelo</i>\\.)\\s\\-\\sHer\\sdad\\.") |> 
        # 4x1
        str_remove("(?<=<i>hermana</i>)1") |> 
        str_remove("(?<=bonita</i>\\.)1") |> 
        str_remove("(?<=chiquita</i>)3") |> 
        str_remove("(?<=sicarios</i>)4") |> 
        str_remove("(?<=exfil)5") |>    # not a translation, just a footnote
        str_remove("(?<=muerte</i>)6") |> 
        str_replace("Calma te</i>\\d<i>\\.</i>\\sWe", "Calma te</i>. We") |> 
        str_remove("(?<=supuesto</i>)8") |> 
        str_remove(regex(
          "1\\s\\-\\ssister.+?of\\scourse",
          dotall = TRUE
        )) |> 
        # 7x17
        str_remove("(?<=verruckt)\\s\\(crazy\\)") |> 
        # 8x11
        str_remove("(?<=<i>Sumpfland</i>\\.)\\s\\[marshland\\]") |> 
        str_remove("(?<=Wunderbar)\\s\\(wonderful\\)")
    )
  
}
