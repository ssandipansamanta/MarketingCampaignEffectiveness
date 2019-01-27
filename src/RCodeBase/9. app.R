#' @author: Sandipan Samanta
#' @Version: 1.0
#' 
rm(list = ls(all=TRUE));gc()
.rs.restartR()


DirPath             <- 'E:/Sandipan/application/QIAGEN/Case'
InputDateFormat     <- "%m/%d/%Y"
Skewnessthreshold   <- 2
Lowercutoff         <- 0.01
Uppercutoff         <- 0.99

#' @InstallingPackages: 
#' Installing Required R-Packages automatically if not present in system.
#' NOTE: - System should have internet connectivity 
#'       - Disabled security option if required to install automatically
source("2. UDF.R")
source("3. RequiredLibraries.R")

library("shiny")
source("11. ui.R")
source("10. server.R")
# Run the application 
shinyApp(ui = ui, server = server
         ,options = list(port = 0128
         # ,display.mode="showcase"
         ))


