library(leaflet)
library(rgdal)
library(htmlwidgets)
library(openxlsx)

geosonmap <- "Comunas_Chile.json"

map = readOGR(geosonmap)

map$NOM_COM <- as.character(map$NOM_COM)
Encoding(map$NOM_COM) <- "UTF-8" 
Encoding(map$NOM_REG) <- "UTF-8" 
Encoding(map$NOM_PROV) <- "UTF-8" 

datos = read.xlsx("datos.xlsx")

# 

datos$comunas = as.factor(datos$comunas)
datos$psupond = as.numeric(datos$psupond)

map@data = data.frame(map@data,datos[match(map@data[,"COD_COMUNA"],datos[,"COD_COMUNA"]),])

pal1 <- colorNumeric("Set3",NULL)
pal2 <- colorNumeric("Set2",NULL)

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
    	        label = ~paste0("Distrito ", formatC(map$distrito, big.mark = ","), ": Data de prueba 1"),
                group = 'Vamos por Chile') %>%

	addPolygons(stroke = FALSE, 
                smoothFactor = 0.3, 
                fillOpacity = 0.8,
    	        fillColor = ~pal2(map$distrito),
    	        label = ~paste0("Distrito : ", formatC(map$distrito, big.mark = ","), ": Data de prueba 2"),
                group = 'Lista del Apruebo') %>%
    addLayersControl(c("Vamos por Chile", "Lista del Apruebo"), 
        options = layersControlOptions(collapsed = FALSE))

m

saveWidget(m, file="index.html") 



