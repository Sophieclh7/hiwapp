library(tidyverse)
library(shiny)
library(plotly)
library(ggplot2)

appLaunch <- function() {
  shinyApp(ui, server)
}