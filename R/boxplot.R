#UI function for the compJitter module
boxplotUI <- function(id) {
  ns <- NS(id)
  plotlyOutput(ns("boxplot"))
}