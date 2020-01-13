library(shiny)
library(shinyjs)


grupos <- function() {

  list(
    h2("Gestión de Grupos"),
    h4("Mantenimiento de los grupos en la vida del Flaco"),
  )

}


# Get table metadata. For now, just the fields
# Further development: also define field types
# and create inputs generically
GetTableMetadata <- function() {
  fields <- c(id = "grupo_id",
              name = "nombre"
              )
  result <- list(fields = fields)
  return (result)
}

# Find the next ID of a new record
# (in mysql, this could be done by an incremental index)
GetNextId <- function() {
  if (exists("responses") && nrow(responses) > 0) {
    max(as.integer(rownames(responses))) + 1
  } else {
    return (1)
  }
}

#C
CreateData <- function(data) {

  data <- CastData(data)
  rownames(data) <- GetNextId()
  if (exists("responses")) {
    responses <<- rbind(responses, data)
  } else {
    responses <<- data
  }
}

#R
ReadData <- function() {
  if (exists("responses")) {
    responses
  }
}

#U
UpdateData <- function(data) {
  data <- CastData(data)
  responses[row.names(responses) == row.names(data), ] <<- data
}

#D
DeleteData <- function(data) {
  responses <<- responses[row.names(responses) != unname(data["grupo_id"]), ]
}

# Cast from Inputs to a one-row data.frame
CastData <- function(data) {
  datar <- data.frame(name = data["nombre"],
                      stringsAsFactors = FALSE)

  rownames(datar) <- data["grupo_id"]
  return (datar)
}


# Return an empty, new record
CreateDefaultRecord <- function() {
  mydefault <- CastData(list(grupo_id = "0", nombre = ""))
  return (mydefault)
}

# Fill the input fields with the values of the selected record in the table
UpdateInputs <- function(data, session) {
  updateTextInput(session, "grupo_id", value = unname(rownames(data)))
  updateTextInput(session, "nombre", value = unname(data["nombre"]))
}


ui <- fluidPage(
  #use shiny js to disable the ID field
  shinyjs::useShinyjs(),

  #data table
  DT::dataTableOutput("responses", width = 300),

  #input fields
  tags$hr(),
  shinyjs::disabled(textInput("grupo_id", "grupo_id", "Auto")),
  textInput("nombre", "Nombre", ""),
  #action buttons
  actionButton("submit", "Submit"),
  actionButton("new", "New"),
  actionButton("delete", "Delete")
)


server <- function(input, output, session) {

  # input fields are treated as a group
  formData <- reactive({
    sapply(names(GetTableMetadata()$fields), function(x) input[[x]])
  })

  # Click "Submit" button -> save data
  observeEvent(input$submit, {
    if (input$id != "0") {
      UpdateData(formData())
    } else {
      CreateData(formData())
      UpdateInputs(CreateDefaultRecord(), session)
    }
  }, priority = 1)

  # Press "New" button -> display empty record
  observeEvent(input$new, {
    UpdateInputs(CreateDefaultRecord(), session)
  })

  # Press "Delete" button -> delete from data
  observeEvent(input$delete, {
    DeleteData(formData())
    UpdateInputs(CreateDefaultRecord(), session)
  }, priority = 1)

  # Select row in table -> show details in inputs
  observeEvent(input$responses_rows_selected, {
    if (length(input$responses_rows_selected) > 0) {
      data <- ReadData()[input$responses_rows_selected, ]
      UpdateInputs(data, session)
    }

  })

  # display table
  output$responses <- DT::renderDataTable({
    #update after submit is clicked
    input$submit
    #update after delete is clicked
    input$delete
    ReadData()
  }, server = FALSE, selection = "single",
  colnames = unname(GetTableMetadata()$fields)[-1]
  )

}


# Shiny app with 3 fields that the user can submit data for
shinyApp(ui = ui, server = server)
