library(curl)
library(jsonlite)
library(rpivotTable)
library(shiny)
library(shinyjs)
library(shinydashboard)

# https://salty-dusk-41217.herokuapp.com/siliconpublishing

shinyApp(dashboardPage(
    dashboardHeader(title = "Ad Hoc Analysis Tool", titleWidth = "100%"),
    dashboardSidebar(disable = T),
    dashboardBody(
      useShinyjs(),
      tags$head(tags$style(type = 'text/css',  '#pivot{ overflow-x: scroll; }')),
      tags$head(
        HTML(
          "
          <script>
          var socket_timeout_interval
          var n = 0
          $(document).on('shiny:connected', function(event) {
          socket_timeout_interval = setInterval(function(){
          Shiny.onInputChange('count', n++)
          }, 15000)
          });
          $(document).on('shiny:disconnected', function(event) {
          clearInterval(socket_timeout_interval)
          });
          </script>
          "
        )
        ),
      div(id = 'dataSourceForm', class='input-group col-sm-12',
        textInput('dataSourceInput', label = NULL, placeholder = 'Enter json url to analyze', width = '100%'),
        span(class = 'input-group-btn',
          actionButton('loadButton', 'Load')
        )
      ),
      tags$br(),
      rpivotTableOutput('pivot', width = "100%", height = "100%"),
      shinyjs::hidden(textOutput("keepAlive"))
        )
    ),
  shinyServer(function(input, output, session) {
    output$keepAlive <- renderText({
      req(input$count)
      paste("keep alive ", input$count)
    })
    observeEvent(input$loadButton, {
      url = input$dataSourceInput
      df = fromJSON(url)
      output$pivot <- renderRpivotTable({
        req(input$dataSourceInput)
        rpivotTable(
          data = df,
          rendererName = "Row Heatmap",
          aggregatorName = "Integer Sum"
        )
      })
    })
  })
  )
