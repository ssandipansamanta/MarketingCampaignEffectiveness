#' @Group-Level-Basic-Analysis
#' 

OverallGroupLevelBasicAnalysis <- GroupLevelAnalysis(data = ADS,
                                  StDate = min(ADS$Week),
                                  EnDate = max(ADS$Week),
                                  groupby = c('Group','CustomerType'))

GroupLevelBasicAnalysisCampaignperiod <- GroupLevelAnalysis(data = ADS,
                                              StDate = StartDate_ROI,
                                              EnDate = EndDate_ROI,
                                              groupby = c('Group','CustomerType'))

GroupLevelBasicAnalysisOver12Weeks <- GroupLevelAnalysis(data = ADS,
                                                            StDate = StartDate_SpndDist,
                                                            EnDate = EndDate_SpndDist,
                                                            groupby = c('Group','CustomerType'))

WriteOutput(OutputDataFrame = OverallGroupLevelBasicAnalysis,
            NameofFile = "OverallGroupLevelBasicAnalysis",
            RemoveFile = TRUE)
WriteOutput(OutputDataFrame = GroupLevelBasicAnalysisCampaignperiod,
            NameofFile = "GroupLevelBasicAnalysisCampaignperiod",
            RemoveFile = TRUE)
WriteOutput(OutputDataFrame = GroupLevelBasicAnalysisOver12Weeks,
            NameofFile = "GroupLevelBasicAnalysisOver12Weeks",
            RemoveFile = TRUE)
#' @OverallBasicInfo
# Group CustomerType   TotalSpend TotalItemPurchase NoofCust
# 1: Control      Control 1787145        37800     1001
# 2:    Test NonRedeemers 5373760       109180     3192
# 3:    Test    Redeemers 2290601        46038      804

#' @CampaignPeriodInfo
# Group CustomerType    TotalSpend TotalItemPurchase NoofCust
# 1: Control      Control 131084.5         3430      631
# 2:    Test NonRedeemers 457164.9        10315     1795
# 3:    Test    Redeemers 283358.5         5484      792

#' @Customer-Level-Basic-Analysis
#' 

OverallCustomerInfo <- CustomerLevelInsights(InputData = ADS,
                                             StDate = min(ADS$Week),
                                             EnDate = max(ADS$Week),
                                             groupby = c('UserID','Group','CustomerType')) 

WriteOutput(OutputDataFrame = OverallCustomerInfo,NameofFile = "OverallCustomerInfo",RemoveFile = TRUE)

# T <- SenstivityAnalysis(InputData = ADS,
#                    StDate = min(ADS$Week),
#                    EnDate = max(ADS$Week),
#                    groupby = c('UserID','Group','CustomerType'),
#                    Skewnessthreshold = Skewnessthreshold)
