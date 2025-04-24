
lobby_dips <- readRDS("~/work/2020_w/BD_PA/lobby_dips.rds")
lobby_dips <- readRDS("lobby_dips.rds")


library(tidyverse) 
library(tidytext)
library(quanteda) 
library(quanteda.textstats)
library(quanteda.textplots)
library(readxl) 
library(kableExtra) 
library(quanteda)
library(quanteda.textmodels) 
library(qdapRegex) 


f_remove_accent <- function(x){
  x %>% 
    str_replace_all("á", "a") %>% 
    str_replace_all("é", "e") %>% 
    str_replace_all("í", "i") %>% 
    str_replace_all("ó", "o") %>% 
    str_replace_all("ú", "u") %>% 
    str_replace_all("ñ", "n")
}

lobby_df <- lobby_dips %>% 
  mutate(texto = materia %>%
           str_remove("\\@[[:alnum:]]+") %>% 
           str_remove_all("http[\\w[:punct:]]+") %>% 
           str_to_lower() %>%
           str_remove_all("[\\d\\.,_\\@]+") %>% 
           f_remove_accent() %>%
           rm_non_ascii() 
  )



library(stopwords)

stopwords1 <- get_stopwords(language = "es")
stopwords2 <- data.frame(word=stopwords::stopwords("es", "stopwords-iso"))
stopwords3 <- data.frame(word=c("anos","ano","abajomas","suscribete","suscriptores","href","div",".",
                                "false","style","font","traves","br","proyecto","ley",
                                "may","continua","chile","comentarios","chilenos","seccion",
                                "columna","lt","caso","exclusivos","columna","mundo"))




stp <- bind_rows(stopwords1, stopwords2, stopwords3)
lobby_df_words <- lobby_df %>%
  unnest_tokens(output = "word", input = "texto") %>%
  anti_join(stp, by = "word")


library(ggwordcloud)

data_wordcloud <- lobby_df_words %>% 
  count(word) %>% 
  arrange(-n) %>% 
  slice(1:40)

ggplot(data_wordcloud, 
       aes(label = word, size = n)) + 
  geom_text_wordcloud() +
  scale_size_area(max_size = 8) +  
  theme_void()




lobby_df_words <- lobby_df_words %>%
  mutate(ed = case_when(str_detect(word, "educacion") ~ 1, 
                            str_detect(word, "simce") ~ 1, 
                            str_detect(word, "psu") ~ 1,
                            str_detect(word, "colegio") ~ 1,
                            str_detect(word, "slep")~ 1,
                            TRUE ~ 0)) %>% 
  mutate(ed = as.character(ed))



library(stringr)

lobby_dips <- lobby_dips %>%
  mutate(ed_has = if_else(
    str_detect(materia, "educacion|simce|psu|colegio|slep"),
    "1", "0"
  ))


lobby_dips <- lobby_dips %>%
  mutate(ed_has = if_else(
    str_detect(materia, "educacion|simce|psu|colegio|slep"),
    "Educación", "Otro"
  ))


