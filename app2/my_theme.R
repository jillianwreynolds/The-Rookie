dark_teal   <- "#0a333f"
dark_teal2  <- "#0a333f30"
teal        <- "#2f8b9d"
teal2       <- "#2f8b9d30"
yellow      <- "#facf21"
yellow2     <- "#facf2125"
light_green <- "#b9d4bd"
code_color  <- "#7c13ba"

my_theme <- bs_theme(
  version = 5,
  bootswatch = "cosmo",
  primary = dark_teal,
  secondary = teal
) |> 
  bs_add_variables(
    "headings-color"     = dark_teal,
    "link-color"         = teal,
    "code-color"         = code_color,
    "card-title-color"   = teal
  )
