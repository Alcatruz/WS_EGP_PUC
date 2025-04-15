



# --- BLOQUE 2: DEFINIR FUNCIÓN PARA EXTRAER EL CUERPO DE UNA NOTICIA DESDE SU LINK ---
# Esta función toma la URL de una noticia y extrae todos los párrafos `<p>`,
# los concatena en un único string, y devuelve el texto.
# Si algo falla, devuelve NA silenciosamente.

obtener_cuerpo_noticia <- function(url) {
  tryCatch({
    pagina <- read_html(url)
    
    parrafos <- pagina %>%
      html_nodes("p") %>%
      html_text(trim = TRUE)
    
    cuerpo <- paste(parrafos, collapse = " ")
    
    return(cuerpo)
  },
  error = function(e) NA)
}

# aplicamos nuestra funcion

noticias <- noticias %>%
  rowwise() %>%
  mutate(cuerpo = obtener_cuerpo_noticia(link)) %>%
  ungroup()


