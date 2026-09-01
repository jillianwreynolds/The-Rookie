#' Add brackets to descriptions
#'
#' Some description is not italicized or contained in parentheses or brackets. This function wraps such descriptions in square brackets. In other places, an opening bracket is missing; this function also adds the missing bracket.
#' @param tbl 
#'
#' @returns
#' @export
#'
#' @examples
add_brackets <- function(tbl) {
  
  lines <- tibble(old = c(
    # 1x2
    "LOPEZ and WEST park in front of a convenience store.",
    # 1x3
    "LOPEZ and WEST are wrapping up their arrest. WEST is looking at something on his cell phone.",
    # 1x6
    "The mall is crowded; cops are moving, trying to secure the area. HAWKE and LOGAN are walking among the shoppers. NOLAN and HAWKE spot each other at the same time, from about 30 feet away.",
    
    # 1x12
    "ISABEL is waiting on the steps as BRADFORD comes walking up to her. She looks healthy.",
    "LOPEZ and WEST are hauling in the formerly naked man.",
    "DENISE comes up with a basket of muffins.",
    "LOPEZ and WEST come up to the intake desk. The nurse from Episode 11, GINO, is there.",
    "DENISE, BISHOP, and NOLAN are in DENISE's living room.",
    "WEST is at a desk, looking at Mr. SCOTT's records.",
    "SCOTT is retrieving his clothes as if about to get dressed. LOPEZ and WEST enter the room.",
    "NOLAN goes looking for DENISE and finds her in his bed, naked under the covers.",
    "NOLAN is on the phone with Poison Control as CHEN tries to revive DENISE.",
    "The paramedics have arrived and are taking DENISE out of the room on a gurney.",
    "NOLAN and BEN are putting away the party.",
    
    # 1x14
    "CHEN approaches a yard surrounded by a chain-link fence. A dog is barking continually in the yard.",
    # 1x17
    "LOPEZ and WEST are cruising, looking for looters.",
    "NOLAN and RUSSO are having a late-night picnic in front of a fire pit.",
    # 2x15
    "BRADFORD is chasing the man. COLIN puts his arm out and stops the suspect.",
    # 2x20
    "WEST and LOPEZ storm the kitchen, where SERJ is trapped.",
    # 3x7
    "The scene switches to the interrogation room, with LOPEZ and AURORA/DEBBIE inside.",
    
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
  "BAILEY is sneaking downstairs and out of the house.",
  
  # 5x19
  "JUAREZ looks around at the yard full of toys.",
  "NOLAN and BAILEY are sitting on the sofa.",
  # 8x7
  "A montage plays showing time passing, PENN and RIDLEY staking out STOWE's house, NOLAN talking to BAILEY on the phone, the Baja backup team watching the beach.",
  "CHEN and HARPER drive up and park the van.",
  # 8x10
  "NOLAN and DASH come across a half-filled swimming pool and find a woman standing in it, trying to hide.",
  "DASH yells and jumps into the pool to help NOLAN subdue the attacker.",
  "PENN hits several of them with beanbag ammo; the rest keep coming. NOLAN, DASH, and KAYLEIGH are being chased down another street.",
  "Several patrol cars pull into the area, lights and sirens going. BRADFORD steps out of one of them as officers take down attackers with beanbags and hand-to-hand fighting.",
  # also 8x10
  "DASH checks his phone for a signal. There is none.",
  "A group of \"zombies\" are chasing PENN down a street.",
  "HARPER, NOLAN, DASH, and KAYLEIGH are barricaded inside a building with zombies banging on the doors.",
  "PENN appears with the beanbag rifle and takes out some of their pursuers."
  )) |> 
    mutate(new = str_c("[", old, "]"))
  
  tbl |> 
    mutate(
      html = map(html, \(x) {
        reduce2(lines$old, lines$new, \(acc, x, y) {
          str_replace(acc, coll(x), y)
        }, .init = x)
      }),
      html = html |> 
        # 1x14
        str_replace(
          "NOLAN nods.\nLYNN\nPlease\\.",
          "[NOLAN nods.]\nLYNN\nPlease\\."
        ) |> 
        # 3x7
        str_replace(
          coll("Corey screams, glass breaking ]  Breathing"),
          "Corey screams, glass breaking ] [Breathing"
        ) |> 
        # 4x7
        str_replace(coll("Dial tone ]"), "[ Dial tone ]")
    )
  
}
