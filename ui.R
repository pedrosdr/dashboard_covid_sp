# source('utils.R')

sidebar_size = '300px'

header = dashboardHeader(
  title='Dashboard Covid SP',
  titleWidth = '250px'
)

sidebar = dashboardSidebar(
  tags$link(
    rel = 'stylesheet',
    type = 'text/css',
    href = 'css/main.css'
  ),
  width = sidebar_size,
  
  fluidRow(
    column(
      width=12,
      selectizeInput(
        'selectize_municipio', 
        label = 'Municípios:', 
        choices = unique(data$municipio),
        options = list(maxItems = 10),
        selected = c('Ribeirão Preto', 'São Carlos', 'Lorena'),
        multiple = TRUE
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
      actionButton(
        'button_submit', 
        label = 'Consultar', 
        class='btn-primary btn-large', 
        style='color: #fff; width: 90%;')
    )
  )
  
)

body = dashboardBody(
  tags$link(
    rel = 'stylesheet',
    type = 'text/css',
    href = 'css/main.css'
  ),
  fluidRow(
    column(
      width = 6,
      box(
        class = 'chart-selection',
        width = '100%',
        actionButton('action', label='Evolução dos casos por município', class='btn btn-primary'),
      )
    ),
  ),
  fluidRow(
    column(
      width = 6,
      box(
        class = 'chart-box box-evolucao-casos',
        width = '100%',
        plotlyOutput('chart_evolucao_casos')
      )
    ),
    column(
      width = 6,
      box(
        class = 'chart-box box-evolucao_obitos',
        width = '100%',
        plotlyOutput('chart_evolucao_obitos')
      )
    ),
    column(
      width = 6,
      box(
        class = 'chart-box box-obitos-por-habitante',
        width = '100%',
        plotlyOutput('chart_obitos_por_habitante')
      )
    ),
    column(
      width = 6,
      box(
        class = 'chart-box box-evol_obitos_por_caso',
        width = '100%',
        plotlyOutput('chart_evol_obitos_por_caso')
      )
    )
  ),
  
  tags$script(
    src = 'js/main.js'
  )
)

dashboardPage(
  header = header, 
  sidebar = sidebar, 
  body = body
)