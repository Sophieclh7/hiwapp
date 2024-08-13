library(tidyverse)
library(shiny)
library(ggplot2)

appLaunch <- function() {
  shinyApp(ui, server)
}