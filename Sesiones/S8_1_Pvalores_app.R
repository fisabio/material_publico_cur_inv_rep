#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram of p-values
ui <- fluidPage(
   
   # Application title
   titlePanel("p-valores y la evidencia frequentista contra H0:theta=0"), theme = "brown",
   
   sidebarLayout(
      
      sidebarPanel(
         
        sliderInput(inputId = "n", 
                    label = "Tamaño muestral (n):",
                    min = 10,
                    max = 100,
                    value = 20),
         
        numericInput(inputId = "sigma",
                     label = "Sigma de las observaciones:", 
                     value = 1, 
                     min = 1),
        
        numericInput(inputId = "pi0",
                     label = "Probabilidad de H0:", 
                     value = 0.5, 
                     min = 0, 
                     max = 1),
        
        numericInput(inputId = "L",
                     label = "Número de simulaciones (L):", 
                     value = 1000000, 
                     min = 100),
        
        radioButtons(inputId = "dis", label = "Distribución de theta bajo H1:", 
                     choices = c("Constante de valor fijo a" = 1, "Normal(0, sigmaP)" = 2, "Uniforme (-a,a)" = 3), selected = 2),
        
        uiOutput("valor_auxiliar"),
        
        actionButton("action", "Simula")
        
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"), 
         textOutput("texto_pr1"),
         textOutput("texto_pr2")
      )
   )
)



# Define server plot
server <- function(input, output) {
   
  output$valor_auxiliar <- renderUI({
    
    if (input$dis == "1") {
      
      numericInput(inputId = "a",
                   label = "a:", 
                   value = 2)
      
    } else if (input$dis == "2") {
      
      numericInput(inputId = "a",
                   label = "sigmaP:", 
                   value = 1.41)
      
    } else if (input$dis == "3") {
      
      numericInput(inputId = "a",
                   label = "a:", 
                   value = 2)
      
    } else {}
    
  })
  
  pro <- function(n, sigma, pi0, L, a, dis){
    
    # pi0=0.5; L=1000000; a=2; dis=2
    
    L0 <- round(L*pi0) # number of simulations from H0
    L1 <- L - L0 # number of simulations from H1
    x0 <- rnorm(L0, 0, sigma/sqrt(n)) # sample means from H0
    
    if (dis == 1) { # One point
      
      x1 <- rnorm(L1, a, sigma/sqrt(n))
      
    } else if (dis == 2){ # Normal
      
      theta1 <- rnorm(L1, 0, a)
      x1 <- rnorm(theta1, sigma/sqrt(n))
      
    } else if (dis == 3){ # Uniform
      
      theta1 <- runif(L1, -a, a)
      x1 <- rnorm(theta1, sigma/sqrt(n))
    
    } else {}
    
    x <- list(x0 = x0, x1 = x1)
    return(x)
    
  }
  
  
  simular_x <- eventReactive(input$action, {
  
    x <- pro(n = input$n, sigma = input$sigma, pi0 = input$pi0, L = input$L, a = isolate(input$a), dis = input$dis)
    # x <- pro(pi0 = pi0, L = L, a = a, dis = dis)
    
  })
  
  obtener_ts <- reactive({
    
    x <- simular_x()
    
    t0 <- abs(x$x0) * sqrt(input$n)/input$sigma #t’s with H0 true
    t1 <- abs(x$x1) * sqrt(input$n)/input$sigma #t’s with H1 true
    
    t0_t1 <- list(t0 = t0, t1 = t1)
    return(t0_t1)
    
  })
  
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x <- simular_x()
      L0 <- length(x$x0)
      L1 <- length(x$x1)
      t0_t1 <- obtener_ts()
      
      p0 <- table(findInterval(2*(1-pnorm(t0_t1$t0)), seq(0, 0.1, by = 0.01)))/L0
      p1 <- table(findInterval(2*(1-pnorm(t0_t1$t1)), seq(0, 0.1, by = 0.01)))/L1
      
      
      df <- data.frame(probs = c(p0[2:10], p1[2:10]), hip = rep(c("H0", "H1"), each=9), x = c(seq(0.015, 0.095, by = 0.01) - 0.005/2, seq(0.015, 0.095, by = 0.01) + 0.005/2))
      
      ggplot(df, aes(x = x, y = probs)) + geom_bar(stat = "identity", aes(fill = hip)) + 
        scale_x_continuous(breaks = seq(0.01, 0.1, by = 0.01)) + scale_fill_brewer(palette = "Accent")+ labs(x = "p-valores", y = "", fill = "")

   })
   
   output$texto_pr1 <- renderText({
     
     t0_t1 <- obtener_ts()
     pr1 <- 1/(1 + length(t0_t1$t1[1.96 < t0_t1$t1 & t0_t1$t1 <= 2])/length(t0_t1$t0[1.96 < t0_t1$t0 & t0_t1$t0 <= 2]))
     
     paste0("Si p es aproximadamente 0.05, la proporción de veces que la muestra proviene de la Hipótesis Nula (H0) es: ", round(pr1, digits = 3))
     
   })
   
   output$texto_pr2 <- renderText({
     
     t0_t1 <- obtener_ts()
     pr2 <- 1/(1 + length(t0_t1$t1[2.576 < t0_t1$t1 & t0_t1$t1 <= 2.616])/length(t0_t1$t0[2.576 < t0_t1$t0 & t0_t1$t0 <= 2.616]))
     
     paste0("Si p es aproximadamente 0.01, la proporción de veces que la muestra proviene de la Hipótesis Nula (H0) es: ", round(pr2, digits = 3))
     
   })
   
}

# Run the application 
shinyApp(ui = ui, server = server)