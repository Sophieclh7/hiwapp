library(tidyverse)
library(shiny)
library(shinyBS)
library(plotly)
library(ggplot2)
library(gridlayout)
library(shinyjs)

appLaunch <- function() {
  shinyApp(ui, server)
}

