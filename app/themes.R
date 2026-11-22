# bs ----------------------------------------------------------------------

rookie_theme <- bs_theme(
  version = 5,
  bootswatch = "cosmo",
  primary = dark_teal,
  secondary = teal
) |>
  bs_add_variables(
    "headings-color"     = dark_teal,
    "link-color"         = teal,
    "code-color"         = code_color
  )

# ggplot ------------------------------------------------------------------

gg_theme <- theme_light() +
  theme(
    axis.title   = element_text(size = 15),
    axis.text    = element_text(size = 14),
    legend.title = element_text(size = 14),
    legend.text  = element_text(size = 13)
  )
