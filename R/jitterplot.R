# ---- UI function ----
compJitterUI <- function(id) {
  ns <- NS(id) # Namespace ensures unique input and output IDs
  
  # Define the UI elements
  tagList( 
    
    # Button to show the help modal
    actionButton(ns("help_button"), "Help"), # Adds help button
    
    # Dropdown menu to select ltla
    selectInput(ns("ltla_select"), "Select area:", choices = NULL), 
    
    # Add jitterplot
    plotlyOutput(ns("compJitter")) 
  )
}

# ---- Server function ----
compJitterServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Load data
    load("data/hl_composite_score.rda") 
    
    # Update the UI dropdown with the ltla choices
    updateSelectInput(session, "ltla_select", choices = hl_composite_score$ltla21_name)
    
    # Ensure the same set of random y points will be produced each time app is run
    set.seed(123)
    
    # Add random y-axis values for each point - typical feature of jitterplot to ensure points don't overlap
    hl_composite_score$random_y <- runif(nrow(hl_composite_score), min = -1, max = 1) # Sets height limit for points
    
    output$compJitter <- renderPlotly({
      
      # Set the range for the x-axis
      x_min <- 85 
      x_max <- 115
      
      # Create labels for intervals of 5 along the x axis, with the 100 label saying "Welsh Average"
      x_labels <- as.character(seq(x_min, x_max, by = 5))
      x_labels[x_labels == "100"] <- "100\nWelsh Average"
      
      # Highlight the selected ltla
      hl_composite_score$highlight <- ifelse(hl_composite_score$ltla21_name == input$ltla_select, "Selected", "Not Selected")
      
      # Create the jitterplot
      p <- ggplot(hl_composite_score, aes(x = `Composite score`, y = random_y, color = highlight, # Sets healthy lives score on x axis and random positions along y axis
                                          text = paste("Area Name:", ltla21_name, "<br>Healthy Lives Score:", round(`Composite score`)))) + # Displays Area name and Healthy Lives Scores when hover over the points
        geom_jitter(size = 3) + # Specify size of points
        geom_hline(yintercept = 0, color = "grey", linewidth = 0.3) + #Adds horizontal line at y = 0
        geom_vline(xintercept = seq(x_min, x_max, by = 5), color = "grey", linewidth = 0.3) + # Adds vertical lines at every interval of 5 along the x axis
        geom_vline(xintercept = 100, colour = "black", linewidth = 0.7, linetype = "dashed") +  # Adds dashed vertical line at x = 100
        scale_x_continuous(
          limits = c(x_min, x_max),
          breaks = seq(x_min, x_max, by = 5),
          labels = x_labels
        ) +
        scale_color_manual(values = c("Selected" = "blue", "Not Selected" = "orange")) + # Highlight selected ltla blue and not selected ltlas orange
        labs(
          x = "Healthy Lives Score", # Adds x axis label
          y = "Areas", # Adds y axis label
          title = "Healthy Lives Jitterplot" # Adds title
        ) +
        theme_minimal() +
        theme(axis.text.y = element_blank(), # Hides y axis labels
              axis.ticks.y = element_blank(),
              panel.grid.major.y = element_blank(), # Hides unwanted gridlines
              panel.grid.minor.y = element_blank(),
              panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank()) +
        coord_fixed(ratio = 3)  # Adjust ratio of x to y units, to make plot less tall
      
      # Convert to Plotly object
      ggplotly(p, tooltip = "text") |> # Converts ggplot object p to Plotly object, tooltip text specifies that the tooltip will display text when hovering over points
        layout(
          annotations = list( #Add the worse/better than average labels to the plot
            list(
              x = 105, # Label to the right of the average dotted line
              y = 0.9,  # High y coordinate so label appears at top of plot
              text = "Better Than Average", 
              showarrow = FALSE, # Gets rid of arrows
              yref = "paper", # Sets y coordinate height of label to be relative to plotly object, rather than ggplot height
              font = list(size = 12) # Sets font size to 12
            ),
            list( # As above
              x = 95, # Label to the left of the average dotted line
              y = 0.9,  
              text = "Worse Than Average", 
              showarrow = FALSE, 
              yref = "paper",
              font = list(size = 12)
            )
          )
        )
    })
    
    # Render the Help Button
    observeEvent(input$help_button, { # Observes for when help button clicked
      showModal(modalDialog( # Displays help box on screen
        title = "Help",
        easyClose = TRUE, # Allows user to close help button by clicking elsewhere on screen
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