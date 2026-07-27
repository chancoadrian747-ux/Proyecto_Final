# ============================================================
# ANÁLISIS FINAL - PARTE 2
# Tasa de Referencia vs IPC Subyacente (Datos Anuales 2004-2025)
# ============================================================

# 1. CONFIGURACIÓN INICIAL
rm(list = ls())
library(tidyverse)
library(lubridate)
library(patchwork)

# 2. DICCIONARIO DE MESES
meses_espanol <- c("Ene", "Feb", "Mar", "Abr", "May", "Jun", 
                   "Jul", "Ago", "Sep", "Oct", "Nov", "Dic")
meses_ingles <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

# 3. IMPORTAR TASA DE REFERENCIA
tasa <- read.csv("data/Mensuales-20260725-161706.csv",
                 skip = 2,
                 header = FALSE,
                 col.names = c("fecha", "tasa"),
                 stringsAsFactors = FALSE) %>%
  mutate(
    tasa = as.numeric(tasa),
    mes_texto = substr(fecha, 1, 3),
    anio_texto = substr(fecha, 4, 5),
    mes_ingles = meses_ingles[match(mes_texto, meses_espanol)],
    fecha_texto = paste0("01-", mes_ingles, "-", anio_texto),
    fecha_completa = dmy(fecha_texto),
    año = year(fecha_completa),
    mes = month(fecha_completa)
  ) %>%
  select(fecha, tasa, año, mes) %>%
  rename(tasa_porcentaje = tasa)

# 4. IMPORTAR IPC SUBYACENTE
ipc_sub <- read.csv("data/Mensuales-20260726-095743.csv",
                    skip = 2,
                    header = FALSE,
                    col.names = c("fecha", "ipc_subyacente"),
                    stringsAsFactors = FALSE) %>%
  mutate(
    ipc_subyacente = as.numeric(ipc_subyacente),
    mes_texto = substr(fecha, 1, 3),
    anio_texto = substr(fecha, 4, 5),
    mes_ingles = meses_ingles[match(mes_texto, meses_espanol)],
    fecha_texto = paste0("01-", mes_ingles, "-", anio_texto),
    fecha_completa = dmy(fecha_texto),
    año = year(fecha_completa),
    mes = month(fecha_completa)
  ) %>%
  select(fecha, ipc_subyacente, año, mes)

# 5. COMBINAR Y FILTRAR
datos <- tasa %>%
  inner_join(ipc_sub, by = c("año", "mes")) %>%
  select(año, mes, tasa_porcentaje, ipc_subyacente) %>%
  filter(año < 2026)

# 6. CALCULAR DATOS ANUALES (2004-2025)
datos_anuales <- datos %>%
  group_by(año) %>%
  summarise(
    tasa_promedio = mean(tasa_porcentaje, na.rm = TRUE),
    ipc_dic = ipc_subyacente[mes == 12]
  ) %>%
  filter(!is.na(ipc_dic)) %>%
  arrange(año) %>%
  mutate(
    ipc_dic_anterior = lag(ipc_dic),
    inflacion_anual = (ipc_dic / ipc_dic_anterior - 1) * 100
  ) %>%
  filter(!is.na(inflacion_anual))

# 7. ESTADÍSTICAS
cat("\n TASA DE REFERENCIA PROMEDIO ANUAL (2004-2025)\n")
print(summary(datos_anuales$tasa_promedio))

cat("\n INFLACIÓN SUBYACENTE ANUAL (2004-2025)\n")
print(summary(datos_anuales$inflacion_anual))

# 8. CORRELACIÓN
correlacion <- cor(datos_anuales$tasa_promedio, 
                   datos_anuales$inflacion_anual)
cat("\n CORRELACIÓN:", round(correlacion, 4), "\n")

# 9. TABLA RESUMEN
tabla <- datos_anuales %>%
  select(año, tasa_promedio, inflacion_anual) %>%
  mutate(
    tasa_promedio = round(tasa_promedio, 2),
    inflacion_anual = round(inflacion_anual, 2)
  )
print(tabla)
write.csv(tabla, "data/tabla_resumen_anual.csv", row.names = FALSE)

# 10. GRÁFICO 1: Evolución anual
g1 <- ggplot(datos_anuales, aes(x = año)) +
  geom_line(aes(y = tasa_promedio, color = "Tasa de Referencia"), size = 1.2) +
  geom_point(aes(y = tasa_promedio, color = "Tasa de Referencia"), size = 2.5) +
  geom_line(aes(y = inflacion_anual, color = "Inflación Subyacente"), size = 1.2) +
  geom_point(aes(y = inflacion_anual, color = "Inflación Subyacente"), size = 2.5) +
  scale_color_manual(values = c("Tasa de Referencia" = "#2c3e50", 
                                "Inflación Subyacente" = "#e74c3c")) +
  labs(
    title = "Evolución Anual: Tasa de Referencia vs Inflación Subyacente",
    subtitle = "Periodo: 2004 - 2025",
    x = "Año",
    y = "Tasa / Inflación (%)",
    color = "Variable",
    caption = "Fuente: BCRP | Elaboración: Propia"
  ) +
  theme_minimal()

ggsave("figures/04_evolucion_anual_final.png", g1, width = 10, height = 6, dpi = 300)

# 11. GRÁFICO 2: Relación (Scatter)
g2 <- ggplot(datos_anuales, aes(x = inflacion_anual, y = tasa_promedio)) +
  geom_point(size = 4, alpha = 0.7, color = "#3498db") +
  geom_text(aes(label = año), vjust = -1, size = 3, alpha = 0.6) +
  geom_smooth(method = "lm", color = "#e74c3c", se = TRUE, fill = "#f5b7b1") +
  labs(
    title = "Relación Anual: Tasa vs Inflación Subyacente",
    subtitle = "Cada punto representa un año (2004-2025)",
    x = "Inflación Subyacente Anual (%)",
    y = "Tasa de Referencia Promedio Anual (%)",
    caption = "Fuente: BCRP | Elaboración: Propia"
  ) +
  theme_minimal()

ggsave("figures/05_relacion_final.png", g2, width = 10, height = 6, dpi = 300)

# 12. COLLAGE FINAL
collage <- (g1 / g2) +
  plot_annotation(
    title = "Análisis Final: Tasa de Referencia vs IPC Subyacente",
    subtitle = "Banco Central de Reserva del Perú (2004-2025)",
    caption = "Fuente: BCRP | Elaboración: Propia"
  )

ggsave("figures/collage_analisis_final.png", collage, width = 12, height = 10, dpi = 300)

