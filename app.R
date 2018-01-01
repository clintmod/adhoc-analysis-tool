library(curl)
library(jsonlite)
library(rpivotTable)
library(shiny)
library(shinydashboard)

# https://salty-dusk-41217.herokuapp.com/siliconpublishing
shinyApp(
  shinyUI(
    dashboardPage(
      dashboardHeader(title = "Github Stats", titleWidth = "100%"),
      dashboardSidebar(disable = T),
      dashboardBody(
        tags$head(tags$style( type = 'text/css',  '#pivot{ overflow-x: scroll; }')),
        rpivotTableOutput('pivot', width = "100%", height = "100%")
      )
    )
  ),
  shinyServer(function(input, output, session) {
    df = fromJSON('https://salty-dusk-41217.herokuapp.com/siliconpublishing')
    output$pivot <- renderRpivotTable({
      rpivotTable(data = df, rows = "Year",
                  cols = "Month", rendererName = "Row Heatmap",
                  aggregatorName = "Integer Sum", vals = "Commits")
    })
  })
)