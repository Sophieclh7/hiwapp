# ---- user interface ----
compositechartUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Add the title here
    h1("Composite Score Chart"),
    
    # County selection input
    selectInput(
      ns("county"), 
      "Select County:",
      choices = c("Select" = "", 
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
compositechartServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Load the data from the data directory
    load("data/hl_composite_score.rda")
    
    # Ensure hl_composite_score is loaded and available
    req(exists("hl_composite_score"), "Data frame 'hl_composite_score' not found. Please check your data loading.")
    
    # Verify column names to ensure correct column names are used
    col_names <- colnames(hl_composite_score)
    
    # Check if the required columns exist
    req("ltla21_name" %in% col_names, "The data frame does not contain 'ltla21_name' column.")
    req("Behavioural risk composite score" %in% col_names, "Required column 'Behavioural risk composite score' not found.")
    req("Children & young people composite score" %in% col_names, "Required column 'Children & young people composite score' not found.")
    req("Physiological risk factors composite score" %in% col_names, "Required column 'Physiological risk factors composite score' not found.")
    req("Protective measures composite score" %in% col_names, "Required column 'Protective measures composite score' not found.")
    
    # Render the comparison table
    output$comparisonTable <- renderTable({
      # Filter data based on the selected county
      data_to_display <- if (input$county == "") {
        hl_composite_score
      } else {
        hl_composite_score |>
          filter(ltla21_name == input$county)
      }
      
      # Select the relevant columns
      data_to_display |>
        select(
          `Behavioural risk composite score`,
          `Children & young people composite score`,
          `Physiological risk factors composite score`,
          `Protective measures composite score`
        )
    })
    
    # Render the description
    output$description <- renderText({
      "This table shows the composite scores for the selected county (LTLA) in Wales."
    })
  })
}