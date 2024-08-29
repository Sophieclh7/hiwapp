# ---- UI function ----
compositechartUI <- function(id) {
  ns <- NS(id) # Namespace ensures unique input and output IDs
  
  # Define the UI elements
  tagList(
    
    # Main header for the UI
    tags$h2("Subdomain Score Chart"), 
    
    # Button to show the help modal
    actionButton(ns("help"), label = "Help"),
    
    # Drop Down Menu to select ltla
    selectInput(
      ns("LTLA"), 
      label = "Select area:",
      choices = c("", 
                  "Isle of Anglesey", "Gwynedd", "Conwy", "Denbighshire",
                  "Flintshire", "Wrexham", "Ceredigion", "Pembrokeshire",
                  "Carmarthenshire", "Swansea", "Neath Port Talbot",
                  "Bridgend", "Vale of Glamorgan", "Cardiff",
                  "Rhondda Cynon Taf", "Caerphilly", "Blaenau Gwent",
                  "Torfaen", "Monmouthshire", "Newport",
                  "Powys", "Merthyr Tydfil"),
      selected = "Isle of Anglesey" # Sets Isle of Anglesey as default
    ),
    
    # Output for comparison table
    tableOutput(ns("comparisonTable")),
    
    # Output for description
    textOutput(ns("description"))
  )
}

# ---- Server Function ----
compositechartServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Load data 
    load("data/hl_composite_score.rda")
    
    output$comparisonTable <- renderTable({
      
      # Create the Welsh average row
      welsh_average_row <- tibble::tibble(
        `Area name` = "Welsh average",
        `Behavioural risk score` = 100,
        `Children & young people score` = 100,
        `Physiological risk factors score` = 100,
        `Protective measures score` = 100
      )
      
      # Filter data based on the selected LTLA
      data_to_display <- hl_composite_score %>%
        filter(ltla21_name == input$LTLA | input$LTLA == "") %>%
        select(
          ltla21_name,
          `Behavioural risk score`,
          `Children & young people score`,
          `Physiological risk factors score`,
          `Protective measures score`
        ) %>% # Display subdomain score for ltla selected
        rename("Area name" = ltla21_name)
      
      # Binds Welsh average score to table as a row for comparison
      data_to_display <- bind_rows(welsh_average_row, data_to_display)
      data_to_display
    })
    
    # ---- Render the description ----
    output$description <- renderText({
      if (input$LTLA == "") {
        "This table shows the subdomain scores for areas in Wales."
      } else {
        paste("This table shows the subdomain scores for", input$LTLA, "in Wales.")
      }
    })
    
    # Render the Help Button
    observeEvent(input$help, { # Observes for when help button clicked
      showModal(modalDialog( # Displays help box on screen
        title = "Help",
        easyClose = TRUE, # Allows user to close help button by clicking elsewhere on screen
        footer = NULL,
        HTML("
          <ul>
            <li>This chart displays subdomain scores for areas in Wales compared to the Welsh average score.</li>
            <li>Use the dropdown menu to select an area to display its subdomain scores</li>
            <li>For more information on how the score was created, please refer to the methodology tab.</li>
          </ul>
        ")
      ))
    })
  })
}