library(shiny)

if(!'_gruposdb' %in% ls()) {
  #books <- read.csv('books.csv', stringsAsFactors = FALSE)
  T_gruposdb <- data.frame(grupo_id=c(1), nombre=c('Bundleman'), stringsAsFactors = FALSE)
}

get_grupos <- function(){
  T_gruposdb
}

grupos <- function() {


  list(
    h2("Gestión de Grupos"),
    h4("Mantenimiento de los grupos en la vida del Flaco"),
    uiOutput('grupos')
  )


}

grupos.setup.ui <- function(input, output) {

  gruposdb <- get_grupos()
  DTedit::dtedit(input, output,
                 name = 'grupos',
                 thedata = gruposdb,
                 edit.cols = c('grupo_id', 'nombre'),
                 edit.label.cols = c('# Grupo', 'Nombre'),
                 view.cols = c('grupo_id', 'nombre'),
                 input.types = c(grupo_id='numericInput', nombre='textInput'),
                 callback.update = grupos.update.callback,
                 callback.insert = grupos.insert.callback,
                 callback.delete = grupos.delete.callback)

}


grupos.insert.callback <- function(data, row) {
  T_gruposdb <- rbind(data, T_gruposdb)
  return(get_grupos())
}

grupos.update.callback <- function(data, olddata, row) {
  T_gruposdb[row,] <- data[1,]
  return(get_grupos())
}

grupos.delete.callback <- function(data, row) {
  T_gruposdb[row,] <- NULL
  return(get_grupos())
}


