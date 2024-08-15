#UI function for the compJitter module
compJitterUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("ltla_select"), "Select LTLA:", choices = NULL),
  plotlyOutput(ns("compJitter")) 
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
  })
}