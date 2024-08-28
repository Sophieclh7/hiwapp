# ---- UI function ----
compositechartUI <- function(id) {
  ns <- NS(id) # Namespace ensures unique input and output IDs
  
  tagList(
    tags$h2("Subdomain Score Chart"), # Main header for the UI
    
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
      data_to_display <- hl_composite_score |>
        filter(ltla21_name == input$LTLA | input$LTLA == "") |>
        select(
          ltla21_name,
          `Behavioural risk score`,
          `Children & young people score`,
          `Physiological risk factors score`,
          `Protective measures score`
        ) |> # Display subdomain score for ltla selected
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
  })
}