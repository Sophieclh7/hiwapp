pkgload::load_all(".") #Reads everything in hiwapp folder, run to test app
shinyApp(ui = ui, server = server)

