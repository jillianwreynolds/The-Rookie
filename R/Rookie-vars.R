captions <- c(
  "OPENING TITLESTHE ROOKIE",
  "NINE MONTHS LATER",
  "TWO WEEKS LATER",
  "\"ONE MONTH LATER\"",
  "\"DAY 2\"",
  "\"DAY 4\"",
  "97 MINUTES EARLIER",
  "6 WEEKS LATER",
  "TO BE CONTINUED...",
  "12 HOURS EARLIER",
  "EMERGENCY ALERT",
  "BALLISTIC MISSILE THREAT",
  "INBOUND TO LOS ANGELES",
  "SEEK IMMEDIATE SHELTER",
  "IMPACT IN 29 MINUTES",
  "THIS IS NOT A DRILL",
  "IN TRAILER",
  "DETECTIVES' BULLPEN",
  "THREE MONTHS LATER"
)

all_caps_start_words <- c(
  "L\\.A\\.P\\.D\\.",
  "L\\.A\\.",
  "I\\.D\\.",
  "UCLA\\.",
  "ADT\\?",
  "AJ\\.",
  "SWAT\\.",
  "CIA\\.",
  "OK\\.",
  "APM\\.",
  "G-R-O-U-T\\."
)

all_caps_pattern <- str_c(
  "^(",
  all_caps_start_words |> str_flatten(collapse = "|"),
  ")"
)

other_scene_headings <- c(
  "CLIPS FROM SEASON 1, EPISODE 20, \"FREE FALL\" ",
  "PAYNE'S HOUSE - NIGHT",
  "AERIAL VIEW OF CARAVAN ESCORTED BY 2 POLICE UNITS",
  "OUTSIDE, TRAILER PARK",
  "LOPEZ/EVERS HOME, NIGHT - BEDROOM",
  "CEMETERY, DAY - REBECCA ARMSTRONG'S GRAVESITE",
  "RESIDENTIAL STREET, DAY",
  "NEWS CLIP - DECEMBER 5, 2022, COAST GUARD SEARCH FOR MISSING OFFICER",
  "VIDEO CALL WITH INTERVIEWER, ABIGAIL, JENSEN ACKLES, JARED PADALECKI"
)

other_type_patterns <- c(
  "FADE TO LATER",
  "OVERHEAD VIEW OF CARAVAN"
)

aliases <- tribble(
  ~name,      ~alias,   ~type,    ~pattern,
  "BRADFORD", "JAKE",   "UC",     "BRADFORD/JAKE",
  "CHEN",     "SAVA",   "UC",     "CHEN/SAVA",
  "DEBBIE",   "AURORA", "alias",  "AURORA/DEBBIE",
  "FREEMAN",  "YOUNG",  "alias",  "FREEMAN/YOUNG",
  "KAILEY",   "NADIA",  "alias",  "KAILEY/NADIA",
  "ZACH",     "IGOR",   "alias",  "ZACH/IGOR"
)

italicized_titles <- c(
  "50 Shades",
  "Trading Fire",
  "Trading Fire Five",
  "Trading Fire Two",
  "Catch-22",
  "Death Wish",
  "Architectural Digest",
  "Midnight Apocalypse",
  "Rio Bravo",
  "Split Second Leadership: Leading Men In The Line Of Duty.",
  "Split Second Leadership: Leading Men In The Line Of Duty",
  "Split Second Leadership",
  "Downton Abbey",
  "Aeronautics Through the Ages",
  "Lady and the Tramp",
  "Hot Suspect",
  "The Maltese Falcon",
  "Cop Rock",
  "Candyman",
  "Teen Rebel",
  "The Great British Baking Show",
  "The Godfather",
  "Los Angeles Herald",
  "Herald",
  "Action Heist",
  "The Bachelor",
  "The Cardinal",
  "General Hospital",
  "Paul's Place",
  "Rocky",
  "Dirty Harry.",
  "Dirty Harry",
  "Bosch",
  "Top Chef",
  "Chinatown",
  "300 Days of Hell",
  "The Ring",
  "Scream",
  "Blair Witch Project",
  "THDOH",
  "Dead Bastards MC", # 2x4
  "Willy Wonka",
  "I Never Loved a Man" #2x16
)

stutter_cutoff_letters <- c(
  "I-I-I-",
  "N-",
  "I\\s-",
  "W--",
  "I\\s--",
  "I-I\\.{3}",
  "[IXVTP]\\.{3}",
  "I--"
)

stutter_cutoff_letters_pattern <- str_c(
  "^(",
  stutter_cutoff_letters |> str_flatten(collapse = "|"),
  ")$"
)

other_descriptions <- c(
  "LOPEZ and WEST park in front of a convenience store.",
  "LOPEZ and WEST are wrapping up their arrest. WEST is looking at something on his cell phone.",
  "The mall is crowded; cops are moving, trying to secure the area. HAWKE and LOGAN are walking among the shoppers. NOLAN and HAWKE spot each other at the same time, from about 30 feet away.",
  "ISABEL is waiting on the steps as BRADFORD comes walking up to her. She looks healthy.",
  "LOPEZ and WEST are hauling in the formerly naked man.",
  "DENISE comes up with a basket of muffins.",
  "LOPEZ and WEST come up to the intake desk. The nurse from Episode 11, GINO, is there.",
  "DENISE, BISHOP, and NOLAN are in DENISE's living room.",
  "WEST is at a desk, looking at Mr. SCOTT's records.",
  "SCOTT is retrieving his clothes as if about to get dressed. LOPEZ and WEST enter the room.",
  "NOLAN goes looking for DENISE and finds her in his bed, naked under the covers.",
  "NOLAN is on the phone with Poison Control as CHEN tries to revive DENISE.",
  "NOLAN and BEN are putting away the party.",
  "CHEN approaches a yard surrounded by a chain-link fence. A dog is barking continually in the yard.",
  "LOPEZ and WEST are cruising, looking for looters.",
  "NOLAN and RUSSO are having a late-night picnic in front of a fire pit.",
  "JUAREZ looks around at the yard full of toys.",
  "NOLAN and BAILEY are sitting on the sofa."
)
