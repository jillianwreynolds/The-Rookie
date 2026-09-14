dark_teal  <- "#0a333f"
teal       <- "#2f8b9d"
code_color <- "#7c13ba"

theme <- bs_theme(
  version = 5,
  bootswatch = "cosmo",
  primary = dark_teal,
  secondary = teal
) |>
  bs_add_variables(
    "headings-color" = dark_teal,
    "link-color" = teal,
    "code-color" = code_color
  )
