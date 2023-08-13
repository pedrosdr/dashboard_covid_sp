# source('utils.R')

function(input, output, session) {
  
  palette = 'Dark2'
  
  # EVENT: s
  s = eventReactive(input$button_submit, {
      data %>% 
      filter(
        municipio %in% input$selectize_municipio &
        data > input$inicial_date &
        data < input$final_date
      )
  }, ignoreNULL = FALSE) # END EVENT: s
  
  # CHART(LINE): evolução dos casos por município
  output$chart_evolucao_casos = renderPlotly({
    ggplotly(
      s() %>% ggplot(aes(
        x=data, 
        y=casos, 
        group=municipio, 
        color=municipio,
        text = sprintf(
          'Número de casos: %d<br>Data: %s<br>Município: %s',
          casos,
          format(data, '%d/%m/%Y'),
          municipio)
      )
      ) +
        geom_line(size=1) +
        labs(
          x=NULL, 
          y='Número de casos', 
          title='Evolução dos casos por município',
          color = 'Município',
        ) +
        scale_color_brewer(palette = palette) +
        theme(plot.title = element_text(hjust = 0.5)),
      tooltip = 'text'
    )
  }) # END CHART(LINE): evolução dos casos por município
  
  # CHART(LINE): evolução dos óbitos por município
  output$chart_evolucao_obitos = renderPlotly({
    ggplotly(
      s() %>% ggplot(aes(
        x=data, 
        y=obitos,
        group = municipio,
        color=municipio,
        text = sprintf(
          'Óbitos: %d<br>Data: %s<br>Município: %s',
          obitos,
          format(data, '%d/%m/%Y'),
          municipio
        )
      )
      ) +
        geom_line(size=1) +
        labs(
          x=NULL,
          y='Número de óbitos',
          color='Município',
          title='Evolução dos óbitos por muncípio'
        ) +
        theme(plot.title = element_text(hjust=0.5)),
      tooltip = 'text'
    )
  }) # END CHART(LINE): evolução dos óbitos por município
  
  # CHART(BAR): óbitos por habitante
  output$chart_obitos_por_habitante = renderPlotly({
    totals = s() %>% 
      arrange(municipio, data) %>%
      group_by(municipio) %>%
      summarise(
        total_casos = max(casos),
        total_obitos = max(obitos),
        media_obitos_por_caso = mean(obitos_por_caso),
        media_casos_por_habitante = mean(casos_por_habitante),
        media_obitos_por_habitante = mean(obitos_por_habitante)
      )
    
    ggplotly(
      totals %>% 
        ggplot(aes(
                x=municipio, 
                y=media_obitos_por_habitante,
                text=sprintf(
                  'Óbitos por habitante: %.4f<br>Município: %s', 
                  media_obitos_por_habitante, 
                  municipio
                )
              )
        ) +
        geom_col(fill = '#3c8dbc') +
        scale_y_continuous(labels = label_number(scale=1)) +
        labs(
          title='Média de óbitos por habitante',
          y='Média de óbitos por habitante',
          x=NULL
        ) +
        theme(legend.position = "none") +
        theme(plot.title = element_text(hjust=0.5)),
      tooltip = 'text'
    )
  }) # END CHART(BAR): óbitos por habitante
  
  # CHART(LINE): evolução dos óbitos por caso registrado
  output$chart_evol_obitos_por_caso = renderPlotly({
    
    ggplotly(
      s() %>% ggplot(aes(
                        x=data, 
                        y=obitos_por_caso, 
                        group=municipio, 
                        color=municipio,
                        text = sprintf(
                          'Óbitos por caso: %.4f<br>Data: %s<br>Município: %s', 
                          obitos_por_caso, 
                          format(data, '%d/%m/%Y'),
                          municipio
                        )
                    )
        ) +
        geom_line(size=1) +
        labs(
          x=NULL, 
          y='Número de óbitos por caso', 
          title='Evolução do número de óbitos por caso registrado',
          color = 'Município') +
        theme(plot.title = element_text(hjust = 0.5)) +
        scale_x_date(labels = date_format('%d/%m/%Y')),
      tooltip = 'text'
    )
  }) # END CHART(LINE): evolução dos óbitos por caso registrado
}
