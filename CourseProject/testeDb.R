testeDB <- function(){
  con <-
    dbConnect(MySQL(), db = "hg19", host = "genome-mysql.cse.ucsc.edu")
  query <- "show databases;"
  result <- dbGetQuery(con, query)
  dbDisconnect(con)
  result
}
