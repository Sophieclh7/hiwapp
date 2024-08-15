ui <- fluidPage(
  h1("Health inequalities explorer Wales", style = "text-align: center; ; border-bottom: 2px solid #000; padding-bottom: 10px;"),
  compJitterUI("compJitterModule"),
  boxplotUI("boxplotModule"),
  compositechartUI("compositechartModule"),
  barchartUI("barchartModule")
)