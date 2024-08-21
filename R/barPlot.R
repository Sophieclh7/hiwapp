# ---- barPlotServer.R ----

library(ggplot2)
library(dplyr)

generateBarPlot <- function(data, selected_regions) {
  data_to_plot <- data %>%
    mutate(Highlighted = ltla21_name %in% selected_regions) %>%
    arrange(desc(Composite_Score))  # Assuming 'Composite_Score' is your score column
  
  ggplot(data_to_plot, aes(x = reorder(ltla21_name, Composite_Score), y = Composite_Score, fill = Highlighted)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    scale_fill_manual(values = c("TRUE" = "red", "FALSE" = "grey")) +
    labs(
      title = "Composite Score by LTLA Name",
      x = "LTLA Name",
      y = "Composite Score",
      fill = "Highlighted"
    ) +
    theme_minimal()
}

renderBarChart <- function(output, data, selected_regions) {
  output$bar_chart <- renderPlot({
    generateBarPlot(data, selected_regions())
  })
}

