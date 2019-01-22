ROICalculation <- function(InputData, Takerate, valueofCoupon, groupby){
  
  #' Calculating Revenue as per take rate.
  ROIADS <- InputData[,Revenue := Spend * Takerate]
  
  IncRevOverall <- ROIADS[,.(TotalRevenue = sum(Revenue,na.rm = TRUE)), by = groupby]  
  
  ControlOverallRevenue <- data.table:::subset.data.table(IncRevOverall,Group == "Control")$TotalRevenue
  IncRevOverall[,Incremental_Revenue := TotalRevenue - ControlOverallRevenue]
  
  TotalCost = valueofCoupon * length(unique(data.table:::subset.data.table(ROIADS,CustomerType=="Redeemers")$UserID))
  
  OverallIncRevenue       <- data.table:::subset.data.table(IncRevOverall,CustomerType=="Redeemers")$Incremental_Revenue
  IncRevOverall[,ROI := Incremental_Revenue / (valueofCoupon * length(unique(data.table:::subset.data.table(ROIADS,CustomerType=="Redeemers")$UserID)))]
  
  return(IncRevOverall)
}

ROIOutput <- ROICalculation(InputData = data.table:::subset.data.table(ADS,(StartDate_ROI <= Week)  & 
                                                                            (Week <= EndDate_ROI) & 
                                                                             CustomerType != "NonRedeemers"),
                            Takerate = Takerate,
                            valueofCoupon = valueofCoupon,
                            groupby = c('Group','CustomerType'))

WriteOutput(OutputDataFrame = ROIOutput,
            NameofFile = 'Q4_ROIOutput',RemoveFile = TRUE)