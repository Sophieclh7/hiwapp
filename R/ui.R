source("R/barchart.R")
source("R/jitterplot.R")

ui <- fluidPage(
  h1("Interactive Health Data Dashboard"),
  compJitterUI("compJitterModule"),
  boxplotUI("boxplotModule"),
  barchartUI("barchartModule")
)