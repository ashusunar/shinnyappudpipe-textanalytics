#---------------------------------------------------------------------#
#               Shinny App - UDPipe NLP workflow                      #
#---------------------------------------------------------------------#


library(shiny)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)


shinyUI(
  fluidPage(
    
    tags$head(
      tags$style(HTML("
                      .shiny-output-error-validation {
                      color: red;
                      }
                      "))
      ),
    
    titlePanel("NLP using UDPipe"),
    #windowsFonts(devanew=windowsFont("Devanagari new normal")),
    sidebarLayout( 
      
      sidebarPanel(  
        
              fileInput("txtfile", "Upload data (Input Text file )"),
              fileInput("udpidelangmodel", "Upload Trained udpipe model for any language"),
              checkboxInput("inputadjective","adjective(JJ)",TRUE),
              checkboxInput("inputnoun","noun(NN)",TRUE),
              checkboxInput("inputpropernoun","proper noun(NNP)",TRUE),
              checkboxInput("inputadverb","adverb(RB)",FALSE),
              checkboxInput("inputverb","verb(VB)",FALSE)
              ), # end of sidebar panel
    
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                      tabPanel("Overview",
                               h4(p("Data input")),
                               p("This app supports only comma separated values (.csv) data file. CSV data file should have headers and the first column of the file should have row names.",align="justify"),
                               p("Please refer to the link below for sample csv file."),
                               a(href="https://github.com/sudhir-voleti/sample-data-sets/blob/master/Segmentation%20Discriminant%20and%20targeting%20data/ConneCtorPDASegmentation.csv"
                                 ,"Sample data input file"),   
                               br(),
                               h4('How to use this App'),
                               p('To use this app, click on', 
                                 span(strong("Upload data (csv file with header)")),
                                 'and uppload the csv data file. You can also change the number of clusters to fit in k-means clustering')),
                  
                  tabPanel("Co-Occurrene plot (as per xpos selected)", 
                                   plotOutput('coocplotsent')),
                  
                  tabPanel("Summary for xpos (as selected)", 
                           tableOutput('tablexpos')),
                  
                  tabPanel("WordCloud (as per xpos selected)", 
                           plotOutput('wordcloud'))
                  #    tabPanel("Data",
                  #             dataTableOutput('clust_data'))
        
      ) # end of tabsetPanel
          )# end of main panel
            ) # end of sidebarLayout
              )  # end if fluidPage
                ) # end of UI
  


