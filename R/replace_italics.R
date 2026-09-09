replace_italics <- function(tbl) {
  
  lines <- tibble(old = c(
    "<i>CHEN turns her phone off and puts it away.</i>",  # 2x10
    "<i>Sees the car.</i>",  # 2x15
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
  
  # 5x4 dialogue with audio over radio
  radio <- tibble(original = c(
    "7-Adam-15, are you there? <i>7-Adam-15, are you there?</i> Nolan. 7-Adam-15. <i>Nolan. 7-Adam-15.</i> Hey, where are you? <i>Hey, where are you?</i> 7-Adam-15, report. <i>7-Adam-15, report.</i>",
    "7-Adam-15, what's your status? <i>7-Adam-15, what's your status?</i> 7-Adam-15. Nolan. <i>7-Adam-15. Nolan.</i> Nolan, this is Lucy. <i>Nolan, this is Lucy.</i> We're trying to locate you. <i>We're trying to locate you.</i> Are you there? <i>Are you there?</i> Nolan, please answer. <i>Nolan, please answer.</i>"
  )) |> 
    mutate(new = original |> 
             str_replace_all("<i>", "[Over radio: ") |> 
             str_replace_all("</i>", "]")
    )
  
  tbl |> 
    mutate(
      html = map_chr(html, \(x) {
        reduce2(lines$old, lines$new, \(acc, old, new) {
          str_replace(acc, coll(old), new)
        }, .init = x)
      }),
      html = html |> 
        str_replace(coll(radio$original[1]), radio$new[1]) |> 
        str_replace(coll(radio$original[2]), radio$new[2])
    )
  
}
