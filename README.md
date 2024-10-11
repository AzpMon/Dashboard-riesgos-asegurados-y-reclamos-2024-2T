# Dashboard-riesgos-asegurados-y-reclamos-2024-2T


## Descripción del Proyecto
Este proyecto está enfocado en el análisis y visualización de datos relacionados con riesgos asegurados y reclamos, utilizando un enfoque técnico avanzado en SQL, manipulación de datos con pandas y visualización interactiva en Power BI.

## Proceso y Tecnologías Utilizadas
1. Descarga y Preparación de Datos:

* Los datos iniciales se encontraban en un archivo Excel con múltiples hojas, cada una relacionada con diferentes aspectos de riesgos asegurados y reclamos.
* Se utilizó pandas para leer las diferentes hojas, seleccionar la información relevante y generar archivos CSV individuales para cada una de ellas.


2. Automatización de la Carga a SQL Server:

* En lugar de cargar manualmente los CSV en SQL Server, se implementó un código avanzado en SQL que automatiza la carga de los archivos al servidor.
* Se utilizó SQL Server Management Studio (SSMS) para ejecutar este código, agilizando la gestión y manipulación de los datos.


3. Obtención de Datos Externos mediante Web Scraping:

* Para complementar los datos existentes, se realizó web scraping con BeautifulSoup para extraer información sobre la población y el PIB por estado de México desde Wikipedia.
* Se  limpió y estructuró estos datos para integrarlos en el análisis general.


4. Transformación y Limpieza de Datos en SQL:

* Se utilizó Common Table Expressions (CTE) y uniones complejas en SQL para realizar una limpieza exhaustiva y estructuración de los datos, preparando los mismos para su visualización en el dashboard.


5. Creación del Dashboard Interactivo en Power BI:

* Con los datos procesados, se creó un dashboard interactivo en Power BI que permite explorar los riesgos asegurados y los reclamos.
* Finalmente, el dashboard fue exportado a PowerPoint para facilitar su presentación y distribución.


## Habilidades Técnicas Aplicadas
* SQL Avanzado: Automatización de carga de CSVs, transformaciones complejas y limpieza de datos.
* Power BI (Intermedio): Creación de un dashboard interactivo y dinámico.
* Pandas (Python): Manipulación y limpieza de datos en múltiples hojas de Excel.
* Web Scraping: Extracción de datos con BeautifulSoup y su posterior limpieza.
