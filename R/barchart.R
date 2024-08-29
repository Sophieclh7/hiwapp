# ---- UI function ----
barchartUI <- function(id) {
  ns <- NS(id)  # Creates unique input and output IDs
  
  # Define the UI elements
  tagList(
    
    # Button to show the help modal
    actionButton(ns("help"), label = "Help"),
    
    # Dropdown menu to select the indcator
    selectInput(ns("indicator"), 
                label = "Select indicator", 
                choices = c("Adult overweight obese",
                            "Alcohol misuse",
                            "Bowel Cancer Screening",
                            "Breast Cancer Screening",
                            "Cervical Cancer Screening",
                            "Drug misuse",
                            "Early years development",
                            "Education employment apprenticeship",
                            "Healthy eating",
                            "Literacy score",
                            "Low birth weight",
                            "MeningitisB vaccination",
                            "MMR vaccination",
                            "Numeracy score",
                            "Physical activity",
                            "Pneumococcal vaccination",
                            "Primary absences",
                            "Reception overweight obese",
                            "Secondary absences",
                            "Sedentary behaviour",
                            "Smoking",
                            "Teenage pregnancy",
                            "6 in 1 vaccination"
                ), 
                selected = "Adult overweight obese"), # Sets as default
    
    # Plot output for the bar chart
    plotlyOutput(ns("barchart"))
  )
}

