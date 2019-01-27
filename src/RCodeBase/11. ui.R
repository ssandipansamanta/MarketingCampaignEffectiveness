# Define UI for application that draws a histogram
# Define UI for dataset viewer application
ui <- fluidPage(
  
  # Application title
  headerPanel(h1("Customer Level Deep Dive Analysis",style = "color:brown")),
  # temp <- data.table::fread(paste0(DirPath,"/Output/Q1_AllUserswithCustType.csv")),
  
  sidebarPanel(
    selectInput(inputId = "UserID"
                ,label = "Choose a Customer:"
                ,choices = c("122349","799706","1032626","1527570","2808960","2832333","3227905","3335047","3535542","4369508")),
   numericInput("obs", "Number of observations to view:", 3)
  ),
  
 
  mainPanel(
    h3("Customer Information",style = "color:blue"),
    tableOutput("Table1"),
    h3("Measure of Symmetry: Skewness ",style = "color:blue"),
    tableOutput("Table2"),
    h3("Spend Distribution ",style = "color:blue"),
    plotlyOutput("plot")
  )
)
