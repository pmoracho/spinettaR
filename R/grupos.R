library(shiny)
# To do
# 1. Inicialización de datos
# 2. Personalizar interface traducir
# 3. Validar si el id ya existe

grupos.file <- "../data/grupos.Rda"
if (!exists("dtedit")) {
  source("DTedit.R", encoding = "UTF-8")
}

get_grupos <- function() {

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
         edit.cols = c('nombre'),
         edit.label.cols = c('Nombre'),
         view.cols = c('grupo_id', 'nombre'),
         input.types = c( nombre='textInput'),
         callback.update = grupos.update.callback,
         callback.insert = grupos.insert.callback,
         callback.delete = grupos.delete.callback,
         callback.validate = grupos.validate)
}

grupos.validate <- function(operation, olddata, data, row){

  errores_or_warnings <- data.frame(warning=logical(0), msg=character(0), stringsAsFactors = FALSE)

  if (is.null(data$nombre[row]) | data$nombre[row]=="") {
    errores_or_warnings <- rbind(errores_or_warnings, data.frame(warning = FALSE, msg="Debe ingresar un nombre de grupo"))
  }
  # if (data$grupo_id[row] < 1 ) {
  #   errores_or_warnings <- rbind(errores_or_warnings, data.frame(warning = TRUE, msg="El grupo_id es inválido"))
  # }
  if (data$grupo_id[row] %in% data$grupo_id[-row] ) {
    errores_or_warnings <- rbind(errores_or_warnings, data.frame(warning = TRUE, msg="El grupo_id ya existe"))
  }

  return(errores_or_warnings)
}

grupos.insert.callback <- function(data, row) {
  data[row,"grupo_id"] <- max(data$grupo_id) + 1
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
