preview_columns <- c(
  "season",
  "episode",
  "line",
  "type",
  "transcript"
)

symbols <- list(
  circles = list(
    red_circle          = "\U1f534",
    orange_circle       = "\U1f7e0",
    green_circle        = "\U1f7e2",
    blue_circle         = "\U1f535",
    purple_circle       = "\U1f7e3",
    brown_circle        = "\U1f7e4",
    black_circle        = "\U26AB"
  ),
  squares = list(
    red_square          = "\U1f7e5",
    orange_square       = "\U1f7e7",
    green_square        = "\U1f7e9",
    blue_square         = "\U1f7e6",
    purple_square       = "\U1f7ea",
    brown_square        = "\U1f7eb"
  ),
  diamonds = list(
    blue_diamond        = "\U1f537",
    orange_diamond      = "\U1f536"
  ),
  hearts = list(
    red_heart           = "\U2764\Ufe0f",
    green_heart         = "\U1f49a\Ufe0f",
    blue_heart          = "\U1f499\Ufe0f",
    purple_heart        = "\U1f49c\Ufe0f" 
  ),
  other = list(
    red_exclamation     = "\u2757",
    red_cross           = "\U274c",
    red_loop            = "\U2b55",
    fist                = "\u270a"
  )
)

symbols |> list_flatten(name_spec = "{inner}") |>list2env(.GlobalEnv)

symbols_tbl <- tibble(x = symbols) |> 
  unnest_longer(x, values_to = "symbol") |> 
  rename(name = symbol_id) |> 
  mutate(
    code = symbol |> stringi::stri_escape_unicode()
  )
