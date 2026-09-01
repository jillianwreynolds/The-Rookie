replace_italics <- function(tbl) {
  
  lines <- tibble(old = c(
    "<i>CHEN turns her phone off and puts it away.</i>",  # 2x10
    # 3x14
    "I'm not so sure. <i>Gun cocks.</i> I have a very good memory for faces.",
    "I'm coming! <i>A man, who works for DE LA CRUZ, is standing with a gun pointing at Lopez.</i>",
    "Angela? It's John. I got your bouquet. <i>Knocks on door.</i> Angela? Lopez? <i>He goes in and sees that Lopez is missing. He turns for the door and finds Lopez's red bracelet on the floor.</i>"
  )) |> 
    mutate(
      new = old |> 
        str_replace_all("<i>", "[") |> 
        str_replace_all("</i>", "]")
    )
  
  tbl |> 
    mutate(
      html = map(html, \(x) {
        reduce2(lines$old, lines$new, \(acc, old, new) {
          str_replace(acc, coll(old), new)
        }, .init = x)
      }),
      html = html |> as.character()
    )
  
}
