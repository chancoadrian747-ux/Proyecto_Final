# Proyecto_Final
## 1. Contexto del conjunto de datos

### Institución que proporciona los datos
**Banco Central de Reserva del Perú (BCRP)**

### Objetivo o temática del conjunto de datos
El presente análisis se basa en la **Tasa de Referencia de la Política Monetaria** del Perú, que constituye el principal instrumento de política monetaria utilizado por el BCRP para orientar las condiciones monetarias y financieras del país. Esta tasa sirve como guía para las tasas de interés del sistema financiero y es clave para controlar la inflación y estimular el crecimiento económico.

Adicionalmente, se incorpora el **Índice de Precios al Consumidor (IPC) Subyacente**, que mide la inflación excluyendo productos volátiles (alimentos y energía), permitiendo analizar la relación entre la tasa de interés y la inflación de largo plazo.

### Principales variables analizadas

| Variable | Tipo | Descripción |
|----------|------|-------------|
| `fecha` | Cualitativa ordinal | Mes y año del registro (ej. "Sep03") |
| `tasa_porcentaje` | Cuantitativa continua | Tasa de Referencia del BCRP en porcentaje (%) |
| `fecha_completa` | Cuantitativa (fecha) | Fecha en formato estándar (AAAA-MM-DD) |
| `año` | Cuantitativa discreta | Año calendario |
| `mes_numero` | Cuantitativa discreta | Número del mes (1 = Enero, ..., 12 = Diciembre) |
| `ipc_subyacente` | Cuantitativa continua | Índice de Precios al Consumidor Subyacente (base Dic.2021 = 100) |
| `inflacion_anual` | Cuantitativa continua | Inflación subyacente anual (%) |

### Periodo de análisis
- **Tasa de Referencia:** Septiembre 2003 - Julio 2026 (275 observaciones mensuales)
- **IPC Subyacente:** Enero 2003 - Junio 2026 (282 observaciones mensuales)
- **Datos anuales combinados:** 2004 - 2025 (22 años completos)

### Fuente de los datos
- Portal de Estadísticas del BCRP - BCRPData  
  https://estadisticas.bcrp.gob.pe
- Series utilizadas:
  - `PD04722MM`: Tasa de Referencia de la Política Monetaria
  - `PN38708PM`: IPC Subyacente - Lima Metropolitana
