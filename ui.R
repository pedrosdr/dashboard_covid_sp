# source('utils.R')

sidebar_size = '300px'

header = dashboardHeader(title='Covid SP', titleWidth = sidebar_size)

sidebar = dashboardSidebar(
  width = sidebar_size,
  
  fluidRow(
    column(
      width=12,
      selectizeInput(
        'selectize_municipio', 
        label = 'Município:', 
        choices = unique(data$municipio),
        options = list(maxItems = 10)
      )
    )
  ),
  
  fluidRow(
    column(
      width=6,
      dateInput('inicial_date',
                label = 'Data inicial:',
                format = 'dd/mm/yyyy',
                value = min(data$data),
                min = min(data$data),
                max = max(data$data)
                )
    ),
    column(
      width=6,
      dateInput('final_date',
                label = 'Data final:',
                format = 'dd/mm/yyyy',
                value = max(data$data),
                min = min(data$data),
                max = max(data$data)
                )
    )
  ),
  
  fluidRow(
    column(
      width=12,
      actionButton('button_submit', label = 'Consultar', class='btn btn-primary btn-large')
    )
  )
  
)

body = dashboardBody(
  fluidRow(
    column(
      width = 6,
      box(
        width = '100%',
        plotlyOutput('chart_obitos_por_habitante')
      )
    ),
    column(
      width = 6,
      box(
        width = '100%',
        plotlyOutput('chart_evol_obitos_por_caso')
      )
    )
  )
)

dashboardPage(
  header = header, 
  sidebar = sidebar, 
  body = body
)