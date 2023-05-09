
?mirt::fscores


## Packages and models

library(shiny)
library(mirt)
library(shinydashboard)
library(dplyr)
OKS.grm <- readRDS("OKS_model.RDS")
OHS.grm <- readRDS("OHS_model.RDS")

# EAP sum score tables


OHS.fscores <- fscores(OHS.grm, method = "EAPsum") %>%
  unique() %>%
  as.data.frame() %>%
  arrange(F1)

OHS.df <- cbind(seq(0,48,1), OHS.fscores)
colnames(OHS.df) <- c("Sum score", "Average IRT score")
OHS.df$'Sum score' <- as.character(OHS.df$'Sum score')


OKS.fscores <- fscores(OKS.grm, method = "EAPsum") %>%
  unique() %>%
  as.data.frame() %>%
  arrange(F1)

OKS.df <- cbind(seq(0,48,1), OKS.fscores)
colnames(OKS.df) <- c("Sum score", "Average IRT score")
OKS.df$'Sum score' <- as.character(OKS.df$'Sum score')


## UI

ui <- navbarPage("IRT Score Conversion for the Oxford Knee and Hip Scores",
                 
                 # OKS UI
                 
                 tabPanel("OKS",
                          fluidPage(
                            titlePanel("Convert Oxford Knee Score response patterns to IRT scores"),
                            br(),
                            p("Use this tool to convert individual OKS response patterns to continuous IRT scores with 
      quantifiable measurement precision."),
                            br(),
                            fluidRow(
                              div(
                                column(width = 12,
                                       style = "background-color:#e6f2ff",
                                       h3("How to use the score converter"),
                                       br(),
                                       p("Upload your OKS responses as a CSV file, using the 
         'Browse' button."),
                                       h4(HTML("<b>The columns in your CSV files must relate to the 
         following items in the following order:</b>")),
                                       p("
         1. Pain,
         2. Night pain,
         3. Washing,
         4. Transport,
         5. Walking,
         6. Standing,
         7. Limping,
         8. Kneeling,
         9. Work,
         10. Give way,
         11. Shopping,
         12. Stairs."), 
                                       br(),
                                       p("There should be no other columns in the dataset (for example, patient ID)."),
                                       br(),
                                       tags$figure(
                                         align = "center",
                                         tags$img(src="OKSexample.PNG", width = 800)
                                       ),
                                       downloadLink("OKStemplatelink", "Download CSV template"),
                                       br(),
                                       br(),
                                       p("If the first row of your CSV file contains item names, 
           (as in the example above), make sure you have checked the 'Header' box.
          If the first row in your CSV file is a set of item responses, uncheck the 'Header' box. 
        Most CSV files use commas to separate values, but in some cases your computer may use semicolons or tabs - if so, change the separator."),
                                       br(),
                                       p("Download your IRT scores with the 'Download' button. These scores are in the same
         row order as respondents in your CSV file.")
                                )
                              )
                            ),
                            br(),
                            h3("The score converter"),
                            br(),
                            column(
                              3,
                              fileInput('OKSfile', 'Choose CSV File',
                                        accept=c('text/csv', 
                                                 'text/comma-separated-values,text/plain', 
                                                 '.csv')),
                              tags$hr(),
                              checkboxInput('OKSheader', 'Header', TRUE),
                              radioButtons('OKSsep', 'Separator',
                                           c(Comma=',',
                                             Semicolon=';',
                                             Tab='\t'),
                                           ','),
                              downloadButton('OKSdownloadData', 'Download')
                            ),
                            mainPanel(
                              box(style='width:400px;overflow-x: scroll;height:400px;overflow-y: scroll;',
                                  tableOutput('OKScontents')
                              )
                            )
                          ),
                          br(),
                          fluidRow(
                            div(column(width = 12,
                                       style = "background-color:#e6f2ff",
                                       h3("How to interpret scores"),
                                       p("In IRT, each possible response option could be explained by a range of plausible latent 
  construct levels (true values of knee health). The IRT scores presented by this 
  app are the mean of those plausible values and the standard errors of measurement are their 
  standard deviation. The IRT scores can be used to replace traditional sum scores. A low standard error of measurement indicates 
  a higher level of precision. Standard errors of measurement < 0.3 suggest excellent 
  precision.")
                            )
                            )
                          ),
                          br(),
                          br(),
                          br(),
                          fluidRow(
                            div(column(width = 12, 
                                       p("To reference this app, please cite ", a(href = "https://www.sciencedirect.com/science/article/pii/S0895435623000938", "the accompanying paper.", .noWS = "outside"), .noWS = c("after-begin", "before-end")), 
                                       p("The source code for this app can be found ", a(href = "https://github.com/MrConradHarrison/IRTconverter", "here.", .noWS = "outside"), .noWS = c("after-begin", "before-end"))))),
                          br(),
                          
                          fluidRow(
                            div(column(width = 12, p("This web page presents independent research funded by the NIHR and the Oxford-Berlin research partnership.
                             The views expressed are those of the authors and not necessarily those of the Oxford-Berlin research partnership, NIHR 
                             or the Department of Health and Social Care.")))),
                          br(),
                          
                          fluidRow(
                            div(column(width = 4, style='padding-bottom:50px', tags$img(src = "https://oxfordinberlin.eu/sites/default/files/styles/site_logo/public/oib/site-logo/oib-logo-phat.png?itok=uvQ2nTWT", width="50%")),
                                column(width = 4, style='padding-bottom:50px', tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Logo_Charite.svg/2560px-Logo_Charite.svg.png", width="50%")),
                                column(width = 4, style='padding-bottom:50px', tags$img(src = "https://www.nihr.ac.uk/images/researchers/manage-your-funding/manage-your-project/Research%20outputs%20and%20branding/nihr-logos-funded-01-col-corp.png", width="70%"))
                            )
                            
                          )
                          
                 ),
                 
                 # OHS UI
                 
                 tabPanel("OHS",
                          fluidPage(
                            titlePanel("Convert Oxford Hip Score response patterns to IRT scores"),
                            br(),
                            p("Use this tool to convert individual OHS response patterns to continuous IRT scores with 
      quantifiable measurement precision."),
                            br(),
                            fluidRow(
                              div(
                                column(width = 12,
                                       style = "background-color:#e6f2ff",
                                       h3("How to use the score converter"),
                                       br(),
                                       p("Upload your OHS responses as a CSV file, using the 
         'Browse' button."),
                                       h4(HTML("<b>The columns in your CSV files must relate to the 
         following items in the following order:</b>")),
                                       p("
         1. Pain,
         2. Sudden pain,
         3. Night pain,
         4. Washing,
         5. Transport,
         6. Dressing,
         7. Shopping,
         8. Walking,
         9. Limping,
         10. Stairs,
         11. Standing,
         12. Work."), 
                                       br(),
                                       p("There should be no other columns in the dataset (for example, patient ID)."),
                                       br(),
                                       tags$figure(
                                         align = "center",
                                         tags$img(src="OHSexample.PNG", width = 800)
                                       ),
                                       downloadLink("OHStemplatelink", "Download CSV template"),
                                       br(),
                                       br(),
                                       p("If the first row of your CSV file contains item names, 
           (as in the example above), make sure you have checked the 'Header' box.
          If the first row in your CSV file is a set of item responses, uncheck the 'Header' box. 
        Most CSV files use commas to separate values, but in some cases your computer may use semicolons or tabs - if so, change the separator."),
                                       br(),
                                       p("Download your IRT scores with the 'Download' button. These scores are in the same
         row order as respondents in your CSV file.")
                                )
                              )
                            ),
                            br(),
                            h3("The score converter"),
                            br(),
                            column(
                              3,
                              fileInput('OHSfile', 'Choose CSV File',
                                        accept=c('text/csv', 
                                                 'text/comma-separated-values,text/plain', 
                                                 '.csv')),
                              tags$hr(),
                              checkboxInput('OHSheader', 'Header', TRUE),
                              radioButtons('OHSsep', 'Separator',
                                           c(Comma=',',
                                             Semicolon=';',
                                             Tab='\t'),
                                           ','),
                              downloadButton('OHSdownloadData', 'Download')
                            ),
                            mainPanel(
                              box(style='width:500px;overflow-x: scroll;height:400px;overflow-y: scroll;',
                                  tableOutput('OHScontents')
                              )
                            )
                          ),
                          br(),
                          fluidRow(
                            div(column(width = 12,
                                       style = "background-color:#e6f2ff",
                                       h3("How to interpret scores"),
                                       p("In IRT, each possible response option could be explained by a range of plausible latent 
  construct levels (true values of hip health). The IRT scores presented by this 
  app are the mean of those plausible values and the standard errors of measurement are their 
  standard deviation. The IRT scores can be used to replace traditional sum scores. A low standard error of measurement indicates 
  a higher level of precision. Standard errors of measurement < 0.3 suggest excellent 
  precision.")
                            )
                            )
                          ),
                          br(),
                          br(),
                          br(),
  fluidRow(
    div(column(width = 12, 
               p("To reference this app, please cite ", a(href = "https://www.sciencedirect.com/science/article/pii/S0895435623000938", "the accompanying paper.", .noWS = "outside"), .noWS = c("after-begin", "before-end")), 
               p("The source code for this app can be found ", a(href = "https://github.com/MrConradHarrison/IRTconverter", "here.", .noWS = "outside"), .noWS = c("after-begin", "before-end"))))),
                          br(),
                          
                          fluidRow(
                            div(column(width = 12, p("This web page presents independent research funded by the NIHR and the Oxford-Berlin research partnership.
                             The views expressed are those of the authors and not necessarily those of the Oxford-Berlin research partnership, NIHR 
                             or the Department of Health and Social Care.")))),
                          br(),
                          
                          fluidRow(
                            div(column(width = 4, style='padding-bottom:50px', tags$img(src = "https://oxfordinberlin.eu/sites/default/files/styles/site_logo/public/oib/site-logo/oib-logo-phat.png?itok=uvQ2nTWT", width="50%")),
                                column(width = 4, style='padding-bottom:50px', tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Logo_Charite.svg/2560px-Logo_Charite.svg.png", width="50%")),
                                column(width = 4, style='padding-bottom:50px', tags$img(src = "https://www.nihr.ac.uk/images/researchers/manage-your-funding/manage-your-project/Research%20outputs%20and%20branding/nihr-logos-funded-01-col-corp.png", width="70%"))
                            )
                          )
                          ),
                          
                          # EAP score Look up tables
                          
                          tabPanel("Look-up tables",
                                   fluidPage(
                                     titlePanel("Look-up tables to approximate sum scores and IRT scores"),
                                     br(),
                                     p("These tables are an alternative approach to IRT scoring the OKS and OHS. 
                                       They show the mean IRT score across all response patterns that could generate a 
                                       given sum score. For example, there are 12 different ways to achieve a score of 1 in the OKS. 
                                       The mean of the IRT scores associated with each of these 12 patterns is presented in the table alongside 
                                       the sum score of 1."),
                                     br(),
                                     p("Specifically, these are EAP sum scores."),
                                     br(),
                                      column(width = 6,
                                             h4("OKS Look-up table"),
                                        box(style='width:400px;overflow-x: scroll;height:400px;overflow-y: scroll;',
                                            tableOutput("OKSLookup"))),
                                        column(width = 6,
                                               h4("OHS Look-up table"),
                                               box(style='width:400px;overflow-x: scroll;height:400px;overflow-y: scroll;',
                                                   tableOutput("OHSLookup")))

                                             ),
                                   br(),
                                   br(),
                                   fluidRow(
                                     div(column(width = 12, 
                                                p("To reference this app, please cite ", a(href = "https://www.sciencedirect.com/science/article/pii/S0895435623000938", "the accompanying paper.", .noWS = "outside"), .noWS = c("after-begin", "before-end")), 
                                                p("The source code for this app can be found ", a(href = "https://github.com/MrConradHarrison/IRTconverter", "here.", .noWS = "outside"), .noWS = c("after-begin", "before-end"))))),
                                   br(),
                                   
                                   fluidRow(
                                     div(column(width = 12, p("This web page presents independent research funded by the NIHR and the Oxford-Berlin research partnership.
                             The views expressed are those of the authors and not necessarily those of the Oxford-Berlin research partnership, NIHR 
                             or the Department of Health and Social Care.")))),
                                   br(),
                                   
                                   fluidRow(
                                     div(column(width = 4, style='padding-bottom:50px', tags$img(src = "https://oxfordinberlin.eu/sites/default/files/styles/site_logo/public/oib/site-logo/oib-logo-phat.png?itok=uvQ2nTWT", width="50%")),
                                         column(width = 4, style='padding-bottom:50px', tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Logo_Charite.svg/2560px-Logo_Charite.svg.png", width="50%")),
                                         column(width = 4, style='padding-bottom:50px', tags$img(src = "https://www.nihr.ac.uk/images/researchers/manage-your-funding/manage-your-project/Research%20outputs%20and%20branding/nihr-logos-funded-01-col-corp.png", width="70%"))
                                     )
                                   )
                                   )

                             )
 



## Server

server <- function(input, output) {
  
  # OKS server functions
  
  getOKSData <- reactive({
    
    inFile <- input$OKSfile
    
    if (is.null(input$OKSfile))
      return(NULL)
    
    csv <- read.csv(inFile$datapath, header=input$OKSheader, sep=input$OKSsep)
    
    scores <- fscores(OKS.grm, response.pattern = csv)
    
    tscores <- (scores[,1]*10) + 50
    
    scoretable <- cbind(scores, tscores)
    
    colnames(scoretable) <- c("OKS IRT score", "Standard error of measurement", "T-score")
    
    scoretable
    
  })
  
  
  output$OKScontents <- renderTable(
    
    getOKSData()
    
  )
  
  
  
  output$OKSdownloadData <- downloadHandler(
    
    filename = function() { 
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    
    content = function(file) {
      
      write.csv(getOKSData(), file)
      
    })
  
  output$OKStemplatelink <-downloadHandler(
    filename = "OKS template.csv",
    content = function(file) {
      file.copy("OKStemplate.csv", file)
    }
  )
  
  
  # OHS server functions
  
  getOHSData <- reactive({
    
    inFile <- input$OHSfile
    
    if (is.null(input$OHSfile))
      return(NULL)
    
    csv <- read.csv(inFile$datapath, header=input$OHSheader, sep=input$OHSsep)
    
    scores <- fscores(OHS.grm, response.pattern = csv)
    
    colnames(scores) <- c("OHS IRT score", "Standard error of measurement")
    
    scores
    
  })
  
  
  output$OHScontents <- renderTable(
    
    getOHSData()
    
  )
  
  
  
  output$OHSdownloadData <- downloadHandler(
    
    filename = function() { 
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    
    content = function(file) {
      
      write.csv(getOHSData(), file)
      
    })
  
  
  output$OHStemplatelink <-downloadHandler(
    filename = "OHS template.csv",
    content = function(file) {
      file.copy("OHStemplate.csv", file)
    }
  )
  
  
  output$OKSLookup <- 
    renderTable({
      OKS.df
    })

  
  output$OHSLookup <- 
    renderTable({
      OHS.df
    })
  
  
}


# Run the application 
shinyApp(ui = ui, server = server)
