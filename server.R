
options(shiny.maxRequestSize=30*1024^2) 
windowsFonts(devanew=windowsFont("Devanagari new normal"))

shinyServer(function(input, output) {
  
  Dataset <- reactive({
    
    if (is.null(input$txtfile)) {   # locate 'file1' from ui.R
      validate(
        need(input$txtfile$datapath == "", "            Please select a Input data set              "),errorClass = "myClass"
      )
      
                   return(NULL) } else{
      
        Data <- readLines(input$txtfile$datapath)
        
        return(Data) 
    }
  })
  
  langmodel <- reactive({
    if (is.null(input$udpidelangmodel)) {   # locate 'file1' from ui.R
      return(NULL) 
      
                                        } else{
        Data <- udpipe_load_model(input$udpidelangmodel$datapath)
        windowsFonts(devanew=windowsFont("Devanagari new normal"))
        return(Data)
      }
    
  })

  xposstring <-reactive({
    xposstr = NULL
    if (input$inputadjective == 1) { xposstr <-c(xposstr,"JJ")}
    if (input$inputnoun == 1) {xposstr <- c(xposstr,"NN")}
    if (input$inputpropernoun == 1) { xposstr <- c(xposstr,"NNP")}
    if (input$inputadverb == 1) { xposstr <- c(xposstr,"RB")}
    if (input$inputverb == 1) { xposstr <- c(xposstr,"VB")}
    return(xposstr)
  })
  
  final_data <- reactive({
    data <- udpipe_annotate(langmodel(), x = Dataset())
    data <- as.data.frame(data)
    return(data)
    
  })
  
  udipipedata <- reactive({
    
    windowsFonts(devanew=windowsFont("Devanagari new normal"))
    datacooc <- cooccurrence(     # try `?cooccurrence` for parm options
      x = subset(final_data(), xpos %in% xposstring()), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))
    return(datacooc)
  })



  subtitlestr <-reactive({
    titlestr = NULL
    if (input$inputadjective == 1) {titlestr <- c(titlestr,"Adjective ")}
    if (input$inputnoun == 1) {titlestr <-c(titlestr,"Noun ")}
    if (input$inputpropernoun == 1) {titlestr <-c(titlestr,"ProperNoun ")}
    if (input$inputadverb == 1) {titlestr <-c(titlestr,"AdVerb ")}
    if (input$inputverb == 1) {titlestr <-c(titlestr,"Verb ")}
    return(titlestr)    
  })

# table for xpos
  
  output$tablexpos = renderTable({
    windowsFonts(devanew=windowsFont("Devanagari new normal"))
    table(final_data()$xpos[final_data()$xpos %in% xposstring()])
    
    
  })  

# Calc and render plot    
output$coocplotsent = renderPlot({ 
    windowsFonts(devanew=windowsFont("Devanagari new normal"))
  
    wordnetwork <- head(udipipedata(), 50)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
    
    ggraph(wordnetwork, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 5) +
      
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
    
      labs(title = "Cooccurrences within 3 words distance", 
         subtitle = paste(subtitlestr(),collapse = ''))
       })


wordcloud_data <- reactive({
  
  windowsFonts(devanew=windowsFont("Devanagari new normal"))
  temp = final_data() %>% subset(., xpos %in% xposstring())
  wcloud = txt_freq(temp$lemma)
  return(wcloud)
})


output$wordcloud = renderPlot({
  windowsFonts(devanew=windowsFont("Devanagari new normal"))
  wordcloud(words = wordcloud_data()$key, 
            freq = wordcloud_data()$freq, 
            min.freq = 2, 
            max.words = 100,
            random.order = FALSE, 
            colors = brewer.pal(35, "Dark2"))
 
  
})

  
})

