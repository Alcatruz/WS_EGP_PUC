# Web Scraping de Noticias – CNN Chile

Este repositorio contiene un conjunto de scripts en **R** para realizar *web scraping* automatizado de noticias desde el buscador de **CNN Chile**. A partir de una palabra clave como `"crimen"`, el flujo permite extraer los **títulos**, **links**, **bajadas**, **fechas** y el **contenido completo** de cada noticia, recorriendo múltiples páginas de resultados.

El proyecto está organizado en **bloques secuenciales**, cada uno contenido en archivos separados:

- **`01_intro_rvest.R`**: lectura básica y extracción paso a paso desde una página de resultados.  
- **`02_get_body_news.R`**: función para obtener el cuerpo completo de una noticia desde su link.  
- **`03_auto_get_news.R`**: scraping automatizado de varias páginas usando `for`.  
- **`04_for_ap.R`**: aplicación final para recuperar el cuerpo de cada noticia a partir de los links obtenidos.

Cada script puede ejecutarse de forma independiente o integrarse en un flujo completo para análisis de texto o almacenamiento posterior.

> Requiere los paquetes: **`rvest`**, **`tidyverse`** y **`stringr`**.  
> Compatible con R >= 4.1.
