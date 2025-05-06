

# usaremos quanteda
# 1. Crear un corpus con quanteda a partir del texto procesado
# Un corpus es la estructura base que contiene los textos y sus metadatos
# 2. Tokenizar los textos del corpus
# Se divide cada texto en unidades básicas (tokens), como palabras individuales,
# eliminando números, puntuación y URLs
# 3. Eliminar palabras vacías (stopwords)
# Se eliminan palabras muy comunes que no aportan significado (como "el", "la", "de")
# 4. Crear una matriz documento-término (DFM)
# La DFM es una tabla que cuenta cuántas veces aparece cada palabra (término)
# en cada documento (audiencia de lobby)
# 5. Calcular TF-IDF a partir de la DFM
# TF-IDF pondera las palabras frecuentes en cada documento y les resta peso si aparecen en muchos documentos
# Esto ayuda a identificar palabras distintivas
# 6. Visualizar las palabras más relevantes por grupo (usando TF-IDF)
# Se extraen las 15 palabras con mayor frecuencia ponderada (TF-IDF) para cada grupo definido
# por una variable llamada `pos_pol` (posición política)



lobby_corpus <- corpus(lobby_df,
                       text_field = "texto",
                       unique_docnames = TRUE)


summary(lobby_corpus)



lobby_toks <- tokens(lobby_corpus,
                     remove_numbers = TRUE, 
                     remove_punct = TRUE, 
                     remove_url = TRUE) 




lobby_toks <- tokens_remove(lobby_toks,
                            c(stopwords::stopwords("es", "stopwords-iso")),
                            padding = F)


lobby_dfm <- dfm(lobby_toks)
lobby_dfm



lobby_dfm_tfidf <- dfm_tfidf(lobby_dfm)

library(ggplot2)
library(ggtext) # opcional para textos enriquecidos
library(scales) # por si necesitas más control de ejes

#TF (Term Frequency): mide cuántas veces aparece una palabra en un documento.

#IDF (Inverse Document Frequency): le baja la importancia a las palabras que aparecen en muchos documentos (porque no ayudan a distinguirlos).

lobby_dfm_tfidf %>%
  textstat_frequency(n = 15, groups = c(pos_pol), force = TRUE) %>%
  ggplot(aes(x = reorder_within(feature, frequency, group),
             y = frequency,
             fill = group,
             color = group)) +
  geom_col(alpha = 0.7) +
  coord_flip() +
  facet_wrap(~group, scales = "free") +
  scale_x_reordered() +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  theme_minimal() +
  labs(x = "", y = "TF-IDF", color = NULL, fill = NULL) +
  theme(legend.position = "none",
        strip.text = element_text(face = "bold"))










lobby_dfm_ts_mts <- dfm_subset(lobby_dfm)

lobby_key <- textstat_keyness(lobby_dfm_ts_mts, 
                              target = lobby_dfm_ts_mts$pos_pol == "Derecha")
textplot_keyness(lobby_key)
