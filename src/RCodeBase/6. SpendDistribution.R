SpendDistribution <- function(InputData,groupby){
  
  #'Aggregating Spend for FULL customer data base
  AggDist <- InputData[,.(TotalSpend = sum(Spend,na.rm = TRUE),
                             AvgSpend = mean(Spend,na.rm = TRUE)),by=groupby]
  
  #' Reshaping Data for Visualization
  ReshapingAggDist <- data.table:::dcast.data.table(data = AggDist,
                                               Week ~ CustomerType,
                                               value.var = c("TotalSpend","AvgSpend"),
                                               fun = list(sum, sum))
  
  WriteOutput(OutputDataFrame = AggDist,NameofFile = 'Q2_SpendDistribution_Tableau',RemoveFile = FALSE)
  WriteOutput(OutputDataFrame = ReshapingAggDist,NameofFile = 'Q2_SpendDistribution', RemoveFile = FALSE)
  
  return(NULL)
}

SpendDistribution(InputData = SenstivityAnalysis(InputData = ADS,
                                                 StDate = StartDate_SpndDist,
                                                 EnDate = EndDate_SpndDist,
                                                 groupby = c('UserID','Group','CustomerType'),
                                                 Skewnessthreshold = Skewnessthreshold),
                  groupby=c('CustomerType','Week'))
  




