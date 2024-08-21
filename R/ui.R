ui <- fluidPage(
  titlePanel("Health Inequalities Explorer Wales"),
  
  mainPanel(
    tabsetPanel(
      tabPanel(
        "Introduction",
        h1("Welcome to the Health Inequalities Explorer Wales", 
           style = "text-align: center; border-bottom: 2px solid #000; padding-bottom: 10px;"),
        h2("Overview", style = "font-size: 20px;"),
        p("This application allows users to explore and compare health data across different local authority areas in Wales. This app uses the data from the 'Healthy Lives' domain of the Health Index Wales. 'Healthy Lives' consists of the subdomains 'Behavioural Risk Factors', 'Children and Young People', 'Physiological Risk Factors', and 'Protective Measures'. These subdomains each contain a group of health indicators."),
        p(" Navigate through the tabs to view the healthy lives score, scores for each subdomain and scores for each indicator."),
       
        img(src = "Flow_chart.png", height = "500px", style = "display: block; margin-left: auto; margin-right: auto;"),
        p("The chart above shows how the Health Index Wales consists of Domains - this app only includes data for the Healthy Lives domain. The domains consist of subdomains, which each consist of a group of indicators."),
        p("For information on what each indicator is measuring, please refer to the metadata: ", 
          a("Metadata", href = "https://github.com/humaniverse/health-index-wales/blob/main/metadata.md"),
          p("For information on how scores were created, please refer to the methodology tab"))
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
      ),
      tabPanel(
        "Methodology",
        methodologyUI("methodology")
)
      
    )
  )
)
  

