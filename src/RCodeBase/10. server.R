

# Define server logic required to draw a histogram
server <- function(input, output) {
  
    # Return the requested dataset
  datasetInput1 <- reactive({
    temp <- read.csv(paste0(DirPath,"/Output/Q1_AllUserswithCustType.csv"))
    RequiredData <- subset(temp,UserID == input$UserID)
    return(RequiredData)
  })
  
  datasetInput2 <- reactive({
    temp <- data.table::fread(paste0(DirPath,"/Output/OverallCustomerInfo.csv"))
    RequiredData <- data.table:::subset.data.table(temp[,c("UserID","Group","CustomerType","NoofWeeksActive","MeanSpend","Skewness")],UserID == input$UserID)
    return(RequiredData)
  })

  output$plot <- renderPlotly({
    temp <- data.table::fread(paste0(DirPath,"/Output/Q1_AllUserswithCustType.csv"))
    RequiredData <- data.table:::subset.data.table(temp,UserID == input$UserID)
    fit <- density(RequiredData$Spend)
    
    
    plot_ly(RequiredData, x = ~Week) %>%
      add_trace(y = ~Spend, name = 'Spend',type='bar') %>%
      add_lines(y = ~Spend, showlegend = FALSE)%>%
      layout(title = '',
             xaxis = list(title = 'Weeks',zeroline = TRUE),
             yaxis = list(title = 'Spends'))
    
  })
  
  output$Table1 <- renderTable({
    head((datasetInput1()), n = input$obs)
  })
  
  output$Table2 <- renderTable({
      head(datasetInput2())
  })
  
  # output$caption <- renderText({
  #   "Customer Information"
  # })
}
