function(input, output, session) {
  
  callModule(map, "map")
  
  shinyjs::hide(id = "loading-content", anim = TRUE, animType = "fade", time = 2)
  # shinyjs::show(id = "app-content")
}

