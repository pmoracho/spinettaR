require(shiny)

personas.file <- "../data/personas.Rda"
if (!exists("dtedit")) {
  source("DTedit.R", encoding = "UTF-8")
}

get_personas <- function() {

  if (file.exists(personas.file)) {
    t_personas = readRDS(personas.file)
  } else {
    t_personas <- data.frame(persona_id=numeric(), nombre=character(), stringsAsFactors = FALSE)
  }
  return(t_personas)
}

tab_personas <- function() {

  list(
    h2("Gestión de personas"),
    h4("Mantenimiento de los nombres de personas en la vida del Flaco"),
    uiOutput('personas')
  )

}

personas.setup.ui <- function(input, output) {

  dtedit(input, output,
         name = 'personas',
         thedata = get_personas(),
         edit.cols = c('persona_id', 'nombre'),
         edit.label.cols = c('# persona', 'Nombre'),
         view.cols = c('persona_id', 'nombre'),
         input.types = c(persona_id='numericInput', nombre='textInput'),
         callback.update = personas.update.callback,
         callback.insert = personas.insert.callback,
         callback.delete = personas.delete.callback,
         callback.validate = personas.validate)
}

personas.validate <- function(operation, olddata, data, row){

  errores_or_warnings <- data.frame(warning=logical(0), msg=character(0), stringsAsFactors = FALSE)

  if (is.null(data$nombre[row]) | data$nombre[row]=="") {
    errores_or_warnings <- rbind(errores_or_warnings, data.frame(warning = FALSE, msg="Debe ingresar un nombre de persona"))
  }
  if (data$persona_id[row] < 1 ) {
    errores_or_warnings <- rbind(errores_or_warnings, data.frame(warning = TRUE, msg="El persona_id es inválido"))
  }
  if (data$persona_id[row] %in% data$persona_id[-row] ) {
    errores_or_warnings <- rbind(errores_or_warnings, data.frame(warning = TRUE, msg="El persona_id ya existe"))
  }

  return(errores_or_warnings)
}

personas.insert.callback <- function(data, row) {
  t_personas <- data
  saveRDS(t_personas, personas.file)
  return(t_personas)
}

personas.update.callback <- function(data, olddata, row) {
  t_personas <- data
  return(t_personas)
}

personas.delete.callback <- function(data, row) {
  t_personas <- t_personas[-row,]
  return(t_personas)
}
