#' @InstallationofPackages
#' 

InstalledPackages <- function(packageNeedtoInstall){
  if(!eval(parse(text=paste0("require(",packageNeedtoInstall,")"))))
    install.packages(packageNeedtoInstall)
  eval(parse(text=paste0("library(",packageNeedtoInstall,")")))
  Sys.sleep(1)
}

#' @MemoryClearance:
#' 

MemoryClearance <- function(listofObjects, ...){
  rm(list = c(listofObjects), envir = .GlobalEnv)
  gc(verbose = getOption("verbose"), reset = TRUE, full = TRUE)
}

#' @WriteOutput
#' 

WriteOutput <- function(OutputDataFrame,NameofFile,RemoveFile){
  data.table::fwrite(x = OutputDataFrame,file = paste0(DirPath,"/Output/",NameofFile,".csv"))
  if(RemoveFile) MemoryClearance(listofObjects = as.character(substitute(OutputDataFrame)))
}


#' @GroupLevelAnalysis:
#' 

GroupLevelAnalysis <- function(data, StDate,EnDate, groupby){
  
  temp <- data.table:::subset.data.table(data, (StDate <= Week)  & (Week <= EnDate))
  TotalSpendItempurchase <- temp[,.(TotalSpend = sum(Spend,na.rm = TRUE), 
                                    TotalItemPurchase = sum(Purchases,na.rm = TRUE)), by = groupby]
  # UniqueCust <- unique(temp[,c('Group','CustomerType','UserID')])
  UniqueCust <- eval(parse(text = paste0('unique(temp[,c(',paste0("'",groupby,collapse = "' ,"),"'",", 'UserID')])")))
  NumberofCustbyGroup <- UniqueCust[,.(NoofCust = .N), by = groupby]
  
  CombineNumber <- data.table:::merge.data.table(TotalSpendItempurchase,NumberofCustbyGroup)
  return(CombineNumber)
}

#' @CustomerLevelAnalysis:
#' 

CustomerLevelInsights <- function(InputData, StDate, EnDate, groupby){
  
  tempCust <- data.table:::subset.data.table(InputData, (StDate <= Week)  & (Week <= EnDate))
  SummaryStats <- tempCust[,.(NoofWeeksActive = .N,
                              
                              MeanSpend = base::mean(Spend,na.rm = TRUE), 
                              StdSpend = stats::sd(Spend,na.rm = TRUE),
                              
                              L1 = Rfast::nth(Spend, 1, descending = FALSE),
                              L2 = Rfast::nth(Spend, 2, descending = FALSE),
                              L3 = Rfast::nth(Spend, 3, descending = FALSE),
                              
                              H1 = Rfast::nth(Spend, 1, descending = TRUE),
                              H2 = Rfast::nth(Spend, 2, descending = TRUE),
                              H3 = Rfast::nth(Spend, 3, descending = TRUE),
                              
                              LowerCap = stats::quantile(Spend,na.rm = TRUE, probs=Lowercutoff),
                              Median = stats::quantile(Spend,na.rm = TRUE, probs=0.50),
                              UpperCap = stats::quantile(Spend,na.rm = TRUE, probs=Uppercutoff),
                              
                              Skewness = Rfast::skew(Spend,pvalue = FALSE)),by = groupby]
  return(SummaryStats)
}

#' @Loyal-Customers
#' 

SenstivityAnalysis <- function(InputData, StDate, EnDate, groupby,Skewnessthreshold){
  
  temp <- CustomerLevelInsights(InputData = ADS,StDate = StDate,EnDate = EnDate,groupby = groupby) 
  
  temp[, LoyalFlag := ifelse((NoofWeeksActive > 2 & -Skewnessthreshold < Skewness & Skewness < Skewnessthreshold ), 
                             'Loyal','Suspicious')]
  LoyalCustomerInfo <- temp[,c('UserID','LoyalFlag','LowerCap','UpperCap')]
  
  ADS_ <- data.table:::merge.data.table(x=ADS,y=LoyalCustomerInfo,
                                        all.x = TRUE,by = 'UserID',
                                        allow.cartesian = TRUE)
  
  ADS_ <- setnames(ADS_, old = "Spend", new = "OldSpend")
  ADS_[,Spend:=ifelse(LoyalFlag=='Loyal',OldSpend,
                      ifelse(OldSpend < LowerCap,LowerCap,ifelse(OldSpend > UpperCap,UpperCap,OldSpend)))]
  
  FinalADS <- data.table:::subset.data.table(ADS_, (StDate <= Week)  & (Week <= EnDate))
  
  cat("=====================================================================\n")
  cat("================= Error due to capping and tapping  =================\n")
  cat("=====================================================================\n")
  print(FinalADS[,.(TotalNewSpend = sum(Spend),
                    TotalOldSpend = sum(OldSpend),
                    Deviationpercent = (1 - sum(Spend)/sum(OldSpend))*100)
                 ,by = c('Group','CustomerType')])
  cat("=====================================================================\n")
  
  
  return(FinalADS[,-c("OldSpend")])
}
