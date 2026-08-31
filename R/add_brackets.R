#' Add brackets to unmarked description
#'
#' Some description is not italicized or contained in parentheses or brackets. This function wraps such descriptions in square brackets.
#' @param tbl 
#'
#' @returns
#' @export
#'
#' @examples
add_brackets <- function(tbl) {
  
  lines <- tibble(old = c(
    # 1x12
    "The paramedics have arrived and are taking DENISE out of the room on a gurney.",
    # 2x20
    "WEST and LOPEZ storm the kitchen, where SERJ is trapped.",
    # 4x6
    "BAILEY pulls MITCHELL's spare key from under a pot on the porch and lets herself into his house.",
    "She goes straight to a room that looks like an office and starts looking through the desk drawers, finally finding a folder marked RECEIPTS.",
    "She spreads the receipts out on the desktop and uses her phone camera to take pictures of them.",
    "When she goes to restore the receipts to their folder, several fall on the floor and she kneels to gather them up.",
    "From her position she sees a cigar box duct-taped to the underside of the desk and pulls it off. Opening it, she finds several odd items -- glasses, a key fob, and a gold watch that matches the one on the police flyer. She lays them out and photographs them as well.",
  "BAILEY hears a car pull up, returns the box to its place, and leaves the room.",
  "She looks over the bannister to see that MITCHELL has arrived home; as he starts up the stairs, looking over the mail in his hand, she ducks back into the office and hides in a closet.",
  "MITCHELL enters the office and tosses the mail on his desk. He sees the folder and picks up a receipt lying on the floor, looks around the room, and is about to open the closet when the doorbell rings.",
  "MITCHELL opens his front door to find NOLAN standing there.",
  "BAILEY is sneaking downstairs and out of the house."
  )) |> 
    mutate(new = str_c("[", old, "]"))
  
  tbl |> 
    mutate(
      html = map(html, \(x) {
        reduce2(lines$old, lines$new, \(acc, x, y) {
          str_replace(acc, coll(x), y)
        }, .init = x)
        
      })
    )      
  
}
