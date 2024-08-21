# UI function for the compJitter module
compJitterUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("ltla_select"), "Select area:", choices = NULL),
    actionButton(ns("help_button"), "Help"),
    plotlyOutput(ns("compJitter")),
    br()  # Adds a line break
  )
}

# Server function for compJitter module
compJitterServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Load data
    hl_data <- get(load("data/hl_composite_score.rda"))
    
    # Check if 'Composite score' column exists
    if (!"Composite score" %in% colnames(hl_data)) {
      stop("The column 'Composite score' does not exist in the data.")
    }
    
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
          x = "Healthy Lives Score",
          y = "Areas",
          title = "Healthy Lives Jitterplot"
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
        <li>This chart displays healthy lives scores areas in Wales. The dotted line down the centre shows the Welsh average score</li>
        <li>Use the dropdown menu to select an area to highlight its position on the plot.</li>
        <li>Hover over points on the plot to see their healthy lives scores.</li>
        <li>For more information on how the score was created, please refer to the methodology tab.</li>
      </ul>
    ")
      ))
    })
  })
}