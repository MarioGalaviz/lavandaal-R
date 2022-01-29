library(shiny)
library(shinythemes)
library(DBI)
library(lubridate)
library(dplyr)
library(ggplot2)
library(magrittr)
library(plotly)
source("./Main.R")
source("./.Rprofile")


# rsconnect::setAccountInfo(name='mariogalaviz',
#                           token=token.shiny,
#                           secret=secret.shiny)

ui <- fluidPage(
  theme = shinytheme('lumen'),
  tags$h1('Métricas Lavandaal'),
  tags$h2('Volumen de negocio'),
  tags$h3('Tabla de órdenes por día'),
  'Fuente: BD',
  plotlyOutput('tablaOrdenes'),
  tags$h3('Tabla de valor de órdenes por día'),
  'Fuente: BD',
  plotlyOutput('tablaIngresos'),
  tags$h2('Engagement'),
  tags$h3('Tabla de actualizaciones promedio por orden'),
  'Fuente: BD',
  plotlyOutput('tablaActualizaciones'),
  tags$h3('Tabla de % ordenes con calificaciones'),
  'Fuente: BD',
  plotlyOutput('tablaCalificaciones'),
  tags$h3('Tabla de duración de sesión'),
  'Fuente: GA',
  plotlyOutput('graficaDuracion'),
  tags$h3('Visitas a diferentes páginas'),
  'Fuente: GA',
  plotlyOutput('graficaPageviews')
)

server <- function(input, output) {
  output$tablaOrdenes <- renderPlotly({
    tabla.ordenes
  })
  output$tablaActualizaciones <- renderPlotly({
    tabla.actualizaciones
  })
  output$tablaCalificaciones <- renderPlotly({
    tabla.calificaciones
  })
  output$tablaIngresos <- renderPlotly({
    tabla.ingresos
  })
  output$graficaDuracion <- renderPlotly({
    plot.duracionSesion
  })
  output$graficaPageviews <- renderPlotly({
    plot.pageViews
  })
}

shinyApp(server = server, ui = ui)