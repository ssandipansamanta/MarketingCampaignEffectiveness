#' @author: Sandipan Samanta
#' @Version: 1.0
#' 
rm(list = ls(all=TRUE))
.rs.restartR()

DirPath             <- 'E:/Sandipan/application/QIAGEN/Case'            # 
InputDateFormat     <- "%m/%d/%Y"                                       #
Skewnessthreshold   <- 2                                                #

StartDate_SpndDist  <- as.Date('11/24/2014',InputDateFormat)
EndDate_SpndDist    <- as.Date('02/09/2015',InputDateFormat) 

StartDate_IncSales  <- as.Date('01/19/2015',InputDateFormat)
EndDate_IncSales    <- as.Date('02/23/2015',InputDateFormat) 

StartDate_ROI       <- as.Date('01/05/2015',InputDateFormat)
EndDate_ROI         <- as.Date('01/18/2015',InputDateFormat) 


#' @InstallingPackages: 
#' Installing Required R-Packages automatically if not present in system.
#' NOTE: - System should have internet connectivity 
#'       - Disabled security option if required to install automatically

source("RequiredLibraries.R")

#' @DataPreparation: 
#' Reading Csv files from input directoy
#' Verifying fields in imported data
#' Changing Week Variable from Character to Date format
#' 


#' @Question-1 :
#' Creating Customer Type Flag i.e. Redeemers - Non Redeemers - Control.
#' Saving Output with Customer Type in Output Folder.
#' Create Dummy Loyal Customer Flag
#' 

source("DataPreparation.R")

#' @Question-2: Spend Distribution over 12 Weeks period; 24th Nov, 2014 - 09th Feb, 2015 
#' 

source("SpendDistribution.R")

#' @Question-3: Incremental Sales in the six weeks after the coupons were sent 
#' 

source("IncrementalSales.R")

#' @Question-4: ROI for the Campaign 
#' 

Takerate <- 0.1
valueofCoupon <- 10

source("ComputingROI.R")


#' @EndofCode