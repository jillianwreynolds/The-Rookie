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

## plotly

plotly_layout <- function(p, ...) {
  
  defaults <- list(
    xaxis  = list(
      title = list(font = list(size = 14)), tickfont = list(size = 12)
    ),
    yaxis  = list(
      title = list(font = list(size = 14)), tickfont = list(size = 12)
    ),
    legend = list(
      title = list(font = list(size = 13)), font = list(size = 12.5)
    )
  )
  
  args <- modifyList(defaults, list(...))
  do.call(layout, c(list(p), args))
  
}
