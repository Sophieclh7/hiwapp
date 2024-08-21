# ---- User Interface ----
# ---- User Interface ----
compositechartUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$h2("Health Index Score Chart"),
    
    # ---- Drop Down Menu ----
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
      selected = "Isle of Anglesey"  # Set default value here
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
    # Load the data from the data directory
    load("data/hl_composite_score.rda")
    
    # Ensure hl_composite_score is loaded and available
    req(exists("hl_composite_score"), "Data frame 'hl_composite_score' not found. Please check your data loading.")
    
    # Verify column names to ensure correct column names are used
    req(
      all(c("ltla21_name", 
            "ltla21_code",
            "Behavioural risk score", 
            "Children & young people score", 
            "Physiological risk factors score", 
            "Protective measures score") %in% colnames(hl_composite_score)),
      "One or more required columns are missing from the data frame."
    )
    
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
        ) %>%
        rename("Area name" = ltla21_name)
      
      # Bind the Welsh average row to the top of the table
      data_to_display <- bind_rows(welsh_average_row, data_to_display)
      
      data_to_display
    })
    
    # ---- Render the description ----
    output$description <- renderText({
      if (input$LTLA == "") {
        "This table shows the composite scores for all counties (LTLAs) in Wales."
      } else {
        paste("This table shows the subdomain scores for", input$LTLA, "in Wales.")
      }
    })
    
    # ---- Render the Help Button ----
    observeEvent(input$help_button, {
      showModal(modalDialog(
        title = "Help",
        easyClose = TRUE,
        footer = NULL,
        HTML(
          "<ul>
            <li>This chart displays composite scores for various local authorities in Wales.</li>
            <li>Use the dropdown menu to select a local authority to view its specific composite scores.</li>
            <li>The table will update accordingly to show the selected area's scores for different categories.</li>
            <li>The Welsh average row provides a benchmark with a score of 100 for all categories.</li>
          </ul>"
        )
      ))
    })
  })
}