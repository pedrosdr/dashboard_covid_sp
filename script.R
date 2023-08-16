library(dplyr)
library(data.table)
library(ggplot2)
library(plotly)
library(scales)
library(shiny)
library(shinydashboard)

theme_set(
  theme_bw() +
  theme(text = element_text(family = 'Helvetica'))
)

setwd('C:/Users/Lenovo/Desktop/r')

data = read.csv('data.csv', sep=';')
data = data %>% rename(municipio='nome_munic')
data = data %>% rename(data='datahora')
data = data %>% rename(populacao='pop')
data = data %>% rename(semana_epidemiologica='semana_epidem')
data = subset(data, select = -codigo_ibge)
data = subset(data, select = -casos_novos)
data = subset(data, select = -obitos_novos)
data$casos_mm7d = gsub(',', '.', data$casos_mm7d) %>% as.numeric()
data$obitos_mm7d = gsub(',', '.', data$obitos_mm7d) %>% as.numeric()
data$data = as.Date(data$data)
data$casos_por_habitante = data$casos / data$populacao
data$obitos_por_habitante = data$obitos / data$populacao
data$obitos_por_caso = data$obitos / data$casos
data$obitos_por_caso = replace(data$obitos_por_caso, is.nan(data$obitos_por_caso), 0)


s = data %>% filter(
                toupper(municipio) %in% c('SÃO CARLOS', 'RIBEIRÃO PRETO', 'GUARULHOS') 
                #&
                #data > as.Date('2021-01-01') &
                #data < as.Date('2023-01-01')
             )


totals = s %>% 
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

# INCORPORADO
ggplotly(
  s %>% ggplot(aes(
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
    theme(plot.title = element_text(hjust = 0.5)),
  tooltip = 'text'
)

# INCORPORADO
ggplotly(
  s %>% ggplot(aes(
                  x=data, 
                  y=obitos_por_caso, 
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
      y='Número de óbitos por caso', 
      title='Evolução do número de óbitos por caso registrado',
      color = 'Município') +
    theme(plot.title = element_text(hjust = 0.5)) +
    scale_x_date(labels = date_format('%d/%m/%Y')),
  tooltip = 'text'
)

ggplotly(
  s %>% ggplot(aes(
                  x=data, 
                  y=obitos_por_caso, 
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
      y='Número de óbitos por caso', 
      title='Evolução do número de óbitos por caso registrado',
      color = 'Município') +
    theme(plot.title = element_text(hjust = 0.5)) +
    scale_x_date(labels = date_format('%d/%m/%Y')),
  tooltip = 'text'
)

# INCORPORADO
ggplotly(
  s %>% ggplot(aes(
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

# INCORPORADO
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
          title='Total de casos por município',
          y='Total de casos',
          x=NULL
        ) +
        theme(legend.position = "none") +
        theme(plot.title = element_text(hjust=0.5)),
  tooltip = 'text'
)

# INCORPORADO
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
      title='Total de óbitos por município',
      y='Total de óbitos',
      x=NULL
    ) +
    theme(legend.position = "none") +
    theme(plot.title = element_text(hjust=0.5)),
  tooltip = 'text'
)

# INCORPORADO
ggplotly(
  totals %>% ggplot(aes(
                        x=municipio, 
                        y=media_obitos_por_caso, 
                        fill=municipio,
                        text = sprintf(
                          'Óbitos/caso: %.4f<br>Município: %s',
                          media_obitos_por_caso,
                          municipio
                        ))) +
    geom_col() +
    scale_y_continuous(labels = label_number(scale=1)) +
    labs(
      title='Média de óbitos por caso registrado',
      y='Média de óbitos por caso',
      x=NULL
    ) +
    theme(legend.position = "none") +
    theme(plot.title = element_text(hjust=0.5)),
  tooltip = 'text'
)

# INCORPORADO
ggplotly(
  totals %>% ggplot(aes(
                      x=municipio, 
                      y=media_casos_por_habitante, 
                      fill=municipio,
                      text=sprintf('Casos/habitante: %.4f<br>Município: %s',
                                   media_casos_por_habitante,
                                   municipio))) +
    geom_col() +
    scale_y_continuous(labels = label_number(scale=1)) +
    labs(
      title='Média de casos por habitante',
      y='Média de casos por habitante',
      x=NULL
    ) +
    theme(legend.position = "none") +
    theme(plot.title = element_text(hjust=0.5)),
  tooltip = 'text'
)

# INCORPORADO
ggplotly(
  totals %>% 
    ggplot(aes(
              x=municipio, 
              y=media_obitos_por_habitante, 
              fill=municipio, 
              text=sprintf('Óbitos por habitante: %.4f', media_obitos_por_habitante))
    ) +
    geom_col() +
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

# INCORPORADO
ggplotly(
  totals %>% 
    ggplot(
      aes(
        y = total_obitos_por_habitante,
        x = total_casos_por_habitante,
        group = municipio,
        text = sprintf(
          'Óbitos/habitante: %.4f<br>Casos/habitante: %.4f<br>Município: %s',
          total_obitos_por_habitante,
          total_casos_por_habitante,
          municipio
        )
      )
    ) +
    geom_point(color = '#3c8dbc', size = 3) +
    labs(
      x = 'Casos/habitante',
      y = 'Óbitos/habitante',
      title = 'Valores máximos de casos e óbitos por habitante'
    ),
  tooltip = 'text'
)

# INCORPORADO
ggplotly(
  s %>% ggplot(aes(
    x=data, 
    y=casos_por_habitante, 
    group=municipio, 
    color=municipio,
    text = sprintf(
      'Casos/habitante: %.4f<br>Data: %s<br>Município: %s',
      casos_por_habitante,
      format(data, '%d/%m/%Y'),
      municipio)
  )
  ) +
    geom_line(size=1) +
    labs(
      x=NULL, 
      y='Casos/habitante', 
      title='Evolução dos casos/habitante',
      color = 'Município',
    ) +
    theme(plot.title = element_text(hjust = 0.5)),
  tooltip = 'text'
)


# incorporando
ggplotly(
  s %>% ggplot(aes(
    x=data, 
    y=obitos_por_habitante, 
    group=municipio, 
    color=municipio,
    text = sprintf(
      'Óbitos/habitante: %.4f<br>Data: %s<br>Município: %s',
      obitos_por_habitante,
      format(data, '%d/%m/%Y'),
      municipio)
  )
  ) +
    geom_line(size=1) +
    labs(
      x=NULL, 
      y='Óbitos/habitante', 
      title='Evolução dos Óbitos/habitante',
      color = 'Município',
    ) +
    theme(plot.title = element_text(hjust = 0.5)),
  tooltip = 'text'
)
