
library(shiny)
library(bslib)
library(gemini.R)
library(usethis)
library(dotenv)

# Define UI for application 
ui <- fluidPage(
  titlePanel("Shiny App to describe an Image "),
  sidebarLayout(
    sidebarPanel (
      fileInput(
        inputId = 'file',
        label = 'Choose file to upload',
        accept = ".jpg, .jpeg, .png"
      ),
      div(
        id = "image-container",
        style = 'border: solid 1px blue max-height: 200px; overflow: auto;',
        imageOutput(outputId = 'image1'),
      )
    ),
    mainPanel(
      textInput(
        inputId = 'prompt',
        label = 'Prompt',
        placeholder = 'Enter Prompts Here'
      ),
      actionButton('goButton', 'Ask Gemini'),
      div(
        style = 'border: solid 1px blue; min-height: 100px;', textOutput('text1')
      )
    )
  )
)

# Define server logic 
server <- function(input, output) {

  # Access the API key from the environment
  api_key <- Sys.getenv("GEMINI_API_KEY")
  
  # Set the API key using your function (assuming it's defined)
  setAPI(api_key)
  
  observeEvent(input$file, {
    path <- input$file$datapath
    output$image1 <- renderImage({
      list( src = path )
    }, deleteFile = FALSE) })
  
  observeEvent(input$goButton, {
    output$text1 <- renderText({
      gemini_image(input$prompt, input$file$datapath)
    })
  })
} 


# Run the application 
shinyApp(ui = ui, server = server)

