library(shiny)

if (!exists("dtedit")) {
  source("DTedit.R", encoding = "UTF-8")
}

get_grupos <- function() {
  grupos.file <- "grupos.Rda"
  if (file.exists(grupos.file)) {
    t_grupos = readRDS(grupos.file)
  } else {
    t_grupos <- data.frame(grupo_id=numeric(), nombre=character(), stringsAsFactors = FALSE)
  }
  return(t_grupos)
}

tab_grupos <- function() {

  list(
    h2("Gestión de Grupos"),
    h4("Mantenimiento de los grupos en la vida del Flaco"),
    uiOutput('grupos')
  )

}

grupos.setup.ui <- function(input, output) {

  dtedit(input, output,
         name = 'grupos',
         thedata = get_grupos(),
         edit.cols = c('grupo_id', 'nombre'),
         edit.label.cols = c('# Grupo', 'Nombre'),
         view.cols = c('grupo_id', 'nombre'),
         input.types = c(grupo_id='numericInput', nombre='textInput'),
         callback.update = grupos.update.callback,
         callback.insert = grupos.insert.callback,
         callback.delete = grupos.delete.callback,
         callback.validate = grupos.validate)
}

grupos.validate <- function(operation, olddata, data, row){

  errores_or_warnings <- data.frame(warning=logical(0), msg=character(0), stringsAsFactors = FALSE)

  if (is.null(data$nombre[row]) | data$nombre[row]=="") {
    errores_or_warnings <- rbind(errores_or_warnings, list(warning = FALSE, msg="Debe ingresar un nombre de grupo"))
  }
  print(data$grupo_id[row])
  if (data$grupo_id[row] < 1 ) {
    errores_or_warnings <- rbind(errores_or_warnings, list(warning = TRUE, msg="El grupo_id es inválido"))
  }

  return(errores_or_warnings)
}

grupos.insert.callback <- function(data, row) {
  t_grupos <- data
  saveRDS(t_grupos, grupos.file)
  return(t_grupos)
}

grupos.update.callback <- function(data, olddata, row) {
  t_grupos <- data
  return(t_grupos)
}

grupos.delete.callback <- function(data, row) {
  t_grupos <- t_grupos[-row,]
  return(t_grupos)
}
