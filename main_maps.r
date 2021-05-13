library(leaflet)
library(rgdal)
library(htmlwidgets)
library(openxlsx)
library(emojifont)
source('parser.r')

geosonmap <- "Comunas_Chile.json"

map = readOGR(geosonmap)

map$NOM_COM <- as.character(map$NOM_COM)
Encoding(map$NOM_COM) <- "UTF-8" 
Encoding(map$NOM_REG) <- "UTF-8" 
Encoding(map$NOM_PROV) <- "UTF-8" 

datos = read.xlsx("datos.xlsx")

candidatos = read.xlsx('candidatos.xlsx')
candidatos$Posicion = as.factor(candidatos$Posicion)

datos$comunas = as.factor(datos$comunas)

map@data = data.frame(map@data,datos[match(map@data[,"COD_COMUNA"],datos[,"COD_COMUNA"]),])

pal1 <- colorNumeric("Set3",NULL)
pal2 <- colorNumeric("Set2",NULL)


prueba = formatC(map$distrito, big.mark = ",")
prueba[prueba == '1'] = parse(candidatos, 1, 'Vamos Chile')

etiqueta_vamos_chile <- as.character(paste0('<b> Distrito ',
                      map$distrito, ': </b> <br/>',
                      prueba)) %>% lapply(htmltools::HTML)

leyenda_emoji <- c(emoji('heavy_check_mark'), emoji('ok'), emoji('heavy_minus_sign'), emoji('woman_shrugging') ,emoji('question'))
leyenda_label <- c("Adhiere", "Adhiere con reparos", "No adhiere", "No expresa posición", "Sin respuesta")
leyenda_full <- paste(leyenda_emoji, leyenda_label)

m <-leaflet(map) %>%
  addEasyButton(easyButton(
    icon="fa-crosshairs", title="Ir a mi ubicación",
    onClick=JS("function(btn, map){ map.locate({setView: true}); }")))%>%
    addTiles() %>%
    setView(-70.657,-33.478,5) %>% 
	addProviderTiles(providers$OpenStreetMap) %>%
	addPolygons(stroke = FALSE, 
                smoothFactor = 0.3, 
                fillOpacity = 0.8,
    	          fillColor = ~pal1(map$distrito),
    	          label = etiqueta_vamos_chile,
                group = 'Vamos por Chile') %>%

	addPolygons(stroke = FALSE, 
                smoothFactor = 0.3, 
                fillOpacity = 0.8,
    	          fillColor = ~pal2(map$distrito),
    	          label = ~paste("Distrito:", formatC(map$distrito, big.mark = ","), ": Data de prueba 2", emoji('heavy_multiplication_x')),
                group = 'Lista del Apruebo') %>%
    addLayersControl(c("Vamos por Chile", "Lista del Apruebo"), 
        options = layersControlOptions(collapsed = FALSE)) %>%

    addLegend(position = "topright", colors = rep('#FFFFFF', 5), 
      labels = leyenda_full) %>%

    addLegend(position = "bottomright", colors = c('#FFFFFF'), 
      labels = '¿Encontraste un error? banco.central.autonomo@gmail.com')
m

saveWidget(m, file="index.html") 



