mapUI <- function(id, label = 'map') {
  ns <- NS(id)
  
  fluidRow(
    # The leaflet option
    absolutePanel(top = 0, left = 0, right = 0, bottom = 0, height = 'auto',
                  leafletOutput(ns('map'))),
                  # verbatimTextOutput("value")#,
    # The main menu panel
    shinyWidgets::setSliderColor("BurlyWood", sliderId = 1),
    absolutePanel(bottom = 10, left = 30, draggable = F, width = "80%",
                  # The date input box
                  h1(paste0("Date: ", date_menu_choice))#
                  # shinyWidgets::sliderTextInput(
                  #   inputId = ns("date_choice"),
                  #   label = NULL,
                  #   grid = TRUE, 
                  #   force_edges = TRUE,
                  #   choices = seq(date_menu_choice-4, date_menu_choice, by = "day"), 
                  #   selected = date_menu_choice-4, 
                  #   animate = animationOptions(interval = 5000),
                  #   width = "80%"
                  )
                  # dateInput(inputId = ns("date_choice"),
                  #           label = "Date",
                  #           value = date_menu_choice,
                  #           min = "1982-01-01", 
                  #           max = max(current_dates))
                  # The shiny server instance info
                  # h5(paste0("Shiny server instance: ",Sys.getenv("R_SHNYSRVINST"))),
    # )#,
    # tags$script("$(document).ready(function(){
    #                     setTimeout(function() {$('.slider-animate-button').click()},2000);
    #                 });")
  )
}
# cat("\nmap_ui.R finished")

