library(tidyverse)
library(openxlsx)
library(ggthemes)

# Ard??????k G??n (CDD / CWD) Hesaplamak ????in Yard??mc?? Fonksiyon
calculate_spell <- function(vector, condition_func, spell_type) {
  res <- numeric(length(vector))
  current_spell <- 0
  for (i in seq_along(vector)) {
    if (!is.na(vector[i]) && condition_func(vector[i])) {
      current_spell <- current_spell + 1
    } else {
      current_spell <- 0
    }
    res[i] <- current_spell
  }
  if (spell_type == "max") {
    # Y??ll??k maksimum ard??????k g??n i??in y??ll??k gruplamada max al??nacak
    return(res)
  }
  return(res)
}

# 1. Y??ll??k Bazda ETCCDI Ekstrem ??ndekslerinin Hesaplanmas??
etccdi_indices <- panel_df %>%
  group_by(province, YEAR = year(date)) %>%
  filter(!is.na(PRECTOTCORR)) %>%
  mutate(
    # R95p ve R99p i??in referans d??nem (??rne??in 1991-2020) bazl?? %95 ve %99 e??ikleri
    # Burada pratik olarak t??m seri i??indeki ya??????l?? g??nlerin (>1mm) y??zdelikleri al??n??r:
    p95_thresh = quantile(PRECTOTCORR[PRECTOTCORR >= 1.0], 0.95, na.rm = TRUE),
    p99_thresh = quantile(PRECTOTCORR[PRECTOTCORR >= 1.0], 0.99, na.rm = TRUE)
  ) %>%
  summarise(
    PRCPTOT = sum(PRECTOTCORR[PRECTOTCORR >= 1.0], na.rm = TRUE), # Toplam ya??????l?? g??n ya????????
    Rx1day  = max(PRECTOTCORR, na.rm = TRUE),                     # En y??ksek 1 g??nl??k ya??????
    Rx5day  = max(zoo::rollsum(PRECTOTCORR, k = 5, fill = NA, align = "right"), na.rm = TRUE), # En y??ksek 5 g??nl??k
    R10mm   = sum(PRECTOTCORR >= 10.0, na.rm = TRUE),             # >= 10 mm g??n say??s??
    R20mm   = sum(PRECTOTCORR >= 20.0, na.rm = TRUE),             # >= 20 mm g??n say??s??
    R95p    = sum(PRECTOTCORR[PRECTOTCORR > p95_thresh], na.rm = TRUE), # ??ok ya??????l?? g??nler toplam??
    R99p    = sum(PRECTOTCORR[PRECTOTCORR > p99_thresh], na.rm = TRUE), # A????r?? ya??????l?? g??nler toplam??
    Rainy_Days = sum(PRECTOTCORR >= 1.0, na.rm = TRUE),
    SDII    = PRCPTOT / ifelse(Rainy_Days == 0, 1, Rainy_Days),   # Ya?????? yo??unlu??u
    # CDD (Consecutive Dry Days: < 1mm) ve CWD (Consecutive Wet Days: >= 1mm) max hesaplar??:
    CDD     = max(rle(PRECTOTCORR < 1.0)$lengths[rle(PRECTOTCORR < 1.0)$values], na.rm = TRUE),
    CWD     = max(rle(PRECTOTCORR >= 1.0)$lengths[rle(PRECTOTCORR >= 1.0)$values], na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    CDD = ifelse(is.infinite(CDD), 0, CDD),
    CWD = ifelse(is.infinite(CWD), 0, CWD)
  )

# 2. Excel ????kt??s?? Alma
wb <- createWorkbook()
addWorksheet(wb, "ETCCDI_Extreme_Precip")
writeData(wb, "ETCCDI_Extreme_Precip", etccdi_indices)
saveWorkbook(wb, "East_BlackSea_ETCCDI_Extremes.xlsx", overwrite = TRUE)

# 3. T??M GRAF??KLER?? TEK TEK ????ZD??RME (Print Komutlar?? ile)

# Grafik 1: Rx1day (Max 1-Day Precipitation)
p1 <- ggplot(etccdi_indices, aes(x = YEAR, y = Rx1day, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "ETCCDI: Rx1day (Max 1-Day Precipitation)", x = "Year", y = "mm", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p1)

# Grafik 2: Rx5day (Max 5-Day Precipitation)
p2 <- ggplot(etccdi_indices, aes(x = YEAR, y = Rx5day, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "ETCCDI: Rx5day (Max 5-Day Precipitation)", x = "Year", y = "mm", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p2)

# Grafik 3: R10mm (Heavy Precipitation Days)
p3 <- ggplot(etccdi_indices, aes(x = YEAR, y = R10mm, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "ETCCDI: R10mm (Days >= 10mm)", x = "Year", y = "Days", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p3)

# Grafik 4: R20mm (Very Heavy Precipitation Days)
p4 <- ggplot(etccdi_indices, aes(x = YEAR, y = R20mm, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "ETCCDI: R20mm (Days >= 20mm)", x = "Year", y = "Days", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p4)

# Grafik 5: R95p (Very Wet Days Total)
p5 <- ggplot(etccdi_indices, aes(x = YEAR, y = R95p, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "ETCCDI: R95p (Very Wet Days Precipitation)", x = "Year", y = "mm", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p5)

# Grafik 6: R99p (Extremely Wet Days Total)
p6 <- ggplot(etccdi_indices, aes(x = YEAR, y = R99p, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "ETCCDI: R99p (Extremely Wet Days Precipitation)", x = "Year", y = "mm", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p6)

# Grafik 7: SDII (Simple Daily Intensity Index)
p7 <- ggplot(etccdi_indices, aes(x = YEAR, y = SDII, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "ETCCDI: SDII (Precipitation Intensity)", x = "Year", y = "mm/day", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p7)

# Grafik 8: CDD (Consecutive Dry Days)
p8 <- ggplot(etccdi_indices, aes(x = YEAR, y = CDD, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "ETCCDI: CDD (Consecutive Dry Days)", x = "Year", y = "Days", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p8)

# Grafik 9: CWD (Consecutive Wet Days)
p9 <- ggplot(etccdi_indices, aes(x = YEAR, y = CWD, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "ETCCDI: CWD (Consecutive Wet Days)", x = "Year", y = "Days", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p9)

# Grafik 10: PRCPTOT (Total Annual Wet-Day Precipitation)
p10 <- ggplot(etccdi_indices, aes(x = YEAR, y = PRCPTOT, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "ETCCDI: PRCPTOT (Annual Wet-Day Precipitation)", x = "Year", y = "mm", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p10)