#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

ui <- fluidPage(
  # Headings and introduction
  h1("Health composite scores for Wales"),
  compJitterUI("compJitterModule")  # Pass an id argument here
)

