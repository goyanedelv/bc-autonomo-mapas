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

datos$comunas = as.factor(datos$comunas)
datos$psupond = as.numeric(datos$psupond)

map@data = data.frame(map@data,datos[match(map@data[,"COD_COMUNA"],datos[,"COD_COMUNA"]),])

pal1 <- colorNumeric("Spectral",NULL)
pal2 <- colorNumeric("PiYG",NULL)

m <-leaflet(map) %>%
	addTiles() %>%
	addProviderTiles(providers$OpenStreetMap) %>%
	addPolygons(stroke = FALSE, 
                smoothFactor = 0.3, 
                fillOpacity = 0.8,
    	        fillColor = ~pal1(rnorm(346,0,1)),
    	        label = ~paste0(map$NOM_COM, ": ", formatC(map$psupond, big.mark = ",")),
                group = 'Vamos por Chile') %>%

	addPolygons(stroke = FALSE, 
                smoothFactor = 0.3, 
                fillOpacity = 0.8,
    	        fillColor = ~pal2(rnorm(346,0,1)),
    	        label = ~paste0(map$NOM_COM, ": ", formatC(map$psupond, big.mark = ",")),
                group = 'Lista del Apruebo') %>%
    addLayersControl(c("Vamos por Chile", "Lista del Apruebo"), 
        options = layersControlOptions(collapsed = FALSE))

m

saveWidget(m, file="index.html") 

