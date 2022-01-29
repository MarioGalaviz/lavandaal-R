library(DBI)
library(lubridate)
library(dplyr)
library(ggplot2)
library(magrittr)
library(RGoogleAnalytics)
source("~/.Rprofile")

con <- dbConnect(RPostgres::Postgres(),
                 dbname = 'dcf8hlqhi8reh0',
                 host = 'ec2-3-216-113-109.compute-1.amazonaws.com',
                 port = 5432, 
                 user = 'qqpxqnmxtarcrc',
                 password = password.PSQL)


tablaOrdenes <- dbFetch(
  dbSendQuery(con, 'SELECT * FROM ordenes WHERE id_lavanderia != 1')
)

# Crear columnas: fecha en formato mes y día, y si tiene o no calificación
tablaOrdenes$fecha_creacion_formato <-
  format(as.Date(tablaOrdenes$fecha_creacion),  '%m-%d')
tablaOrdenes <- tablaOrdenes %>%
  mutate(tiene_calificacion = (!is.na(calificacion))*1)

# Tabla para calcular métricas: actualizaciones, calificaciones, valor y número de órdenes

tablaPromedios <- tablaOrdenes %>% group_by(fecha_creacion_formato) %>%
  summarize(actualizaciones_promedio = mean(actualizaciones), 
            tiene_calificacion = mean(tiene_calificacion)/n(),
            ingresos = sum(valor),
            ordenes = n()
            )
# Gráficas
ggplot(data=tablaPromedios, aes(fecha_creacion_formato, ordenes, group=1)) +
  geom_line()

ggplot(data=tablaPromedios, aes(fecha_creacion_formato, ingresos, group=1)) +
  geom_line()

## Conección a GA

client.secret <- client.secret.GA
client.id <- client.id.GA
view.id <- view.id.GA

if(!file.exists('./token')) {
  token <- Auth(client.id, client.secret)
  token <- save(token, file='./token')
} else {
  load('./token')
}


start.date <- '2022-01-28'

end.date <- '2022-01-28'

query.list <- Init(start.date = start.date,
                   end.date = end.date,
                   dimensions = "ga:hour,ga:dayOfWeek",
                   metrics = "ga:sessions",
                   table.id = view.id)

ga.query <- QueryBuilder(query.list)

ga.data <- GetReportData(ga.query, token)



