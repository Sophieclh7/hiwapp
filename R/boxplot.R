#UI function for the boxplot module
boxplotUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("selected_ltla"), "Select area:",
                choices = NULL,  # Choices will be populated in server function
                selected = NULL),
    actionButton(ns("help_button"), "Help"),
    plotlyOutput(ns("boxplot"), height = "600px")
  )
}
# Server function for boxplot module
boxplotServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Load and reshape data
    hl_data <- get(load("data/hl_composite_score.rda"))
    
    long_data <- hl_data |>
      pivot_longer(
        cols = c("Behavioural risk score",
                 "Children & young people score",
                 "Physiological risk factors score",
                 "Protective measures score"),
        names_to = "ScoreType",
        values_to = "ScoreValue"
      ) |>
      mutate(ScoreType = factor(ScoreType,
                                levels = c("Behavioural risk score",
                                           "Children & young people score",
                                           "Physiological risk factors score",
                                           "Protective measures score"),
                                labels = c("Behavioural risk factors",
                                           "Children and young people",
                                           "Physiological risk factors",
                                           "Protective measures")))
    
    # Update the dropdown choices
    updateSelectInput(session, "selected_ltla",
                      choices = unique(long_data$ltla21_name))
    
    # Ensure jitter positions stay consistent
    jittered_data <- long_data |>
      group_by(ScoreType) |>
      mutate(jitter_x = as.numeric(factor(ltla21_name)) * 0.2 - 0.1)
    
    # Render the boxplot
    output$boxplot <- renderPlotly({
      highlighted_ltla <- input$selected_ltla
      
      # Add highlight and tooltip text
      jittered_data <- jittered_data |>
        mutate(highlight = ifelse(ltla21_name == highlighted_ltla, "Selected", "Not Selected"),
               text = paste("LTLA: ", ltla21_name, "<br>Score: ", ScoreValue))
      
      # Create the boxplot
      p <- ggplot(jittered_data, aes(x = ScoreType, y = ScoreValue)) +
        geom_boxplot(aes(group = ScoreType), alpha = 0.5) +
        geom_point(aes(color = highlight, fill = highlight, text = text),
                   position = position_jitter(width = 0.2, seed = 123),
                   size = 2, shape = 21) +
        scale_color_manual(values = c("Selected" = "blue", "Not Selected" = "orange"),
                           guide = guide_legend(title = NULL)) +
        scale_fill_manual(values = c("Selected" = "blue", "Not Selected" = "orange"),
                          guide = guide_legend(title = NULL)) +
        theme_minimal() +
        labs(x = "Subdomain", y = "Health score", 
             title = "Health Score Boxplot by Subdomain") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1),
              plot.title = element_text(size = 20)) +  # Match title size
        scale_y_continuous(limits = c(80, 120), breaks = seq(80, 120, by = 5),
                           labels = function(x) {
                             ifelse(x == 100, "100\nWelsh Average", as.character(x))
                           }) +
        geom_hline(yintercept = 100, linetype = "dashed")
      
      # Convert to Plotly object
      ggplotly(p, tooltip = c("text")) |>
        layout(hovermode = "closest")
    })
    
    # Render the Help Button
    observeEvent(input$help_button, {
      showModal(modalDialog(
        title = "Help",
        easyClose = TRUE,
        footer = NULL,
        HTML("
            <ul>
        <li>This chart shows health scores for different categories (behavioural risk factors, children and young people, physiological risk factors, and protective measures) across various areas in Wales. The dotted line across the middle of the boxplot is the Welsh Average. </li>
        <li>Select an area from the dropdown menu to highlight its scores on the plot.</li>
        <li>The chart will update to show how the selected area compares to others.</li>
        <li>A box plot helps us understand how scores are spread out. Here's how it works:</li>
        <li>
          <ul>
            <li>The box in the plot shows where most of the scores fall. The line inside the box marks the middle score.</li>
            <li>Lines extending from the box show the range of scores, from the lowest to the highest, except for a few extreme values.</li>
            <li>Points outside these lines are considered unusual and are shown separately. These are called outliers </li>
          </ul>
        </li>
        <li>For more details on how these scores are calculated, check the health index methods button at the top of the page.</li>
      </ul>
    ")
      ))
    })
  })
}

