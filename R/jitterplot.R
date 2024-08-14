#UI function for the compJitter module
compJitterUI <- function(id) {
  ns <- NS(id)
  plotlyOutput(ns("compJitter"))
}

#Server function for the compJitter module
compJitterServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$compJitter <- renderPlotly({
      
      hl_data <- get(load("data/hl_composite_score.rda"))
      
      #Add a random y-axis value for each point
      set.seed(123)  # for reproducibility
      hl_data$random_y <- runif(nrow(hl_data), min = -1, max = 1)
      
      #Calculate the mean of the Composite score
      mean_composite_score <- mean(hl_data$`Composite score`, na.rm = TRUE)
      
      #Determine the range of the x-axis to center the vertical line
      x_max <- max(abs(hl_data$`Composite score`), na.rm = TRUE)
      
      #Create the ggplot with random y-axis positions and add lines
      # Create the ggplot with random y-axis positions and add lines
      p <- ggplot(hl_data, aes(x = `Composite score`, y = random_y, 
                               text = paste("LTLA Name:", ltla21_name, "<br>Health Index Score:", `Composite score`))) +
        geom_jitter(width = 0.2, height = 0) +
        geom_hline(yintercept = 0, color = "black", size = 0.03) +  # Solid, thinner horizontal line
        geom_vline(xintercept = 0, color = "black", size = 0.5) +  # Solid, thinner vertical line at the center
        scale_x_continuous(limits = c(-x_max, x_max)) +  # Make x-axis symmetric
        labs(
          x = "Normalised units",
          y = "ONS Health Index rank",
          title = "Health composite scores for Wales"
        ) +
        theme_minimal() +
        theme(axis.text.y = element_blank(), # Remove y-axis text
              axis.ticks.y = element_blank(), # Remove y-axis ticks
              panel.grid.major.y = element_blank(), # Remove major grid lines on y-axis
              panel.grid.minor.y = element_blank(), # Remove minor grid lines on y-axis
              panel.grid.major.x = element_blank(), # Remove major grid lines on x-axis
              panel.grid.minor.x = element_blank()) # Remove minor grid lines on x-axis
      
      # Fix the aspect ratio to make the plot vertically shorter
      p <- p + coord_fixed(ratio = 0.5)  # Adjust the ratio as needed
      
      # Convert to a plotly object and keep both ltla21_name and Health Index Score in the hover information
      ggplotly(p, tooltip = "text")
    })
  })
}
