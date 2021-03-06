library(shiny)
library(shinydashboard)

source("personas.R", encoding = "UTF-8")
source("grupos.R", encoding = "UTF-8")
source("grupos_versiones.R", encoding = "UTF-8")

header <- dashboardHeader(title = "Spinetta App", titleWidth = 230)

sidebar <- dashboardSidebar(
  width  = 230,
  sidebarMenu(
    id = "tabs",
    text = "app",
    menuItem("Analisis", icon = icon("chart-bar"),
             menuSubItem("Red", tabName = "Red", icon = icon("project-diagram"))
    ),
    menuItem("Tablas", icon = icon("table"),
             menuSubItem("Personas", tabName = "Personas", icon = icon("table")),
             menuSubItem("Grupos", tabName = "Grupos", icon = icon("table")),
             menuSubItem("Grupos/Versiones", tabName = "Grupos_Versiones", icon = icon("table")),
             menuSubItem("Obras", tabName = "Obras", icon = icon("table")),
             menuSubItem("Personas/Grupos/Versiones", tabName = "Personas_Grupos_Versiones", icon = icon("table"))
    )
  )
)

body <- dashboardBody(
  tabItems(
    tabItem("Personas",tab_personas()),
    tabItem("Grupos",tab_grupos()),
    tabItem("Grupos_Versiones",tab_grupos_versiones()),
    tabItem("Personas_Grupos_Versiones","Personas por cada Versión de cada Grupo"),
    tabItem("Obras","Obras")
  )
)

shinyApp(
  ui = dashboardPage(header, sidebar, body),
  server = function(input, output) {

    grupos.setup.ui(input, output)
    personas.setup.ui(input, output)
    grupos_versiones.setup.ui(input, output)

  }
)

