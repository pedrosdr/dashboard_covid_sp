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