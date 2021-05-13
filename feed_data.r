library(googlesheets4)
library(openxlsx)

link <- 'https://docs.google.com/spreadsheets/d/1pPr5E9SD5ERKJgEEzV89X_TcDVnWk2U24mULpkblTM4/edit#gid=0'

data <- read_sheet(link)

diccionario_coa <- read.xlsx('diccionario_coalicion.xlsx')
diccionario_party <- read.xlsx('diccionario_partido.xlsx')

data <- merge(data,diccionario_coa)
data <- merge(data,diccionario_party)

data$Partido <- NULL
data$Coalición <- NULL

colnames(data)[3] <- 'Posicion'
colnames(data)[5] <- 'Partido'

write.xlsx(data, 'candidatos.xlsx')
