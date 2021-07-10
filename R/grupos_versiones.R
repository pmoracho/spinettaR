library(shiny)
# To do
# 1. Inicialización de datos
# 2. Personalizar interface traducir
# 3. Validar si el id ya existe

grupos_versiones.file <- "../data/grupos_versiones.Rda"
if (!exists("dtedit")) {
  source("DTedit.R", encoding = "UTF-8")
}

get_grupos_versiones <- function() {

  if (file.exists(grupos_versiones.file)) {
    t_grupos_versiones = readRDS(grupos_versiones.file)
  } else {
    t_grupos_versiones <- data.frame(grupo_version_id=numeric(),
                                     grupo_id = numeric(),
                                     version_numero = numeric(),
                                     comentario=character(), stringsAsFactors = FALSE)
  }
  return(t_grupos_versiones)
}

tab_grupos_versiones <- function() {

  list(
    h2("Gestión de Grupos"),
    h4("Mantenimiento de las versiones de cada grupo"),
    uiOutput('grupos_versiones')
  )

}

grupos_versiones.setup.ui <- function(input, output) {

  dtedit(input, output,
         name = 'grupos_versiones',
         thedata = get_grupos_versiones(),
         edit.cols = c('grupo_id', 'version_numero', 'comentario'),
         edit.label.cols = c('# Grupo', '# Versión', 'Comentario'),
         view.cols = c('grupo_version_id', 'grupo_id', 'version_numero', 'comentario'),
         input.choices = list(grupo_id = c('Los Larkings', 'Almendra')),
         input.types = c(grupo_id='selectInput',
                         version_numero='numericInput',
                         comentario='textInput'),
         callback.update = grupos_versiones.update.callback,
         callback.insert = grupos_versiones.insert.callback,
         callback.delete = grupos_versiones.delete.callback,
         callback.validate = grupos_versiones.validate)
}

grupos_versiones.validate <- function(operation, olddata, data, row){

  errores_or_warnings <- data.frame(warning=logical(0), msg=character(0), stringsAsFactors = FALSE)

  if (is.null(data$comentario[row]) | data$comentario[row]=="") {
    errores_or_warnings <- rbind(errores_or_warnings, data.frame(warning = FALSE, msg="Debe ingresar un nombre de grupo"))
  }
  if (data$grupo_id[row] < 1 ) {
    errores_or_warnings <- rbind(errores_or_warnings, data.frame(warning = TRUE, msg="El grupo_id es inválido"))
  }

  return(errores_or_warnings)
}

grupos_versiones.insert.callback <- function(data, row) {
  t_grupos_versiones <- data
  saveRDS(t_grupos_versiones, grupos_versiones.file)
  return(t_grupos_versiones)
}

grupos_versiones.update.callback <- function(data, olddata, row) {
  t_grupos_versiones <- data
  return(t_grupos_versiones)
}

grupos_versiones.delete.callback <- function(data, row) {
  t_grupos_versiones <- t_grupos_versiones[-row,]
  return(t_grupos_versiones)
}
