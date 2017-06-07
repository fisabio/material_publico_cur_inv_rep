#----------------------------------#
#  App Shiny - Privación Valencia  #
#----------------------------------#
# Proyecto: App Shiny - Curso IR   #
# Nombre:    server.R              #
# Autor:     Hèctor Perpiñán       #
#----------------------------------#
rm(list=ls())
#setwd("~/Documents/Treball/FISABIO/2017-Inv_Rep/curso_inv_rep/practica_03_shiny/privacion_valencia/")

#------------------
#--- librerias ----
library(shiny)
library(sp)
library(rgdal)
library(RColorBrewer)
library(leaflet)
library(DT)
library(ggplot2)
library(plotly)

#-------------------------------------
#--- Archivos y Cargas auxiliares ----
load("datos/datos_practicas.RData")
carto_valencia <- spTransform(carto_valencia, CRS("+proj=longlat +datum=WGS84"))

#-------------------------
#--- Cálculos previos ----
# Análisis de componentes principales (ACP)
ACP <- princomp(privacion_valencia[, 2:16])

## Construcción de las componentes principales (CP)
Ind_privacion <- list()

for (i in 1:15){
  Ind_privacion[[i]] <- as.matrix(privacion_valencia[, 2:16]) %*% ACP$loadings[, i]
}

#--------------------------
#--- Inicio del SERVER ----
shinyServer(function(input, output) {

  # Tabla dinámica con el summary de la variable seleccionada (input$var)
  output$privacion_valencia_summary <- renderDataTable({

    minimo <- min(privacion_valencia[, as.numeric(input$var)])
    primerQ  <- quantile(privacion_valencia[, as.numeric(input$var)], probs = 0.25)
    mediana <- median(privacion_valencia[, as.numeric(input$var)])
    media <- mean(privacion_valencia[, as.numeric(input$var)])
    tercerQ <- quantile(privacion_valencia[, as.numeric(input$var)], probs = 0.75)
    maximo <- max(privacion_valencia[, as.numeric(input$var)])

    resumen <- c(minimo, primerQ, mediana, media, tercerQ, maximo)

    df <- data.frame(resumen)
    rownames(df) <- c("Mínimo", "1er cuartil", "Mediana", "Media", "3er cuartil", "Máximo")
    datatable(df, rownames = TRUE, options = list(digits = 3)) %>% formatRound(columns = c('resumen'), digits=3)

  })


  # Histograma interactivo de la variable seleccionada (input$var)
  output$privacion_valencia_hist <- renderPlotly({

    df <- data.frame(var = privacion_valencia[, as.numeric(input$var)])
    nombre_var <- c("Sección censal", "Desempleo", "Instrucción insuficiente", "Instrucción insuficiente en jóvenes (16-29 años)", "trabajadores manuales", "Envejecimiento", "Trabajadores eventuales", "Residentes extranjeros", "Hogares mono-parentales", "Problemas de ruido", "Problemas de contaminación", "Problemas de limpieza", "Problemas de comunicación", "Problemas de zonas verdes", "Problemas de delincuencia", "Problemas de aseo")[as.numeric(input$var)]

    ggplotly(ggplot(df, aes(x = var)) + geom_histogram(colour = "yellow") + labs(x = nombre_var, y = ""))

  })


  # Tabla dinámica con el resumen del ACP
  output$tablaACP_summary <- renderDataTable({

    ## Resumen del análisis
    standard_dev <- ACP$sdev
    prop_variance <- (ACP$sdev ^ 2) / sum(ACP$sdev ^ 2)
    cumulative_prop <- cumsum(prop_variance)

    df <- data.frame(standard_dev, prop_variance, cumulative_prop)[1:input$n,]

    tab_summary <- round(df, digits = 3)
    datatable(tab_summary, colnames = c("Desviación estandar", "Proporción de varianza explicada", "Varianza acumulada"), options = list(pageLength = 5, dom = 'tip', autoWidth = TRUE, language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json')))

  })


  # Tabla dinámica con el peso de las variables originales en las CP
  output$tablaACP_loadings <- renderDataTable({

    ## Peso de las variables originales en las CP
    tab_loadings <- round(matrix(data = as.numeric(ACP$loadings[, 1:input$n]), nrow = 15, ncol = input$n, byrow = FALSE), digits = 3)
    datatable(tab_loadings, rownames = rownames(ACP$loadings), colnames = colnames(ACP$loadings[, 1:input$n]), options = list(autowith = TRUE, scrollX = TRUE, pageLength = 15, lengthMenu = c(5, 10, 15), language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json'), initComplete = JS("function(settings, json) {", "$(this.api().table().header()).css({'background-color': '#6495ED', 'color': '#fff'});","}")))

  })


  # Función pinta_mapas
  pinta_mapas <- function(cartografia, variable, n_grupos, col_paleta){

    paleta <- brewer.pal(n_grupos, col_paleta)
    grupos <- quantile(variable, probs = seq(0, 1, 1 / n_grupos))
    pcorte <- as.numeric(c(grupos[1] - 0.5, grupos[2:n_grupos], grupos[n_grupos + 1] + 0.5))

    leyenda <- c()
    for (j in 2:length(pcorte)){
      leyenda[j] <- paste0(round(pcorte[j - 1], 2), " - ", round(pcorte[j], 2))
    }

    color <- paleta[findInterval(variable[match(cartografia@data$CUSEC, privacion_valencia[, 1])], sort(pcorte))]

    plot(cartografia, col = color)
    legend("bottomright", leyenda[-1], title = "Índice de privación", border = NULL, fill = paleta, bty = "n")

  }


  # Mapa estático
  output$mapa <- renderPlot({

    pinta_mapas(carto_valencia, Ind_privacion[[as.numeric(input$cp_elegida)]], as.numeric(input$n_grupos), input$col_paleta)

  })


  # Función pinta_mapas adaptada a leaflet
  pinta_mapas_lealfet <- function(cartografia, variable, n_grupos, col_paleta){

    paleta <- brewer.pal(n_grupos, col_paleta)
    grupos <- quantile(variable, probs = seq(0, 1, 1 / n_grupos))
    pcorte <- as.numeric(c(grupos[1] - 0.5, grupos[2:n_grupos], grupos[n_grupos + 1] + 0.5))

    color <- paleta[findInterval(variable[match(cartografia@data$CUSEC, privacion_valencia[, 1])], sort(pcorte))]

    mb_tiles <- 'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png'
    mb_attribution <- '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'

    leaflet(data = cartografia) %>% addPolygons(fillColor = color, fillOpacity = 0.8, color = "#000000", weight = 1) %>% addTiles(urlTemplate = mb_tiles, attribution = mb_attribution)

  }


  # Mapa interactivo
  output$mapaLeaflet <- renderLeaflet({

    pinta_mapas_lealfet(carto_valencia, Ind_privacion[[as.numeric(input$cp_elegida)]], as.numeric(input$n_grupos), input$col_paleta)

  })

})
