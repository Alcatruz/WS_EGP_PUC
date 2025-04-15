


# APLICAR LA FUNCIÓN `obtener_cuerpo_noticia()` A CADA LINK CON FOR Y PRINT ---
# Este bloque recorre cada fila del tibble `noticias`,
# aplica la función `obtener_cuerpo_noticia()` sobre el link correspondiente,
# y almacena el resultado en una nueva columna `cuerpo`.

# Asegurarse de tener columna vacía
noticias$cuerpo <- NA_character_

# Recorrer fila por fila
for (i in 1:nrow(noticias)) {
  print(paste("Procesando cuerpo de noticia", i, "de", nrow(noticias)))
  noticias$cuerpo[i] <- obtener_cuerpo_noticia(noticias$link[i])
}