# ---- Server function ----
barchartServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Load the datasets
    load("data/hl_composite_score.rda")
    load("data/hl_raw_data.rda")
    
    # Create a mapping of indicators to their respective raw count descriptions
    indicator_description <- list(
      "6 in 1 vaccination" = "Percentage immunised with 6 in 1 vaccination by 2nd birthday",
      "Adult overweight obese" = "Percentage adults overweight or obese",
      "Alcohol misuse" = "Alcohol death rate per 100,000",
      "Bowel Cancer Screening" = "Bowel Cancer screening uptake percentage",
      "Breast Cancer Screening" = "Breast Cancer screening uptake percentage",
      "Cervical Cancer Screening" = "Cervical Cancer screening uptake percentage",
      "Drug misuse" = "Drug poisoning death rate per 1,000",
      "Early years development" = "Percent pupils achieving expected level across four foundation phase tested areas",
      "Education employment apprenticeship" = "Participation rate post 16 under 20 in education/employment/apprenticeship",
      "Healthy eating" = "Percent adults who ate five fruit/veg the previous day",
      "Literacy score" = "Average literacy GCSE score",
      "Low birth weight" = "Percentage of live births under <2500g",
      "MeningitisB vaccination" = "MeningitisB vaccination",
      "MMR vaccination" = "Percentage immunised with MMR vaccination by 2nd birthday",
      "Numeracy score" = "Average numeracy GCSE score",
      "Physical activity" = "Percent adults active at least 150 minutes the previous week",
      "Pneumococcal vaccination" = "Percentage immunised with pneumococcal vaccination by 2nd birthday",
      "Primary absences" = "Percentage of primary school absences",
      "Reception overweight obese" = "Percentage children aged 4-5 overweight or obese",
      "Secondary absences" = "Percentage of secondary school absences",
      "Sedentary behaviour" = "Percent adults active less than 30 minutes the previous week",
      "Smoking" = "Percentage smokers",
      "Teenage pregnancy" = "Percentage teenage pregnancies"
    )
    
    # Render the bar chart as a plotly object
    output$barchart <- renderPlotly({
      # Combine the datasets for easier access
      combined_data <- hl_composite_score |>
        mutate(
          raw_count = round(hl_raw_data[[input$indicator]] ,2),  # Round the raw count
          adjusted_score = round(.data[[input$indicator]] - 100),  # Adjust and round the score
          text = paste(
            "Area:", ltla21_name,
            "<br>Indicator Score:", round(.data[[input$indicator]]),  # Round the composite score
            "<br>", indicator_description[[input$indicator]], ":", raw_count  # Use rounded raw count
          )
        )
      
      # Create the bar chart with ggplot2
      p <- ggplot(combined_data, aes(x = ltla21_name, y = adjusted_score, text = text)) +
        geom_bar(stat = "identity", fill = "lightblue", color = "black") +
        theme_minimal() +
        labs(title = "Indicator Scores by Area", 
             x = "Area", 
             y = input$indicator) +
        theme(axis.text = element_text(size = 8), 
              axis.title = element_text(size = 14), 
              plot.title = element_text(size = 16, face = "bold")) +
        coord_flip() +
        scale_y_continuous(limits = c(-25, 25), breaks = seq(-25, 25, by = 5),
                           labels = function(x) {
                             ifelse(x == 0, "100\nWelsh Average", as.character(x + 100))
                           }) + 
        geom_hline(yintercept = 0, linetype = "dashed", linewidth = 1)
      
      # Convert ggplot to plotly object for interactivity
      ggplotly(p, tooltip = "text") |>
        layout(
          annotations = list(
            list(
              x = 0.6, 
              y = 1.07,  
              text = "Better Than Average", 
              showarrow = FALSE, 
              xref = "paper", 
              yref = "paper", 
              font = list(size = 12)
            ),
            list(
              x = 0.4, 
              y = 1.07,  
              text = "Worse Than Average", 
              showarrow = FALSE, 
              xref = "paper",
              yref = "paper",
              font = list(size = 12)
            )
          )
        ) |>
        config(toImageButtonOptions = list(format = "png"))
    })
    
    # Render the description modal on button click
    observeEvent(input$help, {
      # Retrieve description based on selected indicator
      showModal(modalDialog(
        title = "Help",
        easyClose = TRUE,
        footer = NULL,
        HTML(paste0("
          <ul>
            <li>This chart displays indicator scores for each area.</li>
            <li>Use the dropdown menu to select an indicator. The chart will update to show the scores for each area for that indicator.</li>
            <li>Hover over the bars to see the area name, indicator score, and what the indicator is measuring.</li>
            <li>For more details on how scores are calculated, please refer to Methodology tab.</li>
            <li>For information on what each indicator is measuring, please refer to metadata.</li>
            <br>
            <b>What each indicator measures:</b>
            <li>6 in 1 vaccination = Percentage of children immunised with 6 in 1 vaccination (Diptheria, Tetanus, Polio, Whooping Cough etc) by their second birthday</li>
            <li>Adult Overweight Obese = Percentage of overweight and obese adults (16+) in Wales</li>
            <li>Alcohol misuse = Age standardised alcohol-specific death rate per 100,000</li>
            <li>Bowel Cancer Screening = Percentage of adults (aged 58-74) who attended bowel cancer screening within six months of invitation</li>
            <li>Breast Cancer Screening = Percentage of eligible women screened for breast cancer</li>
            <li>Cervical Cancer Screening = Percentage of women (aged 25-64) who received an adequate cervical cancer screening</li>
            <li>Drug misuse = Drug poisoning related deaths per 1,000 people</li>
            <li>Early years development = Percentage of 7-year-olds achieving expected level in all four areas of foundation phase tests</li>
            <li>Education employment apprenticeship = Post-16 Education and Training participation rate for under 20 year olds</li>
            <li>Healthy eating = Percentage of adults (16+) eating >5 portions of fruit and vegetables the previous day</li>
            <li>Literacy score = Average GCSE English Language score</li>
            <li>Low Birth Weight = Percentage of live births under <2500g</li>
            <li>MMR vaccination = Percentage of children immunised against MMR by their second birthday</li>
            <li>Meningjitis B vaccination = Percentage of children immunised against MeningjitisB by their second birthday</li>
            <li>Numeracy score = Average GCSE Mathematics score</li>
            <li>Physical Activity = Percentage of adults active at least 150 minutes a week</li>
            <li>Pneumococcal vaccination = Percentage of children immunised against pneumococcal disease by their second birthday</li>
            <li>Primary Absences = Percentage of primary school student absences</li>
            <li>Reception overweight obese = Percentage of overweight and obese children aged 4-5</li>
            <li>Secondary Absences = Percentage of Secondary School Student Absences</li>
            <li>Sedentary Behaviour = Percentage of adults who are active < 30 minutes a week</li>
            <li>Smoking = Percentage of Smokers</li>
            <li>Teenage pregnancy = Percentage of conceptions for women aged 15-17</li>
          </ul>
        "))
      ))
    })
  })
}
