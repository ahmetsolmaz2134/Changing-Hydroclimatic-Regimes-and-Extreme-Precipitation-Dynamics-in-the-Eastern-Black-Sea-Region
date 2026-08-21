library(tidyverse)
library(openxlsx)
library(ggthemes)
library(extRemes)

# Analiz edilecek veri (Y??ll??k maksimum Rx1day serisi)
ev_data <- etccdi_indices %>% 
  filter(!is.na(Rx1day))

iller <- unique(ev_data$province)

gev_donus_listesi <- list()
gpd_sonuc_listesi <- list()

# Grafiklerin hepsinin ekranda s??rayla a????lmas?? i??in liste tutucular
# (Not: extRemes paketinin kendi plot fonksiyonlar?? do??rudan base R grafikleri ??izer)

for (il in iller) {
  sub_seri <- ev_data %>% filter(province == il) %>% pull(Rx1day)
  
  # --- 1. GEV (Generalized Extreme Value) Modeli ---
  # fevd (Extreme Value Distribution Fitting) fonksiyonu ile blok maksimumlar (Block Maxima) modellenir
  gev_fit <- fevd(sub_seri, type = "GEV")
  
  # D??n???? Seviyeleri (Return Levels): 10, 25, 50 ve 100 y??l
  ret_levels <- return.level(gev_fit, return.period = c(10, 25, 50, 100))
  
  gev_row <- tibble(
    Province = il,
    Model = "GEV",
    Return_10_Yr = as.numeric(ret_levels[1]),
    Return_25_Yr = as.numeric(ret_levels[2]),
    Return_50_Yr = as.numeric(ret_levels[3]),
    Return_100_Yr = as.numeric(ret_levels[4])
  )
  gev_donus_listesi[[il]] <- gev_row
  
  # --- 2. GPD (Generalized Pareto Distribution - POT E??ik A????m Modeli) ---
  # %90'l??k e??ik de??erini a??an ekstrem olaylar i??in POT modeli (Threshold = 90th percentile)
  esik_val <- quantile(sub_seri, 0.90, na.rm = TRUE)
  gpd_fit <- fevd(sub_seri, threshold = esik_val, type = "GP", method = "MLE")
  
  gpd_row <- tibble(
    Province = il,
    Model = "GPD_POT",
    Threshold_90th = esik_val,
    Scale_Parameter = as.numeric(findpars(gpd_fit)$scale),
    Shape_Parameter = as.numeric(findpars(gpd_fit)$shape)
  )
  gpd_sonuc_listesi[[il]] <- gpd_row
}

gev_summary_df <- bind_rows(gev_donus_listesi)
gpd_summary_df <- bind_rows(gpd_sonuc_listesi)

# Konsolda tablolar?? g??rme
print("--- GEV Return Levels (10, 25, 50, 100 Years) ---")
print(gev_summary_df)

print("--- GPD / POT Parameters ---")
print(gpd_summary_df)

# 3. Excel ????kt??s?? Alma
wb <- createWorkbook()
addWorksheet(wb, "GEV_Return_Levels")
writeData(wb, "GEV_Return_Levels", gev_summary_df)
addWorksheet(wb, "GPD_POT_Parameters")
writeData(wb, "GPD_POT_Parameters", gpd_summary_df)
saveWorkbook(wb, "East_BlackSea_EVT_Results.xlsx", overwrite = TRUE)

# 4. T??M EVT GRAF??KLER??N??N TEK TEK ????ZD??RMES?? (Base R & ggplot entegrasyonu)

# Her il i??in GEV olas??l??k ve d??n???? seviyesi grafikleri:
for (il in iller) {
  sub_seri <- ev_data %>% filter(province == il) %>% pull(Rx1day)
  gev_fit <- fevd(sub_seri, type = "GEV")
  
  # Grafik 1: GEV Diagnostic / Return Level Plot (Her il i??in ayr?? pencerede a????l??r)
  dev.new()
  plot(gev_fit, main = paste("GEV Model Analysis for", il))
}

# ggplot tabanl?? ??zel D??n???? Seviyeleri Kar????la??t??rma Grafi??i (T??m iller bir arada)
gev_long <- gev_summary_df %>%
  pivot_longer(cols = starts_with("Return"), names_to = "Return_Period", values_to = "Level_mm") %>%
  mutate(Period_Year = case_when(
    Return_Period == "Return_10_Yr" ~ 10,
    Return_Period == "Return_25_Yr" ~ 25,
    Return_Period == "Return_50_Yr" ~ 50,
    Return_Period == "Return_100_Yr" ~ 100
  ))

p_gev_compare <- ggplot(gev_long, aes(x = Period_Year, y = Level_mm, color = Province)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2) +
  theme_bw() +
  labs(title = "Extreme Value Theory: GEV Return Levels (10 to 100 Years)",
       subtitle = "Estimated maximum 1-day precipitation return values for East Black Sea provinces",
       x = "Return Period (Years)", y = "Precipitation Return Level (mm)", color = "Province") +
  theme(text = element_text(family = "serif", size = 11),
        legend.position = "bottom")

print(p_gev_compare)