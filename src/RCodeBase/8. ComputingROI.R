ROICalculation <- function(InputData, Takerate, valueofCoupon, groupbyLevel1,groupbyLevel2){
  
  #' Calculating Revenue as per take rate.
  ROIADS <- InputData[,Revenue := Spend * Takerate]
  
  IncTotalRev <- ROIADS[,.(TotalRevenue = sum(Revenue,na.rm = TRUE)), by = groupbyLevel1] 
  
  IncAvgRev <- IncTotalRev[,.(ActualRev = sum(TotalRevenue,na.rm = TRUE),
                              AvgRev = mean(TotalRevenue,na.rm = TRUE),
                              NoofCust = .N), by = groupbyLevel2]
  
  
  ControlAvgRev <- data.table:::subset.data.table(IncAvgRev,Group == "Control")$AvgRev
  IncAvgRev[,Incremental_Revenue := ActualRev - (ControlAvgRev * NoofCust)]
  
  NoofRedeemers = length(unique(data.table:::subset.data.table(ROIADS,CustomerType=="Redeemers")$UserID))
  TotalCost = valueofCoupon * NoofRedeemers
  
  IncAvgRev[,ROI := Incremental_Revenue / TotalCost]
  
  return(IncAvgRev)
}

ROIOutput <- ROICalculation(InputData = data.table:::subset.data.table(ADS,(StartDate_ROI <= Week)  & 
                                                                            (Week <= EndDate_ROI) & 
                                                                             CustomerType != "NonRedeemers"),
                            Takerate = Takerate,
                            valueofCoupon = valueofCoupon,
                            groupbyLevel1=c('Group','CustomerType','UserID'),
                            groupbyLevel2 = c('Group','CustomerType'))

WriteOutput(OutputDataFrame = ROIOutput,
            NameofFile = 'Q4_ROIOutput',RemoveFile = TRUE)