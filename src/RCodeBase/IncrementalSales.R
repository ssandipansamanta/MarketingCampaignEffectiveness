IncrementalSpend <- function(InputData,groupby){
  
  IncSpendOverall <- InputData[,.(TotalSpend = sum(Spend,na.rm = TRUE)), by = groupby]
  
  ControlSpend <- data.table:::subset.data.table(IncSpendOverall,Group == "Control")$TotalSpend
  IncSpendOverall[,c('Incremental_Sales_dollar','Incremental_Sales_percent') := 
                    list((TotalSpend - ControlSpend),(TotalSpend / ControlSpend - 1))]
  return(IncSpendOverall)
}

IncrementalSpendSummary <- IncrementalSpend(InputData = SenstivityAnalysis(InputData = ADS,
                                            StDate = StartDate_IncSales,
                                            EnDate = EndDate_IncSales,
                                            groupby = c('UserID','Group','CustomerType'),
                                            Skewnessthreshold = Skewnessthreshold),
                         groupby=c('Group','CustomerType'))

WriteOutput(OutputDataFrame = IncrementalSpendSummary,
            NameofFile = 'Q3_IncrementalSpendSummary',RemoveFile = TRUE)
