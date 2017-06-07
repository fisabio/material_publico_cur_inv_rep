#----------------------------------#
#  App Shiny - Privación Valencia  #
#----------------------------------#
# Proyecto: App Shiny - Curso IR   #
# Nombre:    ui.R                  #
# Autor:     Hèctor Perpiñán       #
#----------------------------------#

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


#--------------------------
#--- Definición del UI ----
shinyUI(

  navbarPage("Curso de Investigación Reproducible: Práctica 3 (Shiny)",

             tabPanel("INICIO",
                      column(width = 9, offset = 1, wellPanel(title = "Práctica 3", width = 6, h5("La ", strong("privación material"), " es un concepto sociológico que se corresponde con la ", em("'falta de bienes, servicios, recursos y comodidades que son habituales, o están ampliamente extendidos, en una sociedad determinada'"), ". Un problema habitual a la hora de estudiar este concepto es que la privación no puede ser medida directamente y, por tanto, tiene que ser medida de forma indirecta a partir de otras variables que sean reflejo de la presencia o ausencia de este concepto en la población."),
                                                              h5("En el archivo de datos ", strong(em("`datos_practicas.RData`")), " encontrarás el banco de datos ", strong(em("`privacion_valencia`")), " y el objeto espacial ", strong(em("`carto_valencia`")), " con la cartografía de la ciudad de Valencia. El banco de datos ", strong(em("`privacion_valencia`")), " contiene una serie de indicadores sociales para las 598 secciones censales de la ciudad de Valencia. Estos indicadores son en este orden: desempleo, instrucción insuficiente, instrucción insuficiente en jóvenes (16-29 años), trabajadores manuales, envejecimiento, trabajadores eventuales, residentes extranjeros, hogares mono-parentales, problemas de ruido, problemas de contaminación, problemas de limpieza, problemas de comunicación, problemas de zonas verdes, problemas de delincuencia y problemas de aseo. Todas las variables han sido medidas como el porcentaje de población (en cada sección) que pertenece a estos colectivos o que dice observar dichos problemas. Todos estos indicadores podrían ser reflejo de la privación económica de cada una de las secciones censales de la ciudad de Valencia."), br(),

                                                              h4("PRÁCTICA"),
                                                              h5("Realizar una aplicación Shiny con 3 pestañas ('INICIO', 'DESCRIPTIVO', 'ÍNDICE DE PRIVACIÓN'). La estructura interna de cada pestaña la debéis determinar vosotros, está supeditada al contenido de cada una de ellas y a como decidáis organizar la información."),
                                                              h5(strong("Contenido:")),
                                                              h5("1. Pestaña INICIO"),
                                                              h5("Describe brévemente el objetivo de la aplicación e indica la información que consideres necesaria para que los usuarios la puedan utilizar. Para ello debes introducir texto, realizando la maquetación con ", em("código HTML"), "."),
                                                              h5("2. Pestaña DESCRIPTIVO"),
                                                              h5("En la parte superior de la página mostraremos un selector que nos permitirá elegir entre las variables del banco de datos. Una vez seleccionada una variable del banco de datos por el usuario, se mostrará un descriptivo numérico básico de la variable (", strong(em("summary")), " y un histograma (", strong(em("hist")), "). "),
                                                              h5("3. Pestaña ÍNDICE DE PRIVACIÓN"),
                                                              h5("En esta pestaña se debe mostrar, a partir de la información disponible en el banco de datos ", strong(em("privacion_valencia")), ", el índice de privación que hemos trabajado en las prácticas anteriores. Recordad que este índice cuantifica el índice de privación en cada sección censal de la ciudad de Valencia. El índice de privación (análisis de componentes principales) se realizará con todas las variables del banco de datos `privacion_valencia`, y mostraremos Tablas, Gráficos, ... (ver enunciado práctica).")

                                                              )
                      )
            ),

             tabPanel("DESCRIPTIVO",
                      wellPanel(selectInput(inputId = "var", label = "Variable de interés para su descripción individual:", choices = list("1. Sección censal" = 1, "2. Desempleo" = 2, "3. Instrucción insuficiente" = 3, "4. Instrucción insuficiente en jóvenes" = 4, "5. Trabajadores manuales" = 5, "6. Envejecimiento" = 6, "7. Trabajadores eventuales" = 7, "8. Residentes extranjeros" = 8, "9. Hogares mono-parentales" = 9, "10. Problemas de ruido" = 10, "11. Problemas de contaminación" = 11, "12. Problemas de limpieza" = 12, "13. Problemas de comunicación" = 13, "14. Problemas de zonas verdes" = 14, "15. Problemas de delincuencia" = 15, "16. Problemas de aseo" = 16), selected = 1)),
                      h3(strong("Resumen de la variable seleccionada")),
                      dataTableOutput("privacion_valencia_summary"),
                      br(),
                      h3(strong("Histograma de la variable seleccionada")),
                      plotlyOutput("privacion_valencia_hist")),
             navbarMenu("ÍNDICE DE PRIVACIÓN",
                        tabPanel("TABLAS",
                                 wellPanel(h2(strong("RESUMEN NUMÉRICO DEL ÍNDICE DE PRIVACIÓN EN LA CIUDAD DE VALENCIA")), wellPanel(style = "background-color: #6495ED; color: #fff;", h4("Defina las siguientes variables:"), numericInput("n", label = h5("Número de componentes principales de interés:"), value = 5, min = 1, max = 15, step = 1)), h3("Resumen del análisis de componentes principales"), dataTableOutput("tablaACP_summary"), br(), h3("Peso de las variables originales en las componentes principales"), dataTableOutput("tablaACP_loadings"))),

                        tabPanel("MAPAS",
                                 wellPanel(fluidRow(selectizeInput(inputId = "cp_elegida", label = h5("Componente principal a mapear:"), choices = list("Componente principal 1" = 1, "Componente principal 2" = 2, "Componente principal 3" = 3, "Componente principal 4" = 4, "Componente principal 5" = 5, "Componente principal 6" = 6, "Componente principal 7" = 7, "Componente principal 8" = 8, "Componente principal 9" = 9, "Componente principal 10" = 10, "Componente principal 11" = 11, "Componente principal 12" = 12, "Componente principal 13" = 13, "Componente principal 14" = 14, "Componente principal 15" = 15), multiple = FALSE, options = list(create = FALSE), selected = 1)),
                                           fluidRow(column(width = 3, sliderInput("n_grupos", label = h5("Número de grupos"), min = 4, max = 8, value = 5, step = 2)), column(width = 4, offset = 1, selectInput("col_paleta", label = "Paleta de color:", choice = list("BrBG" = "BrBG", "PiYG" = "PiYG", "PRGn" = "PRGn", "PuOr" = "PuOr", "RdBu" = "RdBu", "RdGy" = "RdGy", "RdYlBu" = "RdYlBu", "RdYlGr" = "RdYlGr", "Spectral" = "Spectral"), selected = "BrBG"))),
                                           splitLayout(cellWidths = c("50%", "50%"),
                                             plotOutput("mapa"),
                                             leafletOutput("mapaLeaflet"))

                                                     )
                      )
             )
  )


)
