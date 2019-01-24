#' Reading Csv Files
#' 

AllUser     <- data.table::fread(paste0(DirPath,"/Input/AllUsers.csv"))
Redeemers   <- data.table::fread(paste0(DirPath,"/Input/Redeemers.csv"))

#' Checking Data Fields in Dataframes
#' 

str(AllUser)
str(Redeemers)
cat("\014")

#' Changing Week Variable Character to Date Format
#' 

AllUser$Week    <- as.Date(AllUser$Week,InputDateFormat)

#' Creating Redeemers Flag
#' 

Redeemers[,CustomerType := "Redeemers"]

#' Merging All Users and Redeemers Table;
#' 
ADS <- data.table:::merge.data.table(x=AllUser,y=Redeemers,
                                     all.x = TRUE,by = 'UserID',
                                     allow.cartesian = TRUE)

#' Deleting Input Files and Clearning Memory
MemoryClearance(listofObjects = c("AllUser","Redeemers"))

#' Creating Customer Type Flag in All user Table
#' 

ADS[,CustomerType := ifelse(Group == "Control","Control",
                               ifelse(Group == "Test" & is.na(CustomerType) == TRUE,
                                        "NonRedeemers",CustomerType))]

WriteOutput(OutputDataFrame = ADS,NameofFile = "Q1_AllUserswithCustType",RemoveFile = FALSE)

source("5. BasicDiagnostic.R")
