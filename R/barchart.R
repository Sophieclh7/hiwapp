# ---- user interface ----
barchartUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("variable"), "Choose a variable:", 
                choices = c("Alcohol_misuse", "Bowel_Cancer_Screening", "Breast_Cancer_Screening", 
                            "Cervical_Cancer_Screening", "Diptheria_vaccination", "Drug_misuse", 
                            "Early_years_development", "Education_employment_apprenticeship", 
                            "Healthy_eating", "Hib_vaccination", "Low_birth_weight", 
                            "MeningitisB_vaccination", "MMR_vaccination", "Physical_activity", 
                            "Pneumococcal_vaccination", "Polio_vaccination", "Primary_absences", 
                            "Literacy_score", "Numeracy_score", "Reception_overweight_obese", 
                            "Secondary_absences", "Sedentary_behaviour", "Smoking", 
                            "Teenage_pregnancy", "Tetanus_vaccination", "Whooping_cough_vaccination")),
    plotOutput(ns("barchart")),
    textOutput(ns("description"))
  )
}

# ---- server function ----
barchartServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$barchart <- renderPlot({
      load("data/hl_raw_data.rda")
      ggplot(hl_raw_data, aes_string(x = "ltla21_name", y = input$variable)) +
        geom_bar(stat = "identity", fill = "steelblue", color = "black") +
        theme_minimal() +
        labs(title = paste(input$variable, "by County"), 
             x = "County", 
             y = input$variable) +
        theme(axis.text = element_text(size = 12), 
              axis.title = element_text(size = 14), 
              plot.title = element_text(size = 16, face = "bold")) +
        coord_flip()
    })
    
    output$description <- renderText({
      descriptions <- list(
        Alcohol_misuse = "Age standardised alcohol-specific death rate per 100,000.",
        Breast_Cancer_Screening = "Percentage of eligible women screened for breast cancer.",
        Bowel_Cancer_Screening = "Percentage of adults (aged 58-74) who attended bowel cancer screening within six months of invitation.",
        Cervical_Cancer_Screening = "Percentage of women (aged 25-64) who received an adequate cervical cancer screening.",
        Diptheria_vaccination = "Percentage of children immunised against diphtheria by their second birthday.",
        Drug_misuse = "Drug poisoning related deaths per 1,000 people",
        Early_years_development = "Percentage of 7-year-olds achieving expected level in all four areas of foundation phase tests.",
        Education_employment_apprenticeship = "Post-16 Education and Training participation rate for under 20 year olds.",
        Healthy_eating = "Percentage of adults (16+) eating >5 portions of fruit and vegetables the previous day.",
        Hib_vaccination = "Percentage of children immunised against Hib by their second birthday.",
        MMR_vaccination = "Percentage of children immunised against MMR by their second birthday.",
        Polio_vaccination = "Percentage of children immunised against polio by their second birthday.",
        Literacy_score = "Average GCSE English Language score.",
        Numeracy_score = "Average GCSE Mathematics score.",
        Reception_overweight_obese = "Percentage of overweight and obese children aged 4-5.",
        Teenage_pregnancy = "Percentage of conceptions for women aged 15-17.",
        Tetanus_vaccination = "Percentage of children immunised against tetanus by their second birthday.",
        Whooping_cough_vaccination = "Percentage of children who received the whooping cough vaccine."
      )
      descriptions[[input$variable]]
    })
  })
}