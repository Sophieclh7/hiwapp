#UI function for the compJitter module
compJitterUI <- function(id) {
  ns <- NS(id)
  tagList(
    shinyjs::useShinyjs(),  # Ensure shinyjs is included
    actionLink(ns("toggle_method_info"), "Health Index Method ↓"),
    div(id = ns("method_info"), style = "display: none;",  # Ensure it's hidden by default
        p("The health index score is calculated by adding the z scores for healthy lives indicators for each LTLA."),
        p("Z-scores are standardized scores that indicate how many standard deviations an element is from the mean of the data. This standardization enables the comparison of data on different scales."),
        p("The indicators are:"),
        p("Alcohol_misuse - Age standardised alcohol-specific death rate per 100,000."),
        p("Breast_Cancer_Screening  - Percentage of eligible women screened for breast cancer."),
        p("Bowel_Cancer_Screening - Percentage of adults (aged 58-74) who attended bowel cancer screening within six months of invitation."),
        p("Cervical_Cancer_Screening - Percentage of women (aged 25-64) who received an adequate cervical cancer screening."),
        p("Diphteria_vaccination - Percentage of children immunised against Diphteria by their second birthday."),
        p("Drug_misuse - Drug poisoning related deaths per 1,000 people."),
        p("Early_years_development - Percentage of 7-year-olds achieving expected level in all four areas of foundation phase tests."),
        p("Education_employment_apprenticeship  - Post-16 Education and Training participation rate for under 20 year olds."),
        p("Healthy_eating - Percentage of adults (16+) eating >5 portions of fruit and vegetables the previous day."),
        p("Hib_vaccination - Percentage of children immunised against Hib by their second birthday."),
        p("MMR_vaccination - Percentage of children immunised against MMR by their second birthday."),
        p("Polio_vaccination - Percentage of children immunised against polio by their second birthday."),
        p("Literacy_score - Average GCSE English Language score."),
        p("Numeracy_score - Average GCSE Mathematics score."),
        p("Reception_overweight_obese - Percentage of overweight and obese children aged 4-5."),
        p("Teenage_pregnancy - Percentage of conceptions for women aged 15-17."),
        p("Tetanus_vaccination - Percentage of children immunised against tetanus by their second birthday."),
        p("Whooping_cough_vaccination - Percentage of children who received the whooping cough vaccine."),
    ),
    selectInput(ns("ltla_select"), "Select area:", choices = NULL),
    actionButton(ns("help_button"), "Help"),
    plotlyOutput(ns("compJitter")),
    br()  # Adds a line break
  )
}

#Server function for the compJitter module
compJitterServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    #Load data
    hl_data <- get(load("data/hl_composite_score.rda"))
    
    #Update ltla dropdown choices
    updateSelectInput(session, "ltla_select", choices = hl_data$ltla21_name)
    
    output$compJitter <- renderPlotly({
    
      #Add a random y-axis value for each point
      set.seed(123)  # for reproducibility
      hl_data$random_y <- runif(nrow(hl_data), min = -1, max = 1)
      
      #Calculate the mean of the Composite score
      mean_composite_score <- mean(hl_data$`Composite score`)
      
      #Set limits of x axis to maximum composite score
      x_max <- max(abs(hl_data$`Composite score`))
      
      #Define points to include vertical grid lines
      additional_lines <- c(-25, -20, -15, -10, -5, 5, 10, 15, 20, 25)
      labels <- as.character(c(additional_lines, 0))  #Include 0 in labels, not included in additional_lines as want to make line darke
      
      #Highlight the selected LTLA
      hl_data$highlight <- ifelse(hl_data$ltla21_name == input$ltla_select, "Selected", "Not Selected")
      
      #Create the jitterplot
      p <- ggplot(hl_data, aes(x = `Composite score`, y = random_y, color = highlight, 
                               text = paste("LTLA Name:", ltla21_name, "<br>Health Index Score:", `Composite score`))) +
        geom_jitter(width = 0.2, height = 0, size = 3) +
        geom_hline(yintercept = 0, color = "grey", linewidth = 0.3) +
        geom_vline(xintercept = additional_lines, color = "grey", linewidth = 0.3) +
        geom_vline(xintercept = 0, colour = "black", linewidth = 0.7) +
        scale_x_continuous(
          limits = c(-x_max, x_max),
          breaks = c(additional_lines, 0),
          labels = labels
        ) +
        scale_color_manual(values = c("Selected" = "blue", "Not Selected" = "grey")) +
        labs(
          x = "Normalised units",
          y = "Counties",
          title = "Composite Score Jitterplot"
        ) +
        theme_minimal() +
        theme(axis.text.y = element_blank(), # Hides major grid lines and text
              axis.ticks.y = element_blank(),
              panel.grid.major.y = element_blank(), 
              panel.grid.minor.y = element_blank(),
              panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank())
      
      #Adjust ration of x to y units, to make plot less tall
      p <- p + coord_fixed(ratio = 3)
      
      #Convert to Plotly with tooltip
      ggplotly(p, tooltip = "text")
    })
    
    #Render the Help Button
    observeEvent(input$help_button, {
      showModal(modalDialog(
        title = "Help",
        easyClose = TRUE,
        footer = NULL,
        HTML("
      <ul>
        <li>This chart displays health index scores for various local authorities in Wales.</li>
        <li>Use the dropdown menu to select a local authority to highlight its position on the plot. The chart will update accordingly to show the selected area's scores.</li>
        <li>Health index scores are calculated by adding the z scores for healthy lives indicators for each LTLA.</li>
        <li>For more information on how the score was created, see the health index methods button at the top of the page.</li>
      </ul>
    ")
      ))
    })
    
    # Toggle visibility of the method info section
    observeEvent(input$toggle_method_info, {
      toggle(id = "method_info", anim = TRUE)
      
      # Change the arrow direction
      if (isTRUE(input$toggle_method_info %% 2 == 1)) {
        updateActionLink(session, "toggle_method_info", label = "Health Index Method ↑")
      } else {
        updateActionLink(session, "toggle_method_info", label = "Health Index Method ↓")
      }
    })
  })
}