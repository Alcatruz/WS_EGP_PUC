





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
