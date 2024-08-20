# ---- UI function ----
barchartUI <- function(id) {
  ns <- NS(id)  # Namespace for module
  
  # Define the UI elements
  tagList(
    # Dropdown menu to select the variable
    selectInput(ns("variable"), 
                label = "Select Variable", 
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
                selected = "Adult overweight obese"), # Default selected value
    
    # Plot output for the bar chart
    plotOutput(ns("barchart")),
    
    # Button to show the help modal
    actionButton(ns("help"), label = "Show Help")
  )
}

barchartServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Load the data
    load("data/hl_composite_score.rda")
    
    output$barchart <- renderPlot({
      # Calculate the mean of the selected variable
      mean_value <- mean(hl_composite_score[[input$variable]], na.rm = TRUE)
      
      # Create the bar chart with ggplot2
      ggplot(hl_composite_score, aes(x = ltla21_name, y = .data[[input$variable]])) +
        geom_bar(stat = "identity", fill = "lightblue", color = "black") +
        theme_minimal() +
        labs(title = "Health score barchart by indicator", 
             x = "Area", 
             y = input$variable) +
        theme(axis.text = element_text(size = 12), 
              axis.title = element_text(size = 14), 
              plot.title = element_text(size = 16, face = "bold")) +
        coord_flip() +
        scale_y_continuous(limits = c(0, 130), breaks = seq(0, 130, by = 10),
                           labels = function(x) {
                             # Replace y value 100 with "100\nWelsh Average"
                             ifelse(x == 100, "100\nWelsh Average", as.character(x))
                           }) +  # Custom y-axis labels
        geom_hline(yintercept = 100, linetype = "dashed", size = 1) +  # Thicker dashed line at y = 100
        
        # Add annotations for "Worse than mean" and "Better than mean"
        annotate("text", x = -Inf, y = mean_value, label = "Better than mean", hjust = -0.2, vjust = -39, size = 4) +
        annotate("text", x = -Inf, y = mean_value, label = "Worse than mean", hjust = 1.1, vjust = -39, size = 4)
    })
    
    # Descriptions for variables
    descriptions <- list(
      `Alcohol misuse` = "Age standardised alcohol-specific death rate per 100,000.",
      `Breast Cancer Screening` = "Percentage of eligible women screened for breast cancer.",
      `Bowel Cancer Screening` = "Percentage of adults (aged 58-74) who attended bowel cancer screening within six months of invitation.",
      `Cervical Cancer Screening` = "Percentage of women (aged 25-64) who received an adequate cervical cancer screening.",
      `Diphteria vaccination` = "Percentage of children immunised against Diphteria by their second birthday.",
      `Drug misuse` = "Drug poisoning related deaths per 1,000 people.",
      `Early years development` = "Percentage of 7-year-olds achieving expected level in all four areas of foundation phase tests.",
      `Education employment apprenticeship` = "Post-16 Education and Training participation rate for under 20 year olds.",
      `Healthy eating` = "Percentage of adults (16+) eating >5 portions of fruit and vegetables the previous day.",
      `Hib vaccination` = "Percentage of children immunised against Hib by their second birthday.",
      `MMR vaccination` = "Percentage of children immunised against MMR by their second birthday.",
      `Polio vaccination` = "Percentage of children immunised against polio by their second birthday.",
      `Literacy score` = "Average GCSE English Language score.",
      `Numeracy score` = "Average GCSE Mathematics score.",
      `Reception overweight obese` = "Percentage of overweight and obese children aged 4-5.",
      `Teenage pregnancy` = "Percentage of conceptions for women aged 15-17.",
      `Tetanus vaccination` = "Percentage of children immunised against tetanus by their second birthday.",
      `Whooping cough vaccination` = "Percentage of children who received the whooping cough vaccine."
    )
    
    # Render the description modal on button click
    observeEvent(input$help, {
      # Retrieve description based on selected variable
      description_text <- descriptions[[input$variable]]
      showModal(modalDialog(
        title = "Help",
        easyClose = TRUE,
        footer = NULL,
        HTML(paste0("
          <ul>
            <li>This chart displays health index scores for various local authorities in Wales. </li>
            <li>Use the dropdown menu to select a variable to highlight its position on the plot. The chart will update accordingly to show the selected variable's scores.</li>
            <li>Health index scores are calculated by adding the z scores for healthy lives indicators for each LTLA.</li>
            <li>For more information on how the score was created, see the health index methods button at the top of the page.</li>
            <li><strong>Description for ", input$variable, ":</strong> ", description_text, "</li>
          </ul>
        "))
      ))
    })
  })
}
