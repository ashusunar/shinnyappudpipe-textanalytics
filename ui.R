#---------------------------------------------------------------------#
#               Shinny App - UDPipe NLP workflow                      #
#---------------------------------------------------------------------#


library("shiny")

library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)
library(igraph)
library(ggraph)
library(ggplot2)


shinyUI(
  fluidPage(
    
    tags$head(
      tags$style(HTML("
                      .shiny-output-error-validation {
                      color: red;
                      }
                      "))
      ),
    
    titlePanel("UDPipe NLP Work Flow"),
    
    sidebarLayout( 
      
      sidebarPanel(  
        
              fileInput("txtfile", "Upload a Text File (.txt format only)"),
              fileInput("udpidelangmodel", "Upload Trained udpipe model as per language of the Text file you have uploaded above!"),
              checkboxInput("inputadjective","adjective(JJ)",TRUE),
              checkboxInput("inputnoun","noun(NN)",TRUE),
              checkboxInput("inputpropernoun","proper noun(NNP)",TRUE),
              checkboxInput("inputadverb","adverb(RB)",FALSE),
              checkboxInput("inputverb","verb(VB)",FALSE)
              ), # end of sidebar panel
    
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                      tabPanel("Overview",
                               h4(p("Data input:")),
                               p("This app supports only Text file (.txt data file). Please upload a text file for NLP analysis in any language. As per the language of your text file data, please remember to also select a Trained UD Pipe model of the similar language! ",align="justify"),
                               br(),
                               
                               h4(p('How to use this App?')),
                               p('Step 1: upload a text file for language of your choice (.txt format only)'),
                               p('Step 2: upload a trained UDpipe model for that language (as per the language of text file loaded above)'),
                               p('Step 3: select between Adjective, Noun, Proper Noun, Adverb and Verb - as per the output you seek for your text'),
                               p('Step 4: be patient for results to appear/ change as per your selection and see the outputs across 3 tabs, i.e. Co-occurence plot, XPOS table and Word Cloud '),
                               br(),
                               
                               h4(p('Working of the app:')),
                               p('Basis your selection of data file, trained UDpipe model and the XPOS selected the display changes and appears for each of the display sections, i.e. Co-occurence plot, XPOS table and Word cloud'),
                               br(),
                               
                               h4(p('Disclaimer!')),
                               p('1. Fonts in Hindi might not display correctly if you do not have Devnagri script installed for your Windows/ Mac. However the code runs well behind the scenes.'),
                               p('2. By default XPOS seelcted are Adjective, Noun and Proper Noun; in case you do not make any selections on your own.')),
                               
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
  


