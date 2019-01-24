#' @ABTesting:
#' 
ABTestingADS <- data.table:::subset.data.table(ADS,(StartDate_ROI <= Week)  & (Week <= EndDate_ROI) & CustomerType != "NonRedeemers")

#' Aggregating Revenue at Group Customerlevel;
#' 
CustomerGroupLevelSpend <- ABTestingADS[,.(TotalRevenue = sum(Spend,na.rm = TRUE)), by = c('Group','CustomerType','UserID')]  

#' AB Testing;
ABTesting <- lm(formula = TotalRevenue ~ CustomerType, data = CustomerGroupLevelSpend)
summary(ABTesting)

#' @Profiling:
#' 

ProfilingAnalysisADS <- SenstivityAnalysis(InputData = ADS,
                             StDate = as.Date('01/19/2015',InputDateFormat),
                             EnDate = as.Date('02/23/2015',InputDateFormat) ,
                             groupby = c('UserID','Group','CustomerType'),
                             Skewnessthreshold = Skewnessthreshold)

#' Number of Active Weeks;
#' 
ProfilingAnalysisADS[,NoofActiveWeeks:=.N,by="UserID"]
ADSSegmentation <- setDF(ProfilingAnalysisADS[,.(Spend = sum(Spend),
                                         Purchases = sum(Purchases),
                                         NoofActiveWeeks = mean(NoofActiveWeeks)), 
                                         by = c('UserID')])

# ADSSegmentation <- setDF(data.table:::subset.data.table(ADSSegmentation, NoofActiveWeeks > 1 ))

# MemoryClearance(listofObjects = "ADSFurtherAnalysis")

var <- c("Spend","Purchases")

#' Standardizing before Clustering
#' 

Profilingdf <- scale(ADSSegmentation[var]) 

#' Within Sum of Square;
#' 
wssplot <- function(data, noofcluster, seed){
  data <- Profilingdf
  wss <- (nrow(data)-1)*sum(apply(data,2,var))
  for (i in 2:nc){
    set.seed(seed)
    wss[i] <- sum(kmeans(data, centers=i)$withinss)
  }
  plot(1:nc, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")
  return(wss)
}

WSSVariance <- as.data.table(wssplot(Profilingdf,noofcluster = 15,seed = 12345))

set.seed(12345)
fitkmeans <- kmeans(Profilingdf, 7, nstart=300)
fitkmeans$size

aggregate(ADSSegmentation[var], by=list(cluster=fitkmeans$cluster), mean)
FinalCluster <- data.frame(ADSSegmentation,cluster = fitkmeans$cluster)

WriteOutput(OutputDataFrame = FinalCluster,NameofFile = "ClusterAnalysis",RemoveFile = FALSE)

table(ADSSegmentation[,1],fitkmeans$cluster)

library(cluster)
clusplot(ADSSegmentation[var], fitkmeans$cluster, main='2D representation of the Cluster solution',
         color=TRUE, shade=TRUE,
         labels=2, lines=0)


d <- dist(df, method = "euclidean") 
H.fit <- hclust(d, method="ward")
plot(H.fit) # display dendogram
groups <- cutree(H.fit, k=8) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters
rect.hclust(H.fit, k=8, border="red") 

