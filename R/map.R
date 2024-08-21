# ---- map.R ----

# Load necessary libraries
library(shiny)
library(leaflet)
library(tidyverse)  # Includes dplyr and magrittr for pipe operators
library(sf)

# Create Temporary Directory and Copy Data
temp_dir <- tempdir()  # Create a temporary directory
temp_data_path <- file.path(temp_dir, "localauthorities_lwm.csv")
temp_comp_score <- file.path(temp_dir, "hl_composite_score.rda")

# Copying file paths
file.copy("C:/Users/ZaraMorgan/Downloads/localauthorities_lwm.csv", temp_data_path, overwrite = TRUE)
file.copy("C:/Users/ZaraMorgan/Documents/hiwapp/data/hl_composite_score.rda", temp_comp_score, overwrite = TRUE)

# Load and Process Data
wales_map <- read_csv(temp_data_path) |> 
  mutate(geometry = st_as_sfc(geom, crs = 27700)) |>  # Convert `geom` column to `sfc` object with British National Grid CRS
  st_as_sf() |>  # Convert the data frame to an `sf` object for spatial operations
  st_transform(crs = 4326) |>  # Transform the coordinates to WGS 84 (latitude/longitude)
  rename(ltla21_name = name)  # Rename the `name` column to `ltla21_name` for consistency

# Define the server function
mapServer <- function(input, output, session) {
  # Reactive value to store the selected region
  selected_region <- reactiveVal(NULL)
  
  # Render the Leaflet map
  output$map <- renderLeaflet({
    leaflet(wales_map) |> 
      addProviderTiles("OpenStreetMap") |> 
      addPolygons(
        fillColor = "blue",
        color = "white",
        weight = 1,
        opacity = 0.7,
        fillOpacity = 0.5,
        layerId = ~ltla21_name,
        label = ~ltla21_name
      )
  })
  
  # Observe click events on the map
  observeEvent(input$map_shape_click, {
    click <- input$map_shape_click
    selected_region(click$id)
  })
  
  # Reset selection
  observeEvent(input$reset_selection, {
    selected_region(NULL)
  })
  
  # Display the selected region
  output$selected_region <- renderText({
    if (is.null(selected_region())) {
      "No region selected"
    } else {
      paste("Selected region:", selected_region())
    }
  })
  
  # Filter data based on the selected region
  output$filtered_data <- renderTable({
    if (is.null(selected_region())) {
      return(NULL)
    }
    
    selected_data <- wales_map |> 
      filter(ltla21_name == selected_region())
    
    # Print to check if the data frame is valid
    print(selected_data)
    
    selected_data |> as.data.frame()
  })
}

