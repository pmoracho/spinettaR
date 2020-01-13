personas <- function() {

  list(
    h2("Gestión de Personas"),
    h4("Mantenimiento de los nombres de personas en la vida del Flaco"),
    DT::dataTableOutput("personas")
  )

}


