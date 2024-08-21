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

#Server function for compJitter module
compJitterServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Load data
    hl_data <- get(load("data/hl_composite_score.rda"))
    
    # Update ltla dropdown choices
    updateSelectInput(session, "ltla_select", choices = hl_data$ltla21_name)
    
    output$compJitter <- renderPlotly({
      
      # Add a random y-axis value for each point
      set.seed(123)  # for reproducibility
      hl_data$random_y <- runif(nrow(hl_data), min = -1, max = 1)
      
      # Define the new range for x-axis
      x_min <- 85
      x_max <- 115
      
      # Define points for vertical grid lines in the new range
      additional_lines <- seq(85, 115, by = 5)
      labels <- as.character(additional_lines)
      
      # Add custom x-axis labels including "Welsh Average"
      x_labels <- labels
      x_labels[which(labels == "100")] <- "100\nWelsh Average"
      
      # Highlight the selected LTLA
      hl_data$highlight <- ifelse(hl_data$ltla21_name == input$ltla_select, "Selected", "Not Selected")
      
      # Create the jitterplot
      p <- ggplot(hl_data, aes(x = `Composite score`, y = random_y, color = highlight, 
                               text = paste("Area Name:", ltla21_name, "<br>Healthy Lives Score:", round(`Composite score`)))) +
        geom_jitter(width = 0.2, height = 0, size = 3) +
        geom_hline(yintercept = 0, color = "grey", linewidth = 0.3) +
        geom_vline(xintercept = additional_lines, color = "grey", linewidth = 0.3) +
        geom_vline(xintercept = 100, colour = "black", linewidth = 0.7, linetype = "dashed") +  # Dashed line at x = 100
        scale_x_continuous(
          limits = c(x_min, x_max),
          breaks = additional_lines,
          labels = x_labels
        ) +
        scale_color_manual(values = c("Selected" = "blue", "Not Selected" = "orange")) +
        labs(
          x = "Health Index Score",
          y = "Areas",
          title = "Health Score Jitterplot"
        ) +
        theme_minimal() +
        theme(axis.text.y = element_blank(), # Hides major grid lines and text
              axis.ticks.y = element_blank(),
              panel.grid.major.y = element_blank(), 
              panel.grid.minor.y = element_blank(),
              panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank()) +
        coord_fixed(ratio = 3)  # Adjust ratio of x to y units, to make plot less tall
      
      # Convert to Plotly
      ggplotly(p, tooltip = "text") %>%
        layout(
          annotations = list(
            list(
              x = 105, 
              y = 0.9,  # Adjusted y value to bring the label closer to the plot
              text = "Better Than Average", 
              showarrow = FALSE, 
              xref = "x", 
              yref = "paper",
              font = list(size = 12)
            ),
            list(
              x = 95, 
              y = 0.9,  # Adjusted y value to bring the label closer to the plot
              text = "Worse Than Average", 
              showarrow = FALSE, 
              xref = "x", 
              yref = "paper",
              font = list(size = 12)
            )
          )
        )
    })
    
    # Render the Help Button
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