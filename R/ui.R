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
        h2("Healthy Lives Score - Jitter Plot", style = "font-size: 20px; font-weight: bold;"),
        p("The jitter plot displays the Healthy Lives Scores by area in Wales which is represented as a dot on the plot.", style = "font-size: 16px;"),
        compJitterUI("compJitterModule") 
      ),
      tabPanel(
        "Subdomain Scores",
        h2("Subdomain Scores", style = "font-size: 20px; font-weight: bold;"),
        h3("There are 4 subdomains within 'Healthy Lives': 'Behavioural Risk Factors', 'Children and Young People', 'Physiological Risk Factors', and 'Protective Measures'.", style = "font-size: 16px;"),
        boxplotUI("boxplotModule"),  
        compositechartUI("compositechartModule") 
      ),
      tabPanel(
        "Indicator Scores",
        h2("Indicator Scores", style = "font-size: 20px; font-weight: bold;"),
        h3("This bar chart displays the scores for each indicator, select an indicator from the drop down menu to see its standardized score for each area.", style = "font-size: 16px;"),
        barchartUI("barchartModule")  
      ),
      tabPanel(
        "Glossary",
        glossaryUI("glossary") 
      ),
      tabPanel(
        "Future Developments",
        h2("Future Developments"),
        p("This section will outline potential future improvements and features for the Healthy Lives Web Application."),
        p("We would like to render the barchart and the subdomain score chart as plotly objects so they can be downloaded and when you hover over bars on barchart it will display composite score and raw score"),
        p("We'd like to shorten the range of the x axis on the barchart but couldn't find a way to do so"),
        p("Possibly get rid of the median line on boxplot - it looks confusing because there is also Welsh average line"),
        p("Make sure metadata link in methodology tab works on Mac processors"),
        p("Make sure text is all same size on subdomains tab")
      ),
      tabPanel(
        "Methodology",
        methodologyUI("methodology")
)
      
    )
  )
)
  

