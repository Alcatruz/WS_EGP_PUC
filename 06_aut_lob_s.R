





obtain_audiencias_senate <- function(years) {
  base_url <- "https://www.senado.cl/appsenado/index.php?mo=lobby&ac=GetReuniones&anho="
  all_audiencias <- tibble()
  for (year in years) {
    url <- paste0(base_url, year)
    audiencias_url <- read_html(url)
    audiencias <- audiencias_url %>% 
      html_nodes("table") %>% 
      html_table()
    audiencias <- tibble(audiencias[[2]])
    audiencias <- clean_names(audiencias)
    audiencias <- audiencias %>% 
      separate(fecha_duracion_lugar, c("fecha", "duracion", "lugar"), "  ", extra = "merge")
    audiencias$fecha <- as_date(audiencias$fecha)
    audiencias <- audiencias %>% 
      mutate(duracion = str_remove(duracion, " Min."),
             duracion = as.numeric(duracion),
             year = year)
    all_audiencias <- bind_rows(all_audiencias, audiencias)
  }
  return(all_audiencias)
}



years <- 2022:2025

audiencias_senado <- obtain_audiencias_senate(years)

audiencias_senado


names(audiencias_senado)
names(noticias)

library(tidyverse)
library(lubridate)

audiencias_senado <- audiencias_senado %>%
  mutate(fecha = ymd(fecha),
         categoria = "lobby",
         cuerpo = materia)

noticias <- noticias %>%
  mutate(fecha = dmy(fecha_publicacion),
         categoria = "noticia")

texto_unificado <- bind_rows(
  audiencias_senado %>% select(fecha, cuerpo, categoria),
  noticias %>% select(fecha, cuerpo, categoria)
)


texto_unificado <- texto_unificado %>%
  mutate(id = paste0("TXT", str_pad(row_number(), width = 4, pad = "0")))


write_rds(texto_unificado, "df_task1.rds")

conteo_mensual <- texto_unificado %>%
  mutate(
    year = year(fecha),
    month = month(fecha, label = TRUE, abbr = TRUE),
    ym = floor_date(fecha, unit = "month")
  ) %>%
  count(categoria, ym)  # conteo por categoría y mes

library(ggplot2)
ggplot(conteo_mensual, aes(x = ym, y = n, color = categoria)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  scale_x_date(date_labels = "%Y-%m", date_breaks = "1 month") +
  scale_y_continuous(limits = c(0,80))+
  scale_color_manual(values = c("noticia" = "steelblue", "lobby" = "purple")) +
  labs(title = "Cantidad de textos por mes y categoría",
       x = "Fecha (Año-Mes)",
       y = "Cantidad de registros",
       color = "Categoría") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Cambia angle a 90 si quieres vertical
