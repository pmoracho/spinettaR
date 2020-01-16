library(shiny)

source("DTedit.R", encoding = "UTF-8")

if(!'t_grupos' %in% ls()) {
  #books <- read.csv('books.csv', stringsAsFactors = FALSE)
  t_grupos <- data.frame(grupo_id=numeric(), nombre=character(), stringsAsFactors = FALSE)
}

get_grupos <- function(){
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
         callback.delete = grupos.delete.callback)
}


grupos.insert.callback <- function(data, row) {
  errores <- ""

  print(data$nombre[row])
  print(data$id[row])
  if (data$nombre[row]=="") {errores <- c(errores, "Debe ingresar un nombre de grupo")}
  if (is.null(data$id[row])) {errores <- c(errores, "El <id> del grupo es inválido")}
  print(errores)
  if (length(errores)!=0) {
    errores <- c("Errores al insertar el grupo:", "", errores)
    showNotification(paste0(errores,collapse="\n"), type="error")
  } else {
    t_grupos <- data
  }
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


