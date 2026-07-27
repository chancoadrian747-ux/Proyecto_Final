# ============================================================
# ANÁLISIS EXPLORATORIO DE DATOS (EDA)
# Tasa de Referencia vs IPC Subyacente (Datos Anuales)
# ============================================================

# 1. CONFIGURACIÓN INICIAL
rm(list = ls())
library(tidyverse)
library(lubridate)
library(patchwork)

# 2. DICCIONARIO DE MESES (Español → Inglés)
meses_espanol <- c("Ene", "Feb", "Mar", "Abr", "May", "Jun", 
                   "Jul", "Ago", "Sep", "Oct", "Nov", "Dic")
meses_ingles <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

# ============================================================
# 3. IMPORTAR TASA DE REFERENCIA
# ============================================================

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

# 5. COMBINAR AMBAS BASES POR AÑO Y MES
datos <- tasa %>%
  inner_join(ipc_sub, by = c("año", "mes")) %>%
  select(año, mes, tasa_porcentaje, ipc_subyacente)

# 6. FILTRAR AÑOS COMPLETOS (excluir 2026 porque no tiene diciembre)
datos <- datos %>%
  filter(año < 2026)  # <--- SOLUCIÓN DEFINITIVA

# 7. CALCULAR DATOS ANUALES
datos_anuales <- datos %>%
  group_by(año) %>%
  summarise(
    # Tasa de Referencia: promedio anual
    tasa_promedio = mean(tasa_porcentaje, na.rm = TRUE),
    tasa_min = min(tasa_porcentaje, na.rm = TRUE),
    tasa_max = max(tasa_porcentaje, na.rm = TRUE),
    # IPC Subyacente: valor en diciembre
    ipc_dic = ipc_subyacente[mes == 12]
  ) %>%
  filter(!is.na(ipc_dic))  # Eliminar años sin diciembre

# 8. CALCULAR INFLACIÓN ANUAL
datos_anuales <- datos_anuales %>%
  arrange(año) %>%
  mutate(
    ipc_dic_anterior = lag(ipc_dic),
    inflacion_anual = (ipc_dic / ipc_dic_anterior - 1) * 100
  ) %>%
  filter(!is.na(inflacion_anual))  # Eliminar el primer año

# 9. VERIFICAR DATOS ANUALES
cat("\n DATOS ANUALES (primeras filas):\n")
print(head(datos_anuales))

cat("\n AÑOS ANALIZADOS:\n")
print(datos_anuales$año)

# 10. GUARDAR DATOS ANUALES
write.csv(datos_anuales, "data/datos_anuales.csv", row.names = FALSE)

# 11. ESTADÍSTICAS DESCRIPTIVAS
cat("\n ESTADÍSTICAS - TASA DE REFERENCIA PROMEDIO ANUAL\n")
print(summary(datos_anuales$tasa_promedio))

cat("\n ESTADÍSTICAS - INFLACIÓN SUBYACENTE ANUAL\n")
print(summary(datos_anuales$inflacion_anual))

# Medidas específicas
media_tasa <- mean(datos_anuales$tasa_promedio, na.rm = TRUE)
mediana_tasa <- median(datos_anuales$tasa_promedio, na.rm = TRUE)
min_tasa <- min(datos_anuales$tasa_promedio, na.rm = TRUE)
max_tasa <- max(datos_anuales$tasa_promedio, na.rm = TRUE)

media_inflacion <- mean(datos_anuales$inflacion_anual, na.rm = TRUE)
mediana_inflacion <- median(datos_anuales$inflacion_anual, na.rm = TRUE)
min_inflacion <- min(datos_anuales$inflacion_anual, na.rm = TRUE)
max_inflacion <- max(datos_anuales$inflacion_anual, na.rm = TRUE)

