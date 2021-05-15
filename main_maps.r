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
pal3 <- colorNumeric("Set1",NULL)
pal4 <- colorNumeric("Paired",NULL)
pal5 <- colorNumeric("Dark2",NULL)
pal6 <- colorNumeric("Accent",NULL)


raw_vamos_chile <- map$distrito
raw_lista_apruebo <- map$distrito
raw_apruebo_dignidad <- map$distrito
raw_lista_pueblo <- map$distrito
raw_lista_independientes <- map$distrito
raw_lista_otros <- map$distrito

for (i in 1:28){
  raw_vamos_chile[raw_vamos_chile == i] = parse(candidatos, i, 'Vamos por Chile')
  raw_lista_apruebo[raw_lista_apruebo == i] = parse(candidatos, i, 'Lista del Apruebo')
  raw_apruebo_dignidad[raw_apruebo_dignidad == i] = parse(candidatos, i, 'Apruebo Dignidad')
  raw_lista_pueblo[raw_lista_pueblo == i] = parse(candidatos, i, 'Lista del Pueblo')
  raw_lista_independientes[raw_lista_independientes == i] = parse(candidatos, i, 'Listas Independientes')
  raw_lista_otros[raw_lista_otros == i] = parse(candidatos, i, 'Otros')

}

etiqueta_vamos_chile <- etiquetador(map$distrito, raw_vamos_chile)
etiqueta_lista_apruebo <- etiquetador(map$distrito, raw_lista_apruebo)
etiqueta_apruebo_dignidad <- etiquetador(map$distrito, raw_apruebo_dignidad)
etiqueta_lista_pueblo <- etiquetador(map$distrito, raw_lista_pueblo)
etiqueta_lista_independientes <- etiquetador(map$distrito, raw_lista_independientes)
etiqueta_lista_otros <- etiquetador(map$distrito, raw_lista_otros)

leyenda_emoji <- c(emoji('heavy_check_mark'), emoji('ok'), emoji('heavy_minus_sign'), emoji('woman_shrugging') ,emoji('question'))
leyenda_label <- c("Adhiere", "Adhiere con reparos", "No adhiere", "No expresa posicion", "Sin respuesta")
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
    	          fillColor = ~pal2(map$distrito),
    	          label = etiqueta_lista_apruebo,
                group = 'Lista del Apruebo') %>%

	addPolygons(stroke = FALSE, 
                smoothFactor = 0.3, 
                fillOpacity = 0.8,
    	          fillColor = ~pal1(map$distrito),
    	          label = etiqueta_vamos_chile,
                group = 'Vamos por Chile') %>%

  addPolygons(stroke = FALSE, 
                smoothFactor = 0.3, 
                fillOpacity = 0.8,
    	          fillColor = ~pal3(map$distrito),
    	          label = etiqueta_apruebo_dignidad,
                group = 'Apruebo Dignidad') %>%

  addPolygons(stroke = FALSE, 
                smoothFactor = 0.3, 
                fillOpacity = 0.8,
    	          fillColor = ~pal4(map$distrito),
    	          label = etiqueta_lista_pueblo,
                group = 'Lista del Pueblo') %>%

  addPolygons(stroke = FALSE, 
                smoothFactor = 0.3, 
                fillOpacity = 0.8,
    	          fillColor = ~pal5(map$distrito),
    	          label = etiqueta_lista_independientes,
                group = 'Listas Independientes') %>%
    
  addPolygons(stroke = FALSE, 
                smoothFactor = 0.3, 
                fillOpacity = 0.8,
    	          fillColor = ~pal6(map$distrito),
    	          label = etiqueta_lista_otros,
                group = 'Otros') %>%

  addLayersControl(c( "Lista del Apruebo", "Vamos por Chile", "Apruebo Dignidad",
                        "Lista del Pueblo", "Listas Independientes", "Otros"), 
        options = layersControlOptions(collapsed = FALSE)) %>%

  addLegend(position = "topright", colors = rep('#FFFFFF', 5), 
      labels = leyenda_full) %>%

  addLegend(position = "bottomright", colors = c('#FFFFFF'), 
      labels = 'Encontraste un error? Reporta en banco.central.autonomo@gmail.com')
m

saveWidget(m, file = "index.html", selfcontained = FALSE, title = 'Mapa de candidatos')




