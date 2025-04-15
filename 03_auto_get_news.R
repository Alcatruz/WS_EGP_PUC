




# SCRAPEAR PÁGINAS 1 A 30 USANDO FOR, CON %>% LIMPIO Y PRINT DE AVANCE ---
# Este bloque recorre páginas del buscador de CNN Chile (por ejemplo, "crimen"),
# scrapea noticias desde cada página, y acumula todo en un tibble `noticias`.

library(tidyverse)
library(rvest)

ultima_pagina <- 30

noticias <- data.frame()

for (i in 1:ultima_pagina) {
  url <- paste0("https://www.cnnchile.com/search/crimen/page/", i, "/")
  print(paste("Procesando página", i, ":", url))
  
  pagina <- tryCatch(read_html(url), error = function(e) return(NULL))
  if (is.null(pagina)) next
  
  articulos <- html_nodes(pagina, "article")
  
  noticias_pagina <- tibble(
    titulo = html_nodes(articulos, "h2 a") %>% html_text2(),
    link   = html_nodes(articulos, "h2 a") %>% html_attr("href"),
    bajada = html_nodes(articulos, "p a") %>% html_text2(),
    fecha  = html_nodes(articulos, "h4") %>% html_text2()
  ) %>%
    separate(fecha, into = c("fecha_publicacion", "hora_publicacion"), sep = " ")
  
  
  noticias <- bind_rows(noticias, noticias_pagina)
}






noticias <- noticias %>%
  rowwise() %>%
  mutate(cuerpo = obtener_cuerpo_noticia(link)) %>%
  ungroup()








