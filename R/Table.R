#' Convenience functions for reading/writing DBMS tables
#'
#' @param conn a \code{\linkS4class{OdbconnectConnection}} object, produced by
#'   \code{\link[DBI]{dbConnect}}
#' @param name a character string specifying a table name. Names will be
#'   automatically quoted so you can use any sequence of characaters, not
#'   just any valid bare table name.
#' @param value A data.frame to write to the database.
#' @inheritParams DBI::sqlCreateTable
#' @param copy If \code{TRUE}, serializes the data frame to a single string
#'   and uses \code{COPY name FROM stdin}. This is fast, but not supported by
#'   all postgres servers (e.g. Amazon's redshift). If \code{FALSE}, generates
#'   a single SQL string. This is slower, but always supported.
#'
#' @examples
#' \dontrun{
#' library(DBI)
#' con <- dbConnect(odbconnect::odbconnect())
#' dbListTables(con)
#' dbWriteTable(con, "mtcars", mtcars, temporary = TRUE)
#' dbReadTable(con, "mtcars")
#'
#' dbListTables(con)
#' dbExistsTable(con, "mtcars")
#'
#' # A zero row data frame just creates a table definition.
#' dbWriteTable(con, "mtcars2", mtcars[0, ], temporary = TRUE)
#' dbReadTable(con, "mtcars2")
#'
#' dbDisconnect(con)
#' }
#' @name odbconnect-tables
NULL

#' @rdname odbconnect-tables
#' @inheritParams DBI::dbWriteTable
#' @param overwrite Allow overwriting the destination table. Cannot be
#'   \code{TRUE} if \code{append} is also \code{TRUE}.
#' @param append Allow appending to the destination table. Cannot be
#'   \code{TRUE} if \code{overwrite} is also \code{TRUE}.
#' @export
setMethod(
  "dbWriteTable", c("OdbconnectConnection", "character", "data.frame"),
  function(conn, name, value, overwrite=FALSE, append=FALSE, ...) {

    if (overwrite && append)
      stop("overwrite and append cannot both be TRUE", call. = FALSE)

    found <- dbExistsTable(conn, name)
    if (found && !overwrite && !append) {
      stop("Table ", name, " exists in database, and both overwrite and",
        " append are FALSE", call. = FALSE)
    }
    if (found && overwrite) {
      dbRemoveTable(conn, name)
    }

    if (!found || overwrite) {
      sql <- sqlCreateTable(conn, name, value)
      dbGetQuery(conn, sql)
    }

    if (nrow(value) > 0) {
      value <- sqlData(conn, value)
      #if (!copy) {
        #sql <- sqlAppendTable(conn, name, value)
        #rs <- dbSendQuery(conn, sql)
      #} else {

        values <- sqlData(conn, value[, , drop = FALSE])

        name <- dbQuoteIdentifier(conn, name)
        fields <- dbQuoteIdentifier(conn, names(values))
        params <- rep("?", length(fields))

        sql <- paste0(
          "INSERT INTO ", name, " (", paste0(fields, collapse = ", "), ")\n",
          "VALUES (", paste0(params, collapse = ", "), ")"
          )
        rs <- dbSendQuery(conn, sql)

        tryCatch(
          result_insert_dataframe(rs@ptr, values),
          finally = dbClearResult(rs)
          )
      #}
    }

    invisible(TRUE)
  }
)

##' @rdname odbconnect-tables
##' @inheritParams DBI::dbReadTable
##' @export
setMethod("sqlData", "OdbconnectConnection", function(con, value, row.names = NA, copy = TRUE) {
  value <- sqlRownamesToColumn(value, row.names)

  # C code takes care of atomic vectors, dates and date times, just need to coerce other objects
  is_object <- vapply(value, function(x) is.object(x) && !(is(x, "POSIXct") || is(x, "Date")), logical(1))
  value[is_object] <- lapply(value[is_object], as.character)

  value
})


#' @rdname DBI
#' @inheritParams DBI::dbReadTable
#' @export
setMethod(
  "dbReadTable", c("OdbconnectConnection", "character"),
  function(conn, name) {
    name <- dbQuoteIdentifier(conn, name)
    dbGetQuery(conn, paste("SELECT * FROM ", name))
  })