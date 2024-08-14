ui <- fluidPage(
  h1("Interactive Health Data Dashboard"),
  compJitterUI("compJitterModule"),
  boxplotUI("boxplotModule"),
  compositechartUI("compositechartModule"),
  barchartUI("barchartModule")
)