#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

ui <- shinyUI(fluidPage(
  titlePanel("Jitter Plot Example"),
  
  sidebarLayout(
    sidebarPanel(
      # Add input controls here if needed
    ),
    
    mainPanel(
      plotOutput("jitterPlot")  # This is where the plot will be rendered
    )
  )
))
