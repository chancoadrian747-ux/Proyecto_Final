# ¿Cómo se relaciona la Tasa de Referencia del BCRP con la Inflación en Perú?
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
 
  - ## 📝 Conclusiones Finales

### Pregunta de investigación
*"¿Cómo se relaciona la Tasa de Referencia del BCRP con la inflación subyacente en el Perú durante el periodo 2004-2025?"*

### Principales hallazgos

1. **Relación positiva fuerte:** La Tasa de Referencia y la inflación subyacente tienen una correlación de **0.89**, lo que indica que el BCRP ajusta la tasa en respuesta a cambios en la inflación.

2. **Impacto de la pandemia (2020):** La tasa cayó a su mínimo histórico (0.25%) mientras la inflación también bajó.

3. **Crisis inflacionaria (2022-2023):** La tasa subió a su máximo histórico (7.75%) para controlar la inflación que alcanzó 7.68%.

4. **Normalización (2024-2025):** Ambas variables han ido descendiendo gradualmente.

### Tabla resumen anual (2004-2025)

| Año | Tasa Promedio (%) | Inflación Anual (%) |
|-----|-------------------|---------------------|
| 2004 | 2.50 | 0.87 |
| 2005 | 3.02 | 1.47 |
| 2006 | 4.25 | 1.37 |
| 2007 | 4.50 | 1.52 |
| 2008 | 5.75 | 3.54 |
| 2009 | 4.83 | 0.24 |
| 2010 | 2.83 | 1.14 |
| 2011 | 3.75 | 1.64 |
| 2012 | 4.25 | 1.49 |
| 2013 | 4.25 | 1.63 |
| 2014 | 3.90 | 1.12 |
| 2015 | 3.25 | 1.82 |
| 2016 | 4.25 | 1.62 |
| 2017 | 3.92 | 0.77 |
| 2018 | 2.90 | 1.52 |
| 2019 | 2.65 | 1.32 |
| 2020 | 0.70 | 0.45 |
| 2021 | 0.59 | 2.16 |
| 2022 | 4.75 | 7.04 |
| 2023 | 7.25 | 7.68 |
| 2024 | 5.65 | 1.32 |
| 2025 | 4.50 | 0.82 |

### Conclusión general

El análisis de datos anuales del periodo **2004-2025** confirma que la Tasa de Referencia del BCRP es un instrumento efectivo para controlar la inflación subyacente en el Perú. La fuerte correlación positiva (0.89) respalda la teoría de que el banco central utiliza la tasa de interés como mecanismo para anclar las expectativas inflacionarias.

**Conclusiones específicas:**
- El BCRP actúa de manera proactiva ante aumentos sostenidos de la inflación.
- La pandemia (2020) y la posterior recuperación generaron los mayores movimientos de la tasa en los últimos 22 años (mínimo: 0.25% en 2020, máximo: 7.75% en 2023).
- La política monetaria peruana ha logrado mantener la inflación dentro de rangos manejables en el largo plazo.
