library(shiny)
library(shinymaterial)
library(dplyr)

# define prediction function
predict_genre <- function(artist, title) {
  base_url <- "https://colorado.rstudio.com/rsc/genre-pred/track"
  
  res <- httr::GET(base_url, 
                   query = list(artist = artist, title = title), 
                   encode = "json")

  res %>%
    httr::content("text") %>%
    jsonlite::fromJSON()
}

# 
ui <- material_page(
  title = "Hip-hop or Country?",
  nav_bar_color = "black",
  background_color = '#828282',


  div(style = "height:50px;"),
  
  material_row(
    material_column(width=4),

    
    material_column(width = 5,
                    material_card(
                      title = '',
                      depth = 4,
                      material_text_box('artist', "Artist Name", color = 'black'),
                      material_text_box("song_title", "Song Title", color = "black"),
                      actionButton("submit", label = "Submit"),
                      uiOutput('select_artist_ui')
                    )),
    material_column(width=4)
  ),
  
  material_row(
    material_column(width = 4),
    material_column(width = 5,
      material_card(
        dataTableOutput("predictions")
      )
    ),
    material_column(width = 4)
  )
  
)

server <- function(input, output) {
  
  observeEvent(input$submit, {
    
    preds <- predict_genre(input$artist, input$song_title)
    
    output$predictions <- renderDataTable({
      
      rename_all(preds, stringr::str_remove, ".pred_")
      })
    
  })
  
}
shinyApp(ui = ui, server = server)
