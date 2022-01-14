library(ggparliament)
library(ggplot2)
library(openxlsx)
library(dplyr)

raw <- read.xlsx('data/candidatos_tabla_resultados.xlsx')

data <- raw %>%
  group_by(Posicion) %>%
  summarize(Asientos = sum(Resultado), .groups = NULL)

no_electos <- 155 - sum(data$Asientos)

data <- rbind(data, c('Por definir', no_electos))

data$Posicion <- as.factor(data$Posicion)
data$Asientos <- as.numeric(data$Asientos)

#data <- data.frame(Posicion = c('Adhiere', 'Adhiere con reparos', 'No adhiere', 'No expresa posición', 'No responde', 'No electos'), Asientos = c(104, 3, 29,18,1 ))

semicirculo <- parliament_data(election_data = data,
                                       type = "semicircle",
                                       parl_rows = 5,
                                       party_seats = data$Asientos)

colores <- c('dodgerblue2',
             'gold3',
             'coral1',
             'darkseagreen',
             'azure4',
             'black')


convencion <- ggplot(semicirculo, aes(x = x, y = y, colour = Posicion)) +
geom_parliament_seats() + theme_ggparliament() + labs(colour = NULL, title = "Convención Constituyente",
    subtitle = "Autonomía del Banco Central",
    caption = 'www.bc-autonomo.cl \n @BC_autonomo') +
scale_colour_manual(values = colores) 

convencion
ggsave('convencion.png', width = 16, height = 8, unit = 'cm')
dev.off()