source("R/barchart.R")
source("R/jitterplot.R")

ui <- fluidPage(
  # Headings and introduction
  h1("Interactive Health Data Dashboard"),
  
  # Include the jitter plot UI
  compJitterUI("compJitterModule"),  # Assuming you have a jitter plot module
  
  # Include the bar chart UI
  barchartUI("barchartModule"),
)
