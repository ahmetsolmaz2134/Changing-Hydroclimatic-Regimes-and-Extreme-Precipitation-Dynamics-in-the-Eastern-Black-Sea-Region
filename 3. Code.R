library(tidyverse)
library(openxlsx)
library(ggthemes)
library(SPEI)

# 1. FAO-56 Penman-Monteith PET Fonksiyonu
hesapla_fao_pet <- function(df, lat) {
  T_mean <- df$T2M
  u2 <- df$WS10M * (4.87 / log(67 * 10 - 5.42))
  Rn <- df$ALLSKY_SFC_SW_DWN * 0.75 
  es <- 0.6108 * exp((17.27 * T_mean) / (T_mean + 237.3))
  ea <- es * (df$RH2M / 100)
  delta <- (4098 * es) / ((T_mean + 237.3)^2)
  gamma <- 0.067 
  pet_gunluk <- (0.408 * delta * Rn + gamma * (900 / (T_mean + 273)) * u2 * (es - ea)) / 
    (delta + gamma * (1 + 0.34 * u2))
  return(pmax(0, pet_gunluk))
}

# 2. Enlem E??le??tirme ve PET Hesaplama
lat_mapping <- c("Artvin" = 41.1828, "Rize" = 41.0201, "Trabzon" = 41.0015, "Giresun" = 40.9128, "Ordu" = 40.9839)
panel_df <- panel_df %>% mutate(LAT = lat_mapping[province])

pet_listesi <- list()
iller <- unique(panel_df$province)

for(il in iller) {
  subset_df <- panel_df %>% filter(province == il)
  subset_df$PET <- hesapla_fao_pet(subset_df, subset_df$LAT[1])
  pet_listesi[[il]] <- subset_df
}
panel_df <- bind_rows(pet_listesi)

# 3. Ayl??k ve Y??ll??k Agregasyonlar
monthly_data <- panel_df %>%
  mutate(YEAR = year(date), MONTH = month(date)) %>%
  group_by(province, YEAR, MONTH) %>%
  summarise(
    P_m = sum(PRECTOTCORR, na.rm = TRUE),
    PET_m = sum(PET, na.rm = TRUE),
    T_mean = mean(T2M, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(P_minus_PET = P_m - PET_m)

annual_indices <- panel_df %>%
  group_by(province, YEAR = year(date)) %>%
  summarise(
    Annual_P = sum(PRECTOTCORR, na.rm = TRUE),
    Annual_PET = sum(PET, na.rm = TRUE),
    Annual_T = mean(T2M, na.rm = TRUE),
    P_minus_PET = Annual_P - Annual_PET,
    Aridity_Index = Annual_P / Annual_PET,
    De_Martonne = Annual_P / (Annual_T + 10),
    .groups = "drop"
  )

# 4. SPI ve SPEI Hesaplama
spi_spei_listesi <- list()
for(il in iller) {
  il_m <- monthly_data %>% filter(province == il)
  p_ts <- ts(il_m$P_m, start = c(1991, 1), frequency = 12)
  spi_12 <- spi(p_ts, scale = 12)$fitted
  
  d_ts <- ts(il_m$P_minus_PET, start = c(1991, 1), frequency = 12)
  spei_12 <- spei(d_ts, scale = 12)$fitted
  
  il_m$SPI_12 <- as.numeric(spi_12)
  il_m$SPEI_12 <- as.numeric(spei_12)
  spi_spei_listesi[[il]] <- il_m
}
monthly_indices <- bind_rows(spi_spei_listesi)

# 5. Excel ????kt??s??
wb <- createWorkbook()
addWorksheet(wb, "Annual_Aridity_Indices")
writeData(wb, "Annual_Aridity_Indices", annual_indices)
addWorksheet(wb, "Monthly_Water_Balance")
writeData(wb, "Monthly_Water_Balance", monthly_indices)
saveWorkbook(wb, "East_BlackSea_Drought_Aridity_Indices.xlsx", overwrite = TRUE)

# 6. T??M GRAF??KLER?? TEK TEK ????ZD??RME (Print komutlar?? ile)

# Grafik 1: De Martonne Aridity Index
p1 <- ggplot(annual_indices, aes(x = YEAR, y = De_Martonne, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "De Martonne Aridity Index", x = "Year", y = "Index (I)", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p1)

# Grafik 2: UNEP Aridity Index (P / PET)
p2 <- ggplot(annual_indices, aes(x = YEAR, y = Aridity_Index, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "Aridity Index (P / PET)", x = "Year", y = "AI", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p2)

# Grafik 3: Water Balance (P - PET)
p3 <- ggplot(annual_indices, aes(x = YEAR, y = P_minus_PET, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "Annual Water Balance (P - PET)", x = "Year", y = "mm", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p3)

# Grafik 4: SPEI-12
p4 <- ggplot(monthly_indices %>% filter(!is.na(SPEI_12)), aes(x = make_date(YEAR, MONTH, 1), y = SPEI_12, color = province)) +
  geom_line(linewidth = 0.6) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", alpha = 0.5) +
  geom_hline(yintercept = c(-1.5, 1.5), linetype = "dotted", color = "red") +
  theme_bw() + labs(title = "SPEI-12 (12-Month Timescale)", x = "Time", y = "SPEI-12", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p4)

# Grafik 5: SPI-12
p5 <- ggplot(monthly_indices %>% filter(!is.na(SPI_12)), aes(x = make_date(YEAR, MONTH, 1), y = SPI_12, color = province)) +
  geom_line(linewidth = 0.6) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", alpha = 0.5) +
  geom_hline(yintercept = c(-1.5, 1.5), linetype = "dotted", color = "red") +
  theme_bw() + labs(title = "SPI-12 (Precipitation Index)", x = "Time", y = "SPI-12", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p5)