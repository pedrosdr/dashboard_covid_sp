library(dplyr)
library(data.table)
library(ggplot2)
library(plotly)
library(scales)

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
data$casos_mm7d = gsub(',', '.', data$casos_mm7d) %>% as.numeric()
data$obitos_mm7d = gsub(',', '.', data$obitos_mm7d) %>% as.numeric()
data$data = as.Date(data$data)


s = data %>% filter(
                toupper(municipio) %in% c('CAMPINAS', 'SÃO PAULO', 'GUARULHOS') &
                data > as.Date('2021-01-01') &
                data < as.Date('2023-01-01')
             )

ggplotly(
  s %>% ggplot(aes(x=data, y=casos, group=municipio, color=municipio)) +
    geom_line(size=1) +
    labs(
      x=NULL, 
      y='Número de casos', 
      title='Evolução dos casos por município por data',
      color = 'Município') +
    theme(plot.title = element_text(hjust = 0.5))
)

ggplotly(
  s %>% ggplot(aes(x=municipio, y=casos , fill=municipio)) +
    geom_boxplot() +
    scale_y_continuous(labels = label_number(scale = 1)) +
    labs(
      x = NULL,
      y='Número de casos', 
      title='Evolução dos casos por município por data') +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(legend.position = 'none')
)


