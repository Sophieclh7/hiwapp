source("R/barchart.R")
source("R/jitterplot.R")

server <- function(input, output, session) {
  compJitterServer("compJitterModule")
  boxplotServer("boxplotModule")
  barchartServer("barchartModule")
}