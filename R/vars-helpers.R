preview_columns <- c(
  "season",
  "episode",
  "line",
  "type",
  "transcript"
)

symbols <- list(
  red_circle          = "\U1f534",
  orange_circle       = "\U1f7e0",
  green_circle        = "\U1f7e2",
  blue_circle         = "\U1f535",
  purple_circle       = "\U1f7e3",
  brown_circle        = "\U1f7e4",
  black_circle        = "\U26AB",
  red_square          = "\U1f7e5",
  orange_square       = "\U1f7e7",
  green_square        = "\U1f7e9",
  blue_square         = "\U1f7e6",
  purple_square       = "\U1f7ea",
  brown_square        = "\U1f7eb",
  blue_diamond        = "\U1f537",
  orange_diamond      = "\U1f536",
  red_exclamation     = "\u2757",
  red_cross           = "\U274c",
  red_loop            = "\U2b55",
  fist                = "\u270a"
)

list2env(symbols, .GlobalEnv)

symbols_tbl <- symbols |> 
  as_tibble() |> 
  pivot_longer(everything(), names_to = "name", values_to = "symbol") |> 
  mutate(code = symbol |> stringi::stri_escape_unicode())
