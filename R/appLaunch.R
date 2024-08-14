library(tidyverse)
library(shiny)
library(shinyBS)
library(plotly)
library(ggplot2)

appLaunch <- function() {
  shinyApp(ui, server)
}