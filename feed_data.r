library(googlesheets4)
library(openxlsx)
library(emojifont)

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

leyenda_emoji <- c(emoji('heavy_check_mark'), emoji('ok'), emoji('heavy_minus_sign'), emoji('woman_shrugging') ,emoji('question'))
leyenda_label <- c("Adhiere", "Adhiere con reparos", "No adhiere", "No expresa posición", "No responde")

df = data.frame(leyenda_emoji)

rownames(df) <- leyenda_label
emoji_col <- df[data$Posicion,]

write.xlsx(data, 'candidatos.xlsx')

data$Posicion <- paste0(emoji_col, data$Posicion)

write.xlsx(data, 'candidatos_tabla.xlsx')
