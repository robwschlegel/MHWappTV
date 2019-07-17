ui = tagList(shinyjs::useShinyjs(),  
             tags$head(includeCSS("style.css")),
             # Loading message
             div(
               id = "loading-content",
               h2("Loading...")
             ),
             # hidden(
               # div(
                 # id = "app-content",
             navbarPage(title =  "Marine Heatwave Tracker", 
                        selected = 'Map',
                        tabPanel(title = 'Map',
                                 br(),
                                 mapUI('map')),
                        header = tags$head(tags$style(type = 'text/css', ".irs-grid-text { font-size: 20pt; color: black}"),
                                           tags$style(type = 'text/css', ".irs-text { font-size: 20pt; }")))
               # )
             # )
)
## NB: Consider shifting css file chosen based on app window width