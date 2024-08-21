# ---- user interface ----
compositechartUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("county"), "Select County:",
                choices = c("Select" = "", 
                            "Isle of Anglesey", "Gwynedd", "Conwy", "Denbighshire", 
                            "Flintshire", "Wrexham", "Ceredigion", "Pembrokeshire", 
                            "Carmarthenshire", "Swansea", "Neath Port Talbot", 
                            "Bridgend", "Vale of Glamorgan", "Cardiff", 
                            "Rhondda Cynon Taf", "Caerphilly", "Blaenau Gwent", 
                            "Torfaen", "Monmouthshire", "Newport", 
                            "Powys", "Merthyr Tydfil")),
    plotOutput(ns("comparisonPlot")),
    textOutput(ns("description"))
  )
}
# ---- Server Function ----
compositechartServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$comparisonPlot <- renderPlot({
      # Load the data from the data directory
      load("data/hl_composite_score.rda")
      
      # Filter data based on the selected county
      county_selected <- input$county
      
      data_to_plot <- if (county_selected == "") {
        hl_composite_score %>%
          filter(county == "Wales") # Assuming "Wales" is used for Welsh averages
      } else {
        hl_composite_score %>%
          filter(county %in% c("Wales", county_selected))
      }
      
      # Plot using ggplot2
      ggplot(data_to_plot, aes(x = subdomain, y = score, fill = county)) +
        geom_bar(stat = "identity", position = "dodge") +
        labs(title = paste("Comparison of Welsh and", county_selected, "Averages"),
             x = "Subdomain",
             y = "Average Score",
             fill = "County") +
        theme_minimal() +
        coord_flip()
    })
    
    output$description <- renderText({
      "This chart compares the average scores of the subdomains for the Healthy Lives domain within the Health Index against the selected County (LTLA) against the Welsh average."
    })
  })
}