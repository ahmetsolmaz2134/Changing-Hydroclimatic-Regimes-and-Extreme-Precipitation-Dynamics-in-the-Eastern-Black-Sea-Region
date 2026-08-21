library(nasapower)
library(tidyverse)
library(lubridate)

# 1. Do??u Karadeniz illerinin koordinatlar??
iller <- tibble(
  province = c("Artvin", "Rize", "Trabzon", "Giresun", "Ordu"),
  LAT = c(41.1828, 41.0201, 41.0015, 40.9128, 40.9839),
  LON = c(41.8183, 40.5234, 39.7178, 38.3895, 37.8764)
)

baslangic_yil <- 1991
bitis_yil <- 2025

parametreler <- c(
  "PRECTOTCORR",       # Ya??????
  "T2M",               # Ortalama s??cakl??k
  "T2M_MAX",           # Maksimum s??cakl??k
  "T2M_MIN",           # Minimum s??cakl??k
  "RH2M",              # Ba????l nem
  "WS10M",             # R??zg??r h??z??
  "ALLSKY_SFC_SW_DWN"  # G??ne?? radyasyonu
)

veri_listesi <- list()

for(i in 1:nrow(iller)) {
  il_adi <- iller$province[i]
  lat_val <- iller$LAT[i]
  lon_val <- iller$LON[i]
  
  message(paste(il_adi, "i??in NASA POWER verileri ??ekiliyor..."))
  
  df <- get_power(
    community = "ag",
    lonlat = c(lon_val, lat_val),
    pars = parametreler,
    dates = c(paste0(baslangic_yil, "-01-01"), paste0(bitis_yil, "-12-31")),
    temporal_api = "daily"
  )
  
  df$province <- il_adi
  veri_listesi[[i]] <- df
}

# 2. Birle??tirme ve Kesin Tarih D??n??????m??
panel_df <- bind_rows(veri_listesi)

# S??tun yap??s??na g??re hatas??z tarih ??retimi
if(all(c("YEAR", "MO", "DY") %in% colnames(panel_df))) {
  panel_df <- panel_df %>% mutate(date = make_date(YEAR, MO, DY))
} else if("YYYYMMDD" %in% colnames(panel_df)) {
  panel_df <- panel_df %>% mutate(date = ymd(as.character(YYYYMMDD)))
} else if("DATE" %in% colnames(panel_df)) {
  panel_df <- panel_df %>% mutate(date = as.Date(DATE))
}

# 3. Eksik / Hatal?? de??erleri temizleme (-999 ve -9999)
panel_df <- panel_df %>%
  mutate(across(where(is.numeric), ~ ifelse(. %in% c(-999, -9999), NA, .)))

# Sonucu kontrol et
glimpse(panel_df)
head(panel_df)