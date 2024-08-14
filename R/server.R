source("R/barchart.R")
source("R/jitterplot.R")

server <- function(input, output, session) {
  compJitterServer("compJitterModule")  # Pass the correct ID here
  barchartServer("barchartModule")  # Pass the correct ID here
  
}
