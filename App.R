library(shiny)
library(shinythemes)
library(DBI)
library(lubridate)
library(dplyr)
library(ggplot2)
library(magrittr)
source("~/Main.R")

ui <- fluidPage(
  sliderInput(
    inputId = 'num',
    label = 'holi',
    value = 27, min = 1, max = 50
  )
)

server <- function(input, output) {
  theme = shinytheme('lumen')
  titlePanel('Métricas Lavandaal')
  sidebarLayout(
    sidebarPanel(),
    mainPanel(),
  )
  
}

shinyApp(server = server, ui = ui)