



library(rvest) 
library(janitor) 
library(lubridate)
library(stringr)
library(readr)

obtain_audiencias_senate <- function(last_url){
  audiencias_url <- read_html(last_url)
  audiencias <- audiencias_url %>% 
    html_nodes("table") %>% 
    html_table()
  audiencias <- tibble(audiencias[[2]])
  audiencias <- janitor::clean_names(audiencias)
  audiencias <- audiencias %>% 
    separate(fecha_duracion_lugar, c("fecha", "duracion", "lugar"), "  ", extra = "merge")
  audiencias$fecha <- lubridate::as_date(audiencias$fecha)
  audiencias <- audiencias %>% 
    mutate(duracion = str_remove(duracion, " Min."), 
           duracion = as.numeric(duracion))
}



audiencias_senado_2014 <- obtain_audiencias_senate("https://www.senado.cl/appsenado/index.php?mo=lobby&ac=GetReuniones&anho=2014")
audiencias_senado_2014







