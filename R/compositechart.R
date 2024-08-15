# ---- user interface ----
compositechartUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$h2(class = "chart-title", "Health Index Score Chart"),
    
    # ---- Help Button ----
    actionButton(ns("help_button"), "Help"),
    
    # ---- Drop Down Menu ----
    selectInput(
      ns("LTLA"), 
      label = "Select an LTLA to view its composite scores:",
      choices = c("", 
                  "Isle of Anglesey", "Gwynedd", "Conwy", "Denbighshire",
                  "Flintshire", "Wrexham", "Ceredigion", "Pembrokeshire",
                  "Carmarthenshire", "Swansea", "Neath Port Talbot",
                  "Bridgend", "Vale of Glamorgan", "Cardiff",
                  "Rhondda Cynon Taf", "Caerphilly", "Blaenau Gwent",
                  "Torfaen", "Monmouthshire", "Newport",
                  "Powys", "Merthyr Tydfil")),
    
    # Output for comparison table
    tableOutput(ns("comparisonTable")),
    
    # Output for description
    textOutput(ns("description"))
  )
}                 
# ---- Server Function ----
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
            "Behavioural risk composite score", 
            "Children & young people composite score", 
            "Physiological risk factors composite score", 
            "Protective measures composite score") %in% colnames(hl_composite_score)),
      "One or more required columns are missing from the data frame."
    )
    
    output$comparisonTable <- renderTable({
      # Filter data based on the selected LTLA
      data_to_display <- if (input$LTLA == "") {
        hl_composite_score
      } else {
        hl_composite_score |>
          filter(ltla21_name == input$LTLA)
      }
      
      data_to_display |>
        select(
          `Behavioural risk composite score`,
          `Children & young people composite score`,
          `Physiological risk factors composite score`,
          `Protective measures composite score`
        )
    })
    
    # ---- Render the description ----
    output$description <- renderText({
      if (input$LTLA == "") {
        "This table shows the composite scores for all counties (LTLAs) in Wales."
      } else {
        paste("This table shows the composite scores for", input$LTLA, "in Wales.")
      }
    })
    
    # ---- Render the Help Button ----
    observeEvent(input$help_button, {
      showModal(modalDialog(
        title = "Help",
        easyClose = TRUE,
        footer = NULL,
        "This chart displays composite scores for various local authorities in Wales. 
         Use the dropdown menu to select a local authority to view its specific composite scores. 
         The table will update accordingly to show the selected area's scores for different categories."
      ))
    })
  })  
}