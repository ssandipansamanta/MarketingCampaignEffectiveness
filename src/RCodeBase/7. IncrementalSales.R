IncrementalSpend <- function(InputData,groupbyLevel1,groupbyLevel2){
  
  IncTotalSpend <- InputData[,.(TotalSpend = sum(Spend,na.rm = TRUE)), by = groupbyLevel1]
  
  IncAvgSpend <- IncTotalSpend[,.(ActualSpend = sum(TotalSpend,na.rm = TRUE),
                                  AvgSpend = mean(TotalSpend,na.rm = TRUE),
                                  NoofCust = .N), by = groupbyLevel2]
  
  ControlSpend <- data.table:::subset.data.table(IncAvgSpend,Group == "Control")$AvgSpend
  IncAvgSpend[,c('Incremental_Sales_dollar','Incremental_Sales_percent') := 
                    list((ActualSpend - (ControlSpend * NoofCust)),
                         (ActualSpend / (ControlSpend * NoofCust) - 1)*100)]
  return(IncAvgSpend)
}

IncrementalSpendSummary <- IncrementalSpend(InputData = SenstivityAnalysis(InputData = ADS,
                                            StDate = StartDate_IncSales,
                                            EnDate = EndDate_IncSales,
                                            groupby = c('UserID','Group','CustomerType'),
                                            Skewnessthreshold = Skewnessthreshold),
                         groupbyLevel1=c('Group','CustomerType','UserID'),
                         groupbyLevel2 = c('Group','CustomerType'))

WriteOutput(OutputDataFrame = IncrementalSpendSummary,
            NameofFile = 'Q3_IncrementalSpendSummary',RemoveFile = TRUE)
