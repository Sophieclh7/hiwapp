# ---- UI function ----
barchartUI <- function(id) {
  ns <- NS(id)  # Creates unique input and output IDs
  
  # Define the UI elements
  tagList(
    
    # Button to show the help modal
    actionButton(ns("help"), label = "Help"),
    
    # Dropdown menu to select the indicator
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
    plotOutput(ns("barchart"))
  )
}

# ---- Server function ----
barchartServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Load data
    load("data/hl_composite_score.rda")
    
    # Render bar chart
    output$barchart <- renderPlot({
      
      # Calculate mean of selected indicator
      mean_value <- mean(hl_composite_score[[input$indicator]])
      
      # Create bar chart
      ggplot(hl_composite_score, aes(x = .data[["ltla21_name"]], y = .data[[input$indicator]])) +
        geom_bar(stat = "identity", fill = "lightblue", color = "black") +
        theme_minimal() +
        labs(title = "Indicator Scores by Area", 
             x = "Area", 
             y = input$indicator) +
        theme(axis.text = element_text(size = 12), 
              axis.title = element_text(size = 14), 
              plot.title = element_text(size = 16, face = "bold")) +
        coord_flip() +
        scale_y_continuous(limits = c(0, 130), breaks = seq(0, 130, by = 10),
                           labels = function(x) {
                             # Replaces y = 100 with custom text - 100/nWelsh Average
                             ifelse(x == 100, "100\nWelsh Average", as.character(x))
                           }) + 
        geom_hline(yintercept = 100, linetype = "dashed", size = 1.5) +  # Thicker dashed line at y = 100
        
        # Add annotations for "Worse than mean" and "Better than mean"
        annotate("text", x = -Inf, y = mean_value, label = "Better than mean", hjust = -0.2, vjust = -39, size = 4) +
        annotate("text", x = -Inf, y = mean_value, label = "Worse than mean", hjust = 1.1, vjust = -39, size = 4)
    })
    
    # Render the help button
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
            <li>For more details on how scores are calculated, please refer to Methodology tab.</li>
            <li>For information on what each indicator is measuring, please refer to metadata.</li>
            <br>
            <li>What each indicator measures:</li>
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
