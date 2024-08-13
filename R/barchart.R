# ---- user interface ----
barchartUI <-
  function
(id){
  ns <- NS(id)
  plotOutput(ns(
    "barchart"
  ))}

# ---- server function ----
barchartServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$barchart <- renderPlot  ( {
      # Load the R data file
      load("data/hl_raw_data.rda")
      
      # Assuming the data is loaded into a variable named 'hl_raw_data'
      # Create a bar chart
      bar_chart <- ggplot(hl_raw_data, aes(x = ltla21_name, y = Adult_overweight_obese)) +
        geom_bar(stat = "identity") +
        theme_minimal() +
        labs(title = "Bar Chart Example", x = "Category", y = "Value")
      
      # Display the bar chart
      print(bar_chart)
    })
  })
}