cat("\n TASA DE REFERENCIA PROMEDIO ANUAL:\n")
cat("   Media:", round(media_tasa, 2), "%\n")
cat("   Mediana:", round(mediana_tasa, 2), "%\n")
cat("   Mínimo:", round(min_tasa, 2), "%\n")
cat("   Máximo:", round(max_tasa, 2), "%\n")

cat("\n INFLACIÓN SUBYACENTE ANUAL:\n")
cat("   Media:", round(media_inflacion, 2), "%\n")
cat("   Mediana:", round(mediana_inflacion, 2), "%\n")
cat("   Mínimo:", round(min_inflacion, 2), "%\n")
cat("   Máximo:", round(max_inflacion, 2), "%\n")

# 12. CORRELACIÓN
datos_cor <- datos_anuales %>%
  select(tasa_promedio, inflacion_anual) %>%
  na.omit()

correlacion <- cor(datos_cor$tasa_promedio, datos_cor$inflacion_anual)
cat("\n Correlación entre Tasa e Inflación:", round(correlacion, 4), "\n")

# 13. GRÁFICO 1: Evolución anual de Tasa e Inflación
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
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5),
    axis.title = element_text(size = 11, face = "bold"),
    legend.position = "bottom"
  )

print(g1)
ggsave("figures/01_evolucion_anual.png", g1, width = 10, height = 6, dpi = 300)

# 14. GRÁFICO 2: Relación entre Tasa e Inflación (Scatter)
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
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5),
    axis.title = element_text(size = 11, face = "bold")
  )

print(g2)
ggsave("figures/02_relacion_anual.png", g2, width = 10, height = 6, dpi = 300)

# 15. GRÁFICO 3: Boxplot de Tasa por Rango de Inflación
datos_anuales <- datos_anuales %>%
  mutate(
    rango_inflacion = case_when(
      inflacion_anual < 2 ~ "Inflación Baja (< 2%)",
      inflacion_anual >= 2 & inflacion_anual < 4 ~ "Inflación Moderada (2-4%)",
      inflacion_anual >= 4 & inflacion_anual < 6 ~ "Inflación Alta (4-6%)",
      inflacion_anual >= 6 ~ "Inflación Muy Alta (> 6%)"
    ),
    rango_inflacion = factor(rango_inflacion, 
                             levels = c("Inflación Baja (< 2%)", 
                                        "Inflación Moderada (2-4%)",
                                        "Inflación Alta (4-6%)",
                                        "Inflación Muy Alta (> 6%)"))
  )

g3 <- ggplot(datos_anuales, aes(x = rango_inflacion, y = tasa_promedio, fill = rango_inflacion)) +
  geom_boxplot(alpha = 0.7) +
  scale_fill_manual(values = c("Inflación Baja (< 2%)" = "#2ecc71",
                               "Inflación Moderada (2-4%)" = "#3498db",
                               "Inflación Alta (4-6%)" = "#f39c12",
                               "Inflación Muy Alta (> 6%)" = "#e74c3c")) +
  labs(
    title = "Tasa de Referencia según Rango de Inflación Anual",
    subtitle = "Periodo: 2004-2025",
    x = "Rango de Inflación Subyacente Anual",
    y = "Tasa de Referencia Promedio Anual (%)",
    caption = "Fuente: BCRP | Elaboración: Propia"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5),
    axis.title = element_text(size = 11, face = "bold"),
    legend.position = "none"
  )

print(g3)
ggsave("figures/03_tasa_segun_inflacion.png", g3, width = 10, height = 6, dpi = 300)

# 16. COLLAGE DE GRÁFICOS
collage <- (g1 / (g2 | g3)) +
  plot_annotation(
    title = "Análisis Exploratorio: Tasa de Referencia vs IPC Subyacente",
    subtitle = "Datos Anuales (2004-2025)",
    caption = "Fuente: BCRP | Elaboración: Propia"
  ) &
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    plot.caption = element_text(size = 10, hjust = 0, face = "italic")
  )

print(collage)
ggsave("figures/collage_graficos.png", collage, width = 14, height = 12, dpi = 300)


