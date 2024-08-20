server <- function(input, output, session) {
  compJitterServer("compJitterModule")
  boxplotServer("boxplotModule")
  compositechartServer("compositechartModule")
  barchartServer("barchartModule")
  glossaryServer("glossaryModule")
}