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

stutter_cutoff_letters <- c(
  "I-I-I-",
  "N-",
  "I\\s-",
  "W--",
  "I\\s--",
  "I-I\\.{3}",
  "[IXVTP]\\.{3}",
  "I--",
  "I-I"
)

stutter_cutoff_letters_pattern <- str_c(
  "^(",
  stutter_cutoff_letters |> str_flatten(collapse = "|"),
  ")$"
)
