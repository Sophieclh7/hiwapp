#UI function for the boxplot module
boxplotUI <- function(id) {
  ns <- NS(id)
  plotlyOutput(ns("boxplot"), height = "600px")  # Set height here
}

#Server function for boxplot module
boxplotServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$boxplot <- renderPlotly({
      
      #Load data
      hl_data <- get(load("data/hl_composite_score.rda"))
      
      #Reshape data to long format
      long_data <- hl_data |>
        pivot_longer(
          cols = c("Behavioural risk composite score",
                   "Children & young people composite score",
                   "Physiological risk factors composite score",
                   "Protective measures composite score"),
          names_to = "ScoreType",
          values_to = "ScoreValue"
        )
      
      #Update the ScoreType column to use desired labels
      long_data$ScoreType <- factor(long_data$ScoreType,
                                    levels = c("Behavioural risk composite score",
                                               "Children & young people composite score",
                                               "Physiological risk factors composite score",
                                               "Protective measures composite score"),
                                    labels = c("Behavioural risk factors",
                                               "Children and young people",
                                               "Physiological risk factors",
                                               "Protective measures"))
      
      #Add `text` column for tooltips
      long_data$text <- paste("LTLA Name:", long_data$ltla21_name, "<br>Score:", long_data$ScoreValue)
      
      #Create boxplots
      p <- ggplot(long_data, aes(x = ScoreType, y = ScoreValue)) +
        geom_boxplot() +
        geom_jitter(width = 0.2, height = 0, alpha = 0.5) +
        theme_minimal() +
        labs(x = "Subdomain", y = "Normalised score", title = "Boxplots of scores for each subdomain") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
      
      #Convert to plotly object and add tooltips
      ggplotly(p, tooltip = "text")
    })
  })
}