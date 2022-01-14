library(googlesheets4)
library(openxlsx)
library(emojifont)

link <- '...' # censored, google spreadsheet link

data <- read_sheet(link)

diccionario_coa <- read.xlsx('diccionario_coalicion.xlsx')
diccionario_party <- read.xlsx('diccionario_partido.xlsx')

data <- merge(data,diccionario_coa)
data <- merge(data,diccionario_party)

data$Partido <- NULL
coa_vector <- data$Coalición
data$Coalición <- NULL

colnames(data)[3] <- 'Posicion'
colnames(data)[5] <- 'Partido'

leyenda_emoji <- c(emoji('heavy_check_mark'), emoji('ok'), emoji('heavy_minus_sign'), emoji('woman_shrugging') ,emoji('question'))
leyenda_label <- c("Adhiere", "Adhiere con reparos", "No adhiere", "No expresa posición", "No responde")

df = data.frame(leyenda_emoji)

rownames(df) <- leyenda_label
emoji_col <- df[data$Posicion,]

write.xlsx(data, 'data/candidatos.xlsx')

data$Posicion <- paste0(emoji_col, data$Posicion)

data <- data[,c(1,2,4, 5,3)]

data$Coalicion <- coa_vector

write.xlsx(data, 'data/candidatos_tabla.xlsx')
