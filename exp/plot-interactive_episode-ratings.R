library(shiny)
library(tidyverse)

dark_teal   <- "#0a333f"
dark_teal2  <- "#0a333f30"
teal        <- "#2f8b9d"
teal2       <- "#2f8b9d30"
yellow      <- "#facf21"
yellow2     <- "#facf2125"
light_green <- "#b9d4bd"
code_color  <- "#7c13ba"

gg_theme <- theme_light() +
  theme(
    axis.title = element_text(size = 15),
    axis.text = element_text(size = 14),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 13)
  )

ratings_csv <- read_csv(I("season,episode,rating,n_votes
1,16,9,3799
5,22,9,2796
2,11,8.8,3038
2,10,8.6,2497
8,3,8.6,1614
8,17,8.6,1202
1,8,8.6,2810
1,20,8.5,2429
7,8,8.5,1571
1,9,8.5,2641
2,8,8.4,2147
2,19,8.4,1994
1,15,8.4,2451
4,6,8.3,1887
3,14,8.2,2122
1,14,8.2,2255
6,9,8.2,1282
8,6,8.2,1337
7,9,8.2,1358
2,18,8.1,1864
1,19,8.1,2094
1,10,8.1,2332
2,4,8,2005
2,6,8,2062
2,1,8,2167
2,20,8,2265
7,4,8,1336
7,5,8,1280
5,1,8,2137
7,16,8,1311
8,18,8,1155
3,1,7.9,2602
2,2,7.9,2035
3,13,7.9,1835
5,19,7.9,1416
8,7,7.9,1157
7,7,7.9,1303
8,2,7.9,1354
6,8,7.9,1237
1,1,7.9,3997
1,11,7.9,2258
1,2,7.8,3015
2,17,7.8,1758
2,3,7.8,1986
2,7,7.8,1892
3,5,7.8,2413
3,10,7.8,1843
7,18,7.8,1232
4,9,7.8,1611
7,14,7.8,1258
7,10,7.8,1277
8,16,7.8,977
4,15,7.8,1570
5,8,7.8,1515
8,12,7.8,979
8,11,7.8,979
7,1,7.8,1585
5,13,7.8,1517
4,7,7.8,1677
5,17,7.8,1420
1,7,7.8,2386
1,3,7.7,2750
1,5,7.7,2486
2,15,7.7,1778
2,16,7.7,1823
2,9,7.7,1881
2,5,7.7,1914
4,3,7.7,1632
7,6,7.7,1452
8,5,7.7,1134
6,1,7.7,1700
4,4,7.7,1666
5,12,7.7,1498
7,2,7.7,1332
8,13,7.7,930
1,6,7.7,2483
1,13,7.7,2172
1,12,7.7,2235
2,12,7.6,1842
2,13,7.6,1823
2,14,7.6,1778
3,12,7.6,1793
4,2,7.6,1815
5,15,7.6,1482
1,18,7.6,2090
1,17,7.6,2203
4,5,7.6,1785
4,10,7.6,1585
6,4,7.6,1285
7,13,7.6,1190
7,11,7.6,1281
4,11,7.6,1583
6,10,7.6,1382
1,4,7.6,2590
3,8,7.5,1928
3,9,7.5,2095
4,1,7.5,2482
5,2,7.5,1680
7,3,7.5,1278
5,9,7.5,1469
8,4,7.5,1162
4,18,7.5,1562
5,5,7.5,1520
8,14,7.5,972
8,1,7.5,1856
6,5,7.5,1251
5,14,7.5,1337
5,21,7.5,1377
7,17,7.5,1180
3,11,7.4,2015
6,6,7.4,1298
4,21,7.4,1506
5,11,7.4,1359
5,10,7.4,1629
6,7,7.3,1236
8,8,7.3,1195
8,9,7.3,1093
5,3,7.3,1574
7,12,7.3,1536
5,4,7.3,1894
8,10,7.3,1471
5,16,7.3,1408
5,7,7.2,1438
4,12,7.2,1571
4,13,7.2,1605
5,6,7.2,1498
5,20,7.1,1387
4,8,7.1,1764
4,17,7.1,1625
6,2,7.1,1600
4,22,7,2245
3,4,6.7,2472
3,6,6.7,2497
4,14,6.7,1733
3,2,6.4,2892
3,3,6.2,2875
6,3,6.2,1578
4,20,6.1,2134
4,19,6,2351
4,16,4.9,2830
5,18,4.6,2541
3,7,4.5,4323
7,15,3.6,2847
8,15,3.1,2656
"), col_types = "iidi")

custom_slider_css <- glue::glue("
      /* Remove minor ticks */
      .irs-grid-pol.small { height: 0px; }
      /* Customize play button */
      .slider-animate-button { 
        font-size:13pt !important;
        color: {{dark_teal}};
        top:5pt;
      }
      /* Color of input label and slider values */
      .custom-slider {
        color: {{dark_teal}};
        font-size:15pt !important;
      }
      /* Slider bar */
      .custom-slider .irs-bar {
        background: {{teal}};
        border-color: {{teal}};
      }
      /* Circle that slides along bar */
      .custom-slider .irs-handle {
        background: {{yellow}};
        border-color: {{yellow}};
        width: 18px;
        height: 18px;
        top: 20px
      }
      /* The value above the circle that slides along the bar */
      .custom-slider .irs-single {
        background: {{dark_teal}};
        font-size:10pt !important;
      }
      /* Size of value labels below slider bar */
      .custom-slider .irs-grid-text { font-size:10pt; }
      /* The min value located above slider bar */
      .custom-slider .irs-min {
        background: white;
        color: white;
        font-size:10pt;
      }
      /* The max value located above slider bar*/
      .custom-slider .irs-max {
        background: white;
        color: white;
        font-size:10pt;
      }
      ",
      .open = "{{",
      .close = "}}"
)


# ui ----------------------------------------------------------------------

ui <- fluidPage(
  tags$style(type = "text/css", custom_slider_css),
  tags$div(class = "custom-slider", sliderInput(
    "slider",
    "Season",
    value = 0,
    min = 0,
    max = 8,
    step = 1,
    animate = animationOptions(loop = TRUE)
  )),
  plotOutput("plot", width = "75%", height = "550px")
)


# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  output$plot <- renderPlot({
    
    tbl <- ratings_csv |> 
      group_by(season) |> 
      count(rating)
    
    if (input$slider !=0) {
      tbl <- tbl |> filter(season == input$slider)
    }
    
    tbl <- tbl |> 
      mutate(season = season |> as_factor() %>% str_c("Season ", .)) |> 
      ggplot(aes(rating, n)) + 
      # geom_col() +
      scale_x_continuous(breaks = seq(0, 10, 1)) +
      scale_y_continuous(expand = expansion(c(0, 0.05))) +
      labs(x = "Rating", y = "Number of Episodes") +
      gg_theme +
      coord_cartesian(xlim = c(0, 10), ylim = c(0, 20))
    
    if (input$slider == 0) {
      tbl +
        geom_col(aes(fill = season)) +
        scale_fill_viridis_d(guide = guide_legend(position = "top")) +
        labs(fill = NULL)
    } else {
      tbl + geom_col(fill = viridisLite::viridis(8)[input$slider])
    }
    
  })
  
  
  
}

shinyApp(ui, server)
