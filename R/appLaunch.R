library(tidyverse)
library(shiny)
library(shinyBS)
library(ggplot2)

appLaunch <- function() {
  shinyApp(ui, server)
}