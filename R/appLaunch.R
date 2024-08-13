library(tidyverse)
library(shiny)

appLaunch <- function() {
  shinyApp(ui, server)
}