#UI function for the boxplot module
boxplotUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("selected_ltla"), "Select area:",
                choices = NULL,  # Choices will be populated in server function
                selected = NULL),
    actionButton(ns("help_button"), "Help"),
    plotlyOutput(ns("boxplot"), height = "600px"),
    shinyjs::useShinyjs(),  # Ensure shinyjs is included
    actionLink(ns("toggle_method_info"), "How to read the boxplots ↓"),
    div(id = ns("method_info"), style = "display: none;",  # Ensure it's hidden by default
        p("The diagram below displays how to read the subdomains boxplots."),
        tags$img(src = "boxplot.png", alt = "Boxplot Diagram", style = "max-width: 100%; height: auto;")  # Add your image here
    )
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
               # Round ScoreValue to the nearest whole number and format text for tooltips
               text = paste("Area name: ", ltla21_name, "<br>Subdomain score: ", round(ScoreValue))) 
      
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
        <li>This chart shows subdomain scores for each area for each subdomain under Healthy Lives. The dotted line across the middle of the boxplot is the Welsh Average score. </li>
        <li>Select an area from the dropdown menu to highlight its scores on the plot.</li>
        <li>The chart will update to show how the selected area compares to others.</li>
        <li>See drop down menu below for how to read the boxplot </li>
        <li>For more details on how scores are calculated, please refer to Methodology tab.</li>
      </ul>
    ")
      ))
    })
    # Toggle visibility of the method info section
    observeEvent(input$toggle_method_info, {
      toggle(id = "method_info", anim = TRUE)
      
      # Change the arrow direction
      if (isTRUE(input$toggle_method_info %% 2 == 1)) {
        updateActionLink(session, "toggle_method_info", label = "How to read the boxplots ↑")
      } else {
        updateActionLink(session, "toggle_method_info", label = "How to read the boxplots ↓")
      }
    })
  })
}

