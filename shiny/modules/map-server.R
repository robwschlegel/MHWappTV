map <- function(input, output, session) {
  ns <- session$ns
  
  # testers...
  # xy <- c(-42.125, 39.875)
  # x <- -42.125
  # y <- 39.875
  # input <- data.frame(from = as.Date("2018-01-01"),
  #                     to = as.Date("2018-12-31"),
  #                     date_choice = as.Date("2018-02-14"),
  #                     pixel = "Smooth")
  #                     #categories = c("I Moderate", "II Strong", "III Severe", "IV Extreme"))
  
  
# Reactive UI features ----------------------------------------------------
  
  ### Reactive category filters
  categories <- reactiveValues(categories = c("I Moderate", "II Strong", "III Severe", "IV Extreme"))
  
  
# Map projection data -----------------------------------------------------
  
  ### Base map data before screening categories
  baseDataPre <- reactive({
    date_filter <- input$date_choice
    year_filter <- lubridate::year(date_filter)
    sub_dir <- paste0("cat_clim/",year_filter)
    sub_file <- paste0(sub_dir,"/cat.clim.",date_filter,".Rda")
    if(file.exists(sub_file)){
      baseDataPre <- readRDS(sub_file)
    } else {
      baseDataPre <- readRDS("cat_clim/1982/cat.clim.1982-01-01.Rda") %>% 
        slice(1) %>% 
        mutate(category = NA)
    }
    return(baseDataPre)
  })
  
  ### Base map data after screening categories
  baseData <- reactive({
    baseDataPre <- baseDataPre()
    baseData <- baseDataPre %>%
      filter(category %in% categories$categories)
    # Fix for the issue caused by de-slecting all of the cateogries
    if(length(baseData$category) == 0){
      baseData <- readRDS("cat_clim/1982/cat.clim.1982-01-01.Rda") %>% 
        slice(1) %>% 
        mutate(category = NA)
    }
    return(baseData)
  })
  
  ### Non-shiny-projected raster data
  rasterNonProj <- reactive({
    baseData <- baseData()
    MHW_raster <- baseData %>%
      dplyr::select(lon, lat, category)
    colnames(MHW_raster) <- c("X", "Y", "Z")
    MHW_raster$Z <- as.numeric(MHW_raster$Z)
    rasterNonProj <- raster::rasterFromXYZ(MHW_raster, res = c(0.25, 0.25),
                                           digits = 3, crs = inputProj)
    # res_list <- list(MHW_raster = MHW_raster,
    #                  rasterNonProj = rasterNonProj)
    return(rasterNonProj)
  })
  
  ### Shiny-projected raster data
  rasterProj <- reactive({
    rasterNonProj <- rasterNonProj()
    # if(input$pixels == "Smooth"){
    # rasterProj <- projectRasterForLeaflet(rasterNonProj, method = "bilinear")
    # } else {
    rasterProj <- projectRasterForLeaflet(rasterNonProj, method = "ngb")
    # }
    return(rasterProj)
  })
  
  
# Leaflet -----------------------------------------------------------------
  
  ### The leaflet base
  output$map <- renderLeaflet({
    leaflet(MHW_cat_clim_sub, options = leafletOptions(zoomControl = FALSE)) %>%
      setView(initial_lon, initial_lat, zoom = initial_zoom,
              options = tileOptions(minZoom = 0, maxZoom = 8, noWrap = F)) %>%
      # Different tile options
      addTiles(group = "OSM (default)", 
               options = tileOptions(minZoom = 0, maxZoom = 8, opacity = 0.5, noWrap = F)) %>%
      addScaleBar(position = "bottomright")
  })
  
  ### The raster layer
  observe({
    leafletProxy("map") %>%
      clearImages() %>% clearPopups() %>%
      addRasterImage(rasterProj(), colors = pal_cat, layerId = "map_raster",
                     project = FALSE, opacity = 0.7)
  })
  
  ### Legend that can be de-activated by the user
  observe({
    proxy <- leafletProxy("map", data = MHW_cat_clim_sub)
    proxy %>% clearControls()
    # if (input$legend) {
      proxy %>% addLegend(position = "bottomright",
                          pal = pal_factor,
                          values = ~category,
                          title = "Category",
                          opacity = 0.75
      )
    # }
  })
}
# cat("\nmap_server.R finished")

