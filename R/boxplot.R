# ---- UI function ----
boxplotUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("selected_ltla"), "Select area:", choices = NULL),  # Dropdown, choices added in server
    actionButton(ns("help_button"), "Help"), # Help button
    plotlyOutput(ns("boxplot"), height = "600px"), # Boxplot
    shinyjs::useShinyjs(),  # Include shinyjs
    actionLink(ns("toggle_method_info"), "How to read the boxplots ↓"), # Dropdown for boxplot diagram
    div(id = ns("method_info"), style = "display: none;",  # Hidden dropdown
        p("The diagram below displays how to read the subdomains boxplots."),
        tags$img(src = "boxplot.png", style = "max-width: 100%")  # Boxplot diagram, sized to fit screen
    )
  )
}

# ---- Server function ----
boxplotServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Load data
    load("data/hl_composite_score.rda") 
    
    # Transform data from wide to long
    # To allow boxplots to be plotted alongside each other
    long_data <- hl_composite_score |>
      pivot_longer( # Reshape data from wide to long format
        cols = c("Behavioural risk score", # Specifies the columns to pivot
                 "Children & young people score",
                 "Physiological risk factors score",
                 "Protective measures score"),
        names_to = "ScoreType", # Creates new column which contains the subdomain names
        values_to = "ScoreValue" # Creates new column which contains the subdomain values, eg. one row will say Cardiff, Behavioural Risk, Score for that subdomain
      ) |>
      mutate(ScoreType = recode(ScoreType, # Recodes score type column to have subdomain names
                                "Behavioural risk score" = "Behavioural risk factors",
                                "Children & young people score" = "Children and young people",
                                "Physiological risk factors score" = "Physiological risk factors",
                                "Protective measures score" = "Protective measures"))
    
    # Update the UI dropdown with the ltla choices
    updateSelectInput(session, "selected_ltla",
                      choices = unique(long_data$ltla21_name))
    
    # Ensure jitter positions stay the same every time app is run
    jittered_data <- long_data |>
      group_by(ScoreType) |>
      mutate(jitter_x = as.numeric(factor(ltla21_name)) * 0.2 - 0.1) # Adds new column jitter_x, used to adjust positions of points to prevent overlap.
    
    # Render the boxplots
    output$boxplot <- renderPlotly({
      highlighted_ltla <- input$selected_ltla # Retreives selected ltla from dropdown
      
      # Add highlight and tooltip text
      jittered_data <- jittered_data |>
        mutate(highlight = ifelse(ltla21_name == highlighted_ltla, "Selected", "Not Selected"), # Adds news column for whether a row's ltla matches selected ltla from dropdown
               text = paste("Area name: ", ltla21_name, "<br>Subdomain score: ", round(ScoreValue))) # Adds column for text hovered over points on plot
      
      # Create the boxplot
      p <- ggplot(jittered_data, aes(x = ScoreType, y = ScoreValue)) + # Creates ggplot object with subdomain type on x axis, subdomain score on y axis
        geom_boxplot(aes(group = ScoreType)) + # Adds boxplot to ggplot object, groups the boxplots by subdomain
        geom_point(aes(color = highlight, fill = highlight, text = text),
                   position = position_jitter(width = 0.2, seed = 123), # Sets point not too far apart and ensures random positions stay the same when reload
                   size = 2) + 
        scale_color_manual(values = c("Selected" = "blue", "Not Selected" = "orange")) + # Points are blue for selected ltla, orange for not selected
        scale_fill_manual(values = c("Selected" = "blue", "Not Selected" = "orange")) + # Makes sure colour fills whole point
        theme_minimal() + # Gets rid of unnecessary grid lines
        labs(x = "Subdomain", y = "Health score", 
             title = "Subdomain scores boxplots") + # Labels axes and title
        theme(axis.text.x = element_text(angle = 45, hjust = 1), # Rotates x axis by 45 degrees
              plot.title = element_text(size = 20)) +
        scale_y_continuous(limits = c(80, 120), breaks = seq(80, 120, by = 5), # Sets range of y axis, with intervals of 5
                           labels = function(x) {
                             ifelse(x == 100, "100\nWelsh Average", as.character(x)) # Creates welsh average label where x = 100
                           }) +
        geom_hline(yintercept = 100, linetype = "dashed") # Adds dashed line at x = 100 for welsh average
      
      # Convert to Plotly object
      ggplotly(p, tooltip = c("text")) # Converts ggplot object p to Plotly object, tooltip text specifies that the tooltip will display text when hovering over points
    })
    
    # Render the Help Button
    observeEvent(input$help_button, { # Observes for when help button clicked
      showModal(modalDialog( # Displays help box on screen
        title = "Help",
        easyClose = TRUE, # Allows user to close help button by clicking elsewhere on screen
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
    
    # Reactive visability of the how to read boxplots dropdown
    # Create a reactive value to track the visibility state of the diagram, false means the diagram is initially hidden
    state <- reactiveVal(FALSE)
    
    # Create observe which watches for whether dropdown button clicked
    observeEvent(input$toggle_method_info, {
      
      # Changes between showing and not showing diagram
      state(!state())
      
      # Display diagram when dropdown button clicked
      if (state()) {
        toggle(id = "method_info", anim = TRUE)  # Show the diagram
        new_label <- "How to read the boxplots ↑"  # When diagram showing, arrow on dropdown icon faces up
      } else {
        toggle(id = "method_info", anim = TRUE)  # Hide the diagram
        new_label <- "How to read the boxplots ↓"  # When diagram not showing, arrow on dropdown icon faces down
      }
      
      # Update the dropdown button with the change of arrow when dropdown button clicked
      updateActionLink(session, "toggle_method_info", label = new_label)
    })
  })
}


