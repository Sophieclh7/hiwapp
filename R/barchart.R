library(shiny)
library(ggplot2)
library(shinyBS)  # For the tooltip and modal dialog

# ---- user interface ----
barchartUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Help button with a question mark icon
    actionButton(ns("help"), label = NULL, icon = icon("question-circle")),
    
    # The modal dialog that appears when the help button is clicked
    bsModal(ns("helpModal"), "Indicator Descriptions", trigger = ns("help"), size = "large",
            p("Alcohol_misuse: Measures the rate of alcohol-related hospital admissions."),
            p("Bowel_Cancer_Screening: Percentage of eligible individuals screened for bowel cancer."),
            p("Breast_Cancer_Screening: Percentage of eligible women screened for breast cancer."),
            # Add descriptions for all other indicators here...
            p("Whooping_cough_vaccination: Percentage of children who received the whooping cough vaccine.")
    ),
    
    # The variable selection input
    selectInput(ns("variable"), "Choose a variable to display:",
                choices = c("Alcohol_misuse",                     
                            "Bowel_Cancer_Screening",             
                            "Breast_Cancer_Screening",            
                            "Cervical_Cancer_Screening",          
                            "Diphteria_vaccination",              
                            "Drug_misuse",                        
                            "Early_years_development",            
                            "Education_employment_apprenticeship",
                            "Healthy_eating",                     
                            "Hib_vaccination",                    
                            "Low_birth_weight",                   
                            "MeningitisB_vaccination",            
                            "MMR_vaccination",                    
                            "Physical_activity",                  
                            "Pneumococcal_vaccination",           
                            "Polio_vaccination",                  
                            "Primary_absences",                   
                            "Literacy_score",                     
                            "Numeracy_score",                     
                            "Reception_overweight_obese",         
                            "Secondary_absences",                 
                            "Sedentary_behaviour",                
                            "Smoking",                            
                            "Teenage_pregnancy",                  
                            "Tetanus_vaccination",                
                            "Whooping_cough_vaccination")),  # List of column names
    
    # The bar chart output
    plotOutput(ns("barchart")),
    
    # Text output for indicator explanation
    textOutput(ns("description"))
  )
}

# ---- server function ----
barchartServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Bar chart rendering
    output$barchart <- renderPlot({
      # Load the R data file
      load("data/hl_raw_data.rda")
      
      # Create a bar chart with the selected variable
      bar_chart <- ggplot(hl_raw_data, aes_string(x = "ltla21_name", y = input$variable)) +  # Use aes_string for dynamic variables
        geom_bar(stat = "identity", fill = "steelblue", color = "black") +
        theme_minimal() +
        labs(title = paste("Bar Chart of", input$variable, "by County"), 
             x = "County", y = input$variable) +
        theme(axis.text.x = element_text(size = 12), # Increase size of x-axis text
              axis.text.y = element_text(size = 12), # Increase size of y-axis text
              axis.title.x = element_text(size = 14), # Increase size of x-axis title
              axis.title.y = element_text(size = 14), # Increase size of y-axis title
              plot.title = element_text(size = 16, face = "bold")) + # Increase size of the title
        coord_flip()  # Flip coordinates for landscape orientation
      
      # Display the bar chart
      print(bar_chart)
    })
    
    # Text output for indicator description
    output$description <- renderText({
      descriptions <- list(
        "Adult-overweight_obese" = "The percentage of overweight and obese adults in each local authority of Wales.",
        "Alcohol_misuse" = "Age standardised alcohol-specific death rate per 100,000.",
        "Breast_Cancer_Screening" = "Percentage of eligible women screened for breast cancer.",
        "Bowel_Cancer_Screening" = "Percentage of adults out of those invited to attend bowel cancer screening (aged 58-74) who attended their screening. Participants were deemed to have responded to their invitation if the bowel screening programme received a used test kit within six months following their invitation.",
        "Cervical_Cancer_Screening" = "Percentage of adults out of those invited to attend cervical cancer screening (aged 25-64) who attended their screening. Women were counted as having responded if they are aged 25-49 years who have received an adequate test in the last 3.5 years and if they are aged 50-64 years who received an adequate test in the last 5.5 years.",
        "Diptheria_vaccination" = "Percentage of children immunised against diphtheria reaching their second birthday in the year",
        "Drug_misuse" = "Drug poisoning related deaths per 1,000 people",
        "Early_years_development" = "Percentage of foundation phase students, aged 7, who achieve the expected level, level 5, in all four areas of the foundation phase tests per local authority. The four areas are 1) Personal and social development, well-being and cultural diversity, 2) Language, literacy and communication skills - English, 3) Language, literacy and communication skills - Welsh, 4) Mathematical development",
        "Education_employment_apprenticeship" = "Participation rate in post-16 (after Key Stage 4) Education and Training in Wales for under 20 year olds. Participation rate is calculated using census data population count by local authority, with participation measured against the Welsh national average of 100. Participation rates above 100 reflect high participation rates, below 100 low participation rates",
        "Healthy_eating" = "Percentage of adults (aged 16+) who claim to have eaten >5 portions of fruit and vegetables the previous day, (age standardised)",
        "Hib_vaccination" = "Percentage of children immunised against haemophilus influenzae type B reaching their second birthday in the year",
        "MMR-vaccination" = "Percentage of children immunised against Measles, Mumps and Rubella (MMR) reaching their second birthday in the year",
        "Polio_vaccination
        
        
        
        
        
        
        
        "Whooping_cough_vaccination" = "Percentage of children who received the whooping cough vaccine."
        
      )
      descriptions[[input$variable]]
    })
  })
}

# ---- main app ----
ui <- fluidPage(
  barchartUI("barchart1")
)

server <- function(input, output, session) {
  barchartServer("barchart1")
}

shinyApp(ui, server)
