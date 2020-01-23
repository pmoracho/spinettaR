
validation <- function(condition, warning = FALSE, msg = NA){
  list(expr = substitute(condition),
       warn = warning,
       msg = msg)
}

validate_all <- function(condition_list, data, row) {
  result <- list()
  for (cond in condition_list) {
    if(eval(cond$expr, data[row, ], enclos = parent.frame())) {
      result[[length(result) + 1]] <- data.frame(warn=cond$warn, msg=cond$msg)
    }
  }
  do.call(rbind, result)
}

conditions <- list()
conditions[[1]] <- validation(mpg>17, msg = "Millas mayores a 17")
conditions[[2]] <- validation(cyl==4, msg = "4 cilindros")

validate_all(conditions, data=mtcars, row=2)

# conditions

