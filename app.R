library(curl)
library(jsonlite)
library(rpivotTable)
library(shiny)
library(shinydashboard)

# https://salty-dusk-41217.herokuapp.com/siliconpublishing

shinyApp(fluidPage(
  tags$head(
    HTML(
      "
      <script>
      var socket_timeout_interval
      var n = 0
      $(document).on('shiny:connected', function(event) {
        socket_timeout_interval = setInterval(function(){
          Shiny.onInputChange('count', n++)
        }, 5000)
      });
      $(document).on('shiny:disconnected', function(event) {
        clearInterval(socket_timeout_interval)
      });
      </script>
      "
    )
    ),
  dashboardPage(
    dashboardHeader(title = "Github Stats", titleWidth = "100%"),
    dashboardSidebar(disable = T),
    dashboardBody(
      tags$head(tags$style(type = 'text/css',  '#pivot{ overflow-x: scroll; }')),
      rpivotTableOutput('pivot', width = "100%", height = "100%"),
      textOutput("text")
    )
  )
  ),
  shinyServer(function(input, output, session) {
    output$text <- renderText({
      
      req(input$count)
      
      paste("keep alive ", input$count)
    })
    df = fromJSON(
      'https://salty-dusk-41217.herokuapp.com/siliconpublishing'
    )
    output$pivot <- renderRpivotTable({
      rpivotTable(
        data = df,
        rows = "Year",
        cols = "Month",
        rendererName = "Row Heatmap",
        aggregatorName = "Integer Sum",
        vals = "Commits"
      )
    })
  })
  )
