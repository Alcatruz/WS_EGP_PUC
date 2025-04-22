


# EXTRAER MANUALMENTE ELEMENTOS DE UNA PÁGINA DE RESULTADOS CNN CHILE ---
# Este bloque lee una página del buscador y extrae paso a paso:
# - los títulos de noticias
# - los links
# - las bajadas
# - las fechas completas
# Luego todo se combina en un tibble final llamado `noticias`.

library(tidyverse)
library(rvest)

# Leer HTML de la página 2 del término "crimen", la idea es que busquemos algo de nuestro tema 
url <- "https://www.cnnchile.com/search/crimen/page/2/"
pagina <- read_html(url)

# Extraer cada parte por separado
articulos <- html_nodes(pagina, "article")

titulos <- html_nodes(articulos, "h2 a") %>% html_text2()
titulos

links   <- html_nodes(articulos, "h2 a") %>% html_attr("href")
links

bajadas <- html_nodes(articulos, "p a") %>% html_text2()
bajadas

fechas  <- html_nodes(articulos, "h4") %>% html_text2()
fechas

# Combinar en tibble
noticias <- tibble(
  titulo = titulos,
  link = links,
  bajada = bajadas,
  fecha = fechas
) %>%
  separate(fecha, into = c("fecha_publicacion", "hora_publicacion"), sep = " ")

