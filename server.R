source('utils.R')

function(input, output, session) {
  
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
          color = 'Município',
        ) +
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
        ) +
        theme(plot.title = element_text(hjust=0.5)),
      tooltip = 'text'
    )
  }) # END CHART(LINE): evolução dos óbitos por município
  
  # CHART(BAR): variação de óbitos por habitante
  output$chart_obitos_por_habitante = renderPlotly({
    ggplotly(
      s() %>% ggplot(
        aes(
          x = municipio,
          y = obitos_por_habitante * 100,
          group = municipio,
          fill = municipio
        ) 
      ) +
        geom_boxplot(size = 0.5) +
        labs(
          x = NULL,
          y = 'Óbitos / habitante (%)'
        ) +
        theme(legend.position = "none")
    )
  }) # END CHART(BAR): variação de óbitos por habitante
  
  # CHART(LINE): evolução dos óbitos por caso registrado
  output$chart_evol_obitos_por_caso = renderPlotly({
    
    ggplotly(
      s() %>% ggplot(aes(
                        x=data, 
                        y=obitos_por_caso * 100, 
                        group=municipio, 
                        color=municipio,
                        text = sprintf(
                          'Óbitos por caso: %.2f%%<br>Data: %s<br>Município: %s', 
                          obitos_por_caso * 100, 
                          format(data, '%d/%m/%Y'),
                          municipio
                        )
                    )
        ) +
        geom_line(size=1) +
        labs(
          x=NULL, 
          y='Óbitos / caso (%)',
          color = 'Município') +
        theme(plot.title = element_text(hjust = 0.5)) +
        scale_x_date(labels = date_format('%d/%m/%Y')),
      tooltip = 'text'
    )
  }) # END CHART(LINE): evolução dos óbitos por caso registrado
  
  # CHART(LINE): evolução dos casos/habitante
  output$chart_evol_casos_por_habitante = renderPlotly({
    
    ggplotly(
      s() %>% ggplot(aes(
        x=data, 
        y=casos_por_habitante * 100, 
        group=municipio, 
        color=municipio,
        text = sprintf(
          'Casos / habitante: %.2f%%<br>Data: %s<br>Município: %s',
          casos_por_habitante * 100,
          format(data, '%d/%m/%Y'),
          municipio)
      )
      ) +
        geom_line(size=1) +
        labs(
          x=NULL, 
          y='Casos / habitante (%)',
          color = 'Município',
        ) +
        theme(plot.title = element_text(hjust = 0.5)),
      tooltip = 'text'
    )
  }) # END CHART(LINE): evolução dos casos/habitante
  
  # CHART(LINE): evolução dos óbitos/habitante
  output$chart_evol_obitos_por_habitante = renderPlotly({
    
    ggplotly(
      s() %>% ggplot(aes(
        x=data, 
        y=obitos_por_habitante * 100, 
        group=municipio, 
        color=municipio,
        text = sprintf(
          'Óbitos / habitante: %.2f%%<br>Data: %s<br>Município: %s',
          obitos_por_habitante * 100,
          format(data, '%d/%m/%Y'),
          municipio)
      )
      ) +
        geom_line(size=1) +
        labs(
          x=NULL, 
          y='Óbitos / habitante (%)',
          color = 'Município',
        ) +
        theme(plot.title = element_text(hjust = 0.5)),
      tooltip = 'text'
    )
  }) # END CHART(LINE): evolução dos óbitos/habitante
  
  
  # CHART(BAR): Total de casos por município
  output$chart_total_de_casos = renderPlotly({
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
      totals %>% ggplot(aes(
        x=municipio, 
        y=total_casos, 
        fill=municipio,
        text = sprintf('Casos: %d<br>Município: %s',
                       total_casos,
                       municipio))) +
        geom_col() +
        scale_y_continuous(labels = label_number(scale=1)) +
        labs(
          y='Total de casos',
          x=NULL
        ) +
        theme(legend.position = "none") +
        theme(plot.title = element_text(hjust=0.5)),
      tooltip = 'text'
    ) 
  }) # END CHART(BAR): Total de casos por município
  
  # CHART(BAR): Total de óbitos por município
  output$chart_total_de_obitos = renderPlotly({
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
      totals %>% ggplot(aes(
        x=municipio, 
        y=total_obitos, 
        fill=municipio,
        text = sprintf(
          'Óbitos: %d<br>Município: %s',
          total_obitos,
          municipio
        ))) +
        geom_col() +
        scale_y_continuous(labels = label_number(scale=1)) +
        labs(
          y='Total de óbitos',
          x=NULL
        ) +
        theme(legend.position = "none") +
        theme(plot.title = element_text(hjust=0.5)),
      tooltip = 'text'
    )
  }) # END CHART(BAR): Total de óbitos por município
  
  # CHART(BAR): Variação de casos por habitante
  output$chart_casos_por_habitante = renderPlotly({
    ggplotly(
      s() %>% ggplot(
        aes(
          x = municipio,
          y = casos_por_habitante * 100,
          group = municipio,
          fill = municipio
        ) 
      ) +
        geom_boxplot() +
        labs(
          x = NULL,
          y = 'Casos / habitante (%)'
        ) +
        theme(legend.position = "none")
    )
  })# END CHART(BAR): Variação de casos por habitante
  
  # CHART(BAR): Média de Óbitos por caso
  output$chart_obitos_por_caso  = renderPlotly({
    ggplotly(
      s() %>% ggplot(
        aes(
          x = municipio,
          y = obitos_por_caso * 100,
          group = municipio,
          fill = municipio
        ) 
      ) +
        geom_boxplot(size = 0.5) +
        labs(
          x = NULL,
          y = 'Óbitos / caso (%)'
        ) +
        theme(legend.position = "none")
    )
    
  })# END CHART(BAR): Média de óbitos por caso
  
  # CHART(POINT): Valores máximos de casos e óbitos por habitante
  output$chart_casos_e_obitos = renderPlotly({
    totals = s() %>% 
      arrange(municipio, data) %>%
      group_by(municipio) %>%
      summarise(
        total_casos = max(casos),
        total_obitos = max(obitos),
        media_obitos_por_caso = mean(obitos_por_caso),
        media_casos_por_habitante = mean(casos_por_habitante),
        media_obitos_por_habitante = mean(obitos_por_habitante),
        total_obitos_por_habitante = max(obitos_por_habitante),
        total_casos_por_habitante = max(casos_por_habitante)
      )
    
    ggplotly(
      totals %>% 
        ggplot(
          aes(
            y = total_obitos_por_habitante * 100,
            x = total_casos_por_habitante * 100,
            group = municipio,
            fill = municipio,
            text = sprintf(
              'Município: %s<br>Óbitos/habitante: %.2f%%<br>Casos/habitante: %.2f%%',
              municipio,
              total_obitos_por_habitante * 100,
              total_casos_por_habitante * 100
            )
          )
        ) +
        geom_point(size = 3) +
        labs(
          x = 'Casos / habitante (%)',
          y = 'Óbitos / habitante (%)',
          fill = 'Município',
        ),
      tooltip = 'text'
    )
  })
  
  # END CHART(POINT): Valores máximos de casos e óbitos por habitante
}
