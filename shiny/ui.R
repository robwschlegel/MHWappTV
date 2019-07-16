ui = tagList(shinyjs::useShinyjs(),  
             tags$head(includeScript("google-analytics.js"),
                       includeCSS("style.css")),
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
                        tabPanel(title = 'About',
                                 br(),
                                 aboutUI('about')))
               # )
             # )
)
## NB: Consider shifting css file chosen based on app window width