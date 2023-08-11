# source('utils.R')

sidebar_size = '300px'

header = dashboardHeader(title='Dashboard Covid SP', titleWidth = sidebar_size)

sidebar = dashboardSidebar(
  width = sidebar_size,
  
  fluidRow(
    column(
      width=12,
      selectizeInput(
        'selectize_municipio', 
        label = 'Município:', 
        choices = unique(data$municipio),
        options = list(maxItems = 10),
        selected = c('Ribeirão Preto', 'Barretos', 'Campinas'),
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
  fluidRow(
    column(
      width = 12,
      box(
        width = '100%',
        style = 'margin-top: -4px #ccc; background: #3c8dbc; border-radius: 5px;',
        actionButton('action', label='Action')
      )
    ),
  ),
  fluidRow(
    column(
      width = 12,
      box(
        width = '100%',
        style = 'margin-top: -3px; box-shadow: 0 0 10px #ccc; background: #fff; border-radius: 10px;',
        plotlyOutput('chart_evolucao_casos')
      )
    ),
    column(
      width = 12,
      box(
        width = '100%',
        style = 'margin-top: -3px; box-shadow: 0 0 10px #ccc; background: #fff; border-radius: 10px;',
        plotlyOutput('chart_evolucao_obitos')
      )
    ),
    column(
      width = 12,
      box(
        width = '100%',
        style = 'margin-top: -3px; box-shadow: 0 0 10px #ccc; background: #fff; border-radius: 10px;',
        plotlyOutput('chart_obitos_por_habitante')
      )
    ),
    column(
      width = 12,
      box(
        width = '100%',
        style = 'margin-top: -3px; box-shadow: 0 0 10px #ccc; background: #fff; border-radius: 10px;',
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