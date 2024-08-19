ui <- fluidPage(
  titlePanel("Health Inequalities Explorer Wales"),
  
  mainPanel(
    tabsetPanel(
      tabPanel(
        "Introduction",
        h1("Welcome to the Health Inequalities Explorer Wales", 
           style = "text-align: center; border-bottom: 2px solid #000; padding-bottom: 10px;"),
        h2("Overview", style = "font-size: 20px;"),
        p("This application allows users to explore and compare health data across different local authorities in Wales. Navigate through the tabs to view indicator and subdomain scores."),
        p("For detailed explanations and methods used, please refer to the glossary tab.")
      ),
      tabPanel(
        "Health Index Score",
        h2("Health Index Score"),
        compJitterUI("compJitterModule") 
      ),
      tabPanel(
        "Subdomain Scores",
        h2("Subdomain Scores"),
        h3("This tab contains visualizations related to subdomain scores."),
        boxplotUI("boxplotModule"),  
        compositechartUI("compositechartModule") 
      ),
      tabPanel(
        "Indicator Scores",
        h2("Indicator Scores"),
        h3("The chart displays the composite score for each indicator.", style = "font-size: 16px;"),
        barchartUI("barchartModule")  
      ),
      tabPanel(
        "Glossary",
        h2("Glossary"),
        h3("Terms and Definitions"),
        p("Here you can find definitions and explanations for various terms used in the application. This section will help you better understand the data and metrics presented."),
        glossaryUI("glossary") 
      )
    )
  )
)
