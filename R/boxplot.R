#UI function for the boxplot module
boxplotUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("selected_ltla"), "Select LTLA:",
                choices = NULL,  # Choices will be populated in server function
                selected = NULL),
  plotlyOutput(ns("boxplot"), height = "600px")
  )
}

# Server function for boxplot module
boxplotServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Load data
    hl_data <- get(load("data/hl_composite_score.rda"))
    
    # Reshape data to long format
    long_data <- hl_data |>
      pivot_longer(
        cols = c("Behavioural risk composite score",
                 "Children & young people composite score",
                 "Physiological risk factors composite score",
                 "Protective measures composite score"),
        names_to = "ScoreType",
        values_to = "ScoreValue"
      )
    
    # Update the ScoreType column to use desired labels
    long_data$ScoreType <- factor(long_data$ScoreType,
                                  levels = c("Behavioural risk composite score",
                                             "Children & young people composite score",
                                             "Physiological risk factors composite score",
                                             "Protective measures composite score"),
                                  labels = c("Behavioural risk factors",
                                             "Children and young people",
                                             "Physiological risk factors",
                                             "Protective measures"))
    
    # Populate selectInput with LTLA names
    updateSelectInput(session, "selected_ltla",
                      choices = unique(long_data$ltla21_name))
    
    # Compute deterministic jitter positions
    jittered_data <- long_data %>%
      group_by(ScoreType) %>%
      mutate(jitter_x = as.numeric(factor(ltla21_name)) * 0.2 - 0.1)  # Fixed jitter width per LTLA
    
    # Render the boxplot
    output$boxplot <- renderPlotly({
      # Highlighted LTLA
      highlighted_ltla <- input$selected_ltla
      
      # Create the boxplot using ggplot
      p <- ggplot(jittered_data, aes(x = ScoreType, y = ScoreValue)) +
        geom_boxplot(aes(group = ScoreType), alpha = 0.5) +  # Use alpha to adjust boxplot transparency
        geom_point(aes(color = ltla21_name == highlighted_ltla),
                   position = position_jitter(width = 0.2, seed = 123),  # Use fixed jitter width
                   size = 3, shape = 21, fill = "white", show.legend = FALSE) +
        scale_color_manual(values = c("TRUE" = "blue", "FALSE" = "black")) +
        theme_minimal() +
        labs(x = "Subdomain", y = "Normalised score", title = "Boxplots of scores for each subdomain") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
      
      # Convert to plotly object
      ggplotly(p, tooltip = c("x", "y")) %>%
        layout(hovermode = "closest")
    })
  })
}