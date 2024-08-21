ui <- fluidPage(
  titlePanel("Health Inequalities Explorer Wales"),
  
  mainPanel(
    tabsetPanel(
      tabPanel(
        "Introduction",
        h1("Welcome to the Health Inequalities Explorer Wales", 
           style = "text-align: center; border-bottom: 2px solid #000; padding-bottom: 10px;"),
        h2("Overview", style = "font-size: 20px;"),
        p("This application allows users to explore and compare health data across different local authorities in Wales. Navigate through the tabs to view indicator and subdomain scores. This app uses the data from the 'Healthy Lives' domain of the Health Index. 'Healthy Lives' consists of 'Behavioural Risk Factors', 'Children and Young People', 'Physiological Risk Factors', and 'Protective Measures'. These subdomains contain their own respective indicators."  ),
        p("For detailed explanations, methods used, and additional information, please refer to the metadata available at ", 
          a("this link", href = "https://github.com/humaniverse/health-index-wales/blob/main/metadata.md")),
        img(src = "Flow_chart.png", height = "500px", style = "display: block; margin-left: auto; margin-right: auto;"),
        p("The chart above shows how the Health Index Wales is broken down into Domains, which are then broken down into Subdomains, which are then broken down into Indicators.", style = "text-align: center;")
      ),
      tabPanel(
        "Healthy Lives Score",
        h2("Healthy Lives Score - Jitter Plot"),
        p("This visualises Health Index Scores for the Local Authorities in Wales. The jitter plot displays these scores where each LTLA is represented as a point on the plot."),
        compJitterUI("compJitterModule") 
      ),
      tabPanel(
        "Subdomain Scores",
        h2("Subdomain Scores"),
        h3("There are 4 subdomains within the 'Healthy Lives Domain': 'Behavioural Risk Factors', 'Children and Young People', 'Physiological Risk Factors', and 'Protective Measures'."),
        boxplotUI("boxplotModule"),  
        compositechartUI("compositechartModule") 
      ),
      tabPanel(
        "Indicator Scores",
        h2("Indicator Scores"),
        h3("The chart displays the composite score for each indicator by region.", style = "font-size: 16px;"),
        barchartUI("barchartModule")  
      ),
      tabPanel(
        "Glossary",
        h2("Glossary"),
        h3("Terms and Definitions"),
        p("Here you can find definitions and explanations for various terms used in the application. This section will help you better understand the data and metrics presented."),
        glossaryUI("glossary") 
      ),
      tabPanel(
        "Future Developments",
        h2("Future Developments"),
        p("This section will outline potential future improvements and features for the Healthy Lives Web Application.")
      )
     
      )
    )
  )