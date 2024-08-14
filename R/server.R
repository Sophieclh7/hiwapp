#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


source("R/jitterplot.R")

server <- function(input, output, session) {
  compJitterServer("compJitterModule")  # Pass the same id here
}