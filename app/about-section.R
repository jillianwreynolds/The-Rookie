about_section <- htmltools::tagList(
  tags$summary("About This Project", style = "display: list-item; font-size:20px"),
  p(
    em("The Rookie"), "has 144 episodes. For each, fans have written transcripts on ", tags$a(href="https://the-rookie.fandom.com/", "the-rookie.fandom.com", .noWS = "after"), ". The goals of this project are to use an interest of mine to practice and improve my skills for working with text data and to create a Shiny web app. I have also been learning about html and, through the use of shinylive to create this Shiny application, the basics of web development.",
    style = "font-size:16px"
  ),
  p(
    "Each episode transcript has a webpage. I downloaded each webpage as an html file. To turn the html source text into useable text, I used xml2 and rvest. I also used pdftools to read the text from Safari Reader pdf files of the transcripts. Extraction of the season, episode, and title for each transcript came early on in my data cleaning process, resulting in a rather inelegant stringr regular expressions, such as ", code("\"(?<=THE\\\\sROOKIE\\\\n(Season|SEASON)\\\\s)\\\\d+\"", .noWS = "after"), ".",
    style = "font-size:16px"
  ),
  p(
    "After I finish cleaning the data, I will use packages like tidytext to convert the data into rows and columns such that each column is a variable and each word has a row. Splitting the transcripts into lines of scene headings, descriptions, and dialogue creates tens of thousands of rows; splitting transcripts by word would create an even larger data set. This takes up a lot of memory on the computer, so I use parquet files and arrow to minimize memory usage and speed up data storage and processing.",
    style = "font-size:16px"
  )
)
