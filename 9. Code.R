library(tidyverse)
library(openxlsx)
library(ggthemes)
library(quantreg)

# Analiz edilecek veri ve metrik (??rn: Rx1day - En y??ksek 1 g??nl??k ya??????)
# ??stersen PRCPTOT veya R95p i??in de ??al????t??rabilirsin.
analiz_veri <- etccdi_indices %>% 
  filter(!is.na(Rx1day))

# ??ncelenecek Kantil Seviyeleri (Deciles ve Percentiles)
kantil_seviyeleri <- c(0.10, 0.25, 0.50, 0.75, 0.90, 0.95, 0.99)

qr_sonuc_listesi <- list()

for (il in unique(analiz_veri$province)) {
  sub_df <- analiz_veri %>% filter(province == il)
  
  for (tau in kantil_seviyeleri) {
    # Kantil Regresyon Modeli (Rq)
    fit_rq <- rq(Rx1day ~ YEAR, tau = tau, data = sub_df)
    summary_rq <- summary(fit_rq, se = "boot") # Bootstrap standart hatalar ile
    
    # Katsay??lar?? ve p de??erlerini alma
    slope_val <- coef(summary_rq)["YEAR", "Value"]
    p_val <- coef(summary_rq)["YEAR", "Pr(>|t|)"]
    
    sonuc_row <- tibble(
      Province = il,
      Indicator = "Rx1day",
      Quantile = tau,
      Slope = slope_val,
      P_Value = p_val,
      Significance = case_when(
        p_val < 0.05 ~ "Significant (p < 0.05)",
        TRUE ~ "Not Significant"
      )
    )
    
    qr_sonuc_listesi[[paste(il, tau, sep = "_")]] <- sonuc_row
  }
}

qr_summary_df <- bind_rows(qr_sonuc_listesi)

# Konsolda sonu??lar?? g??rme
print(qr_summary_df)

# 1. Excel ????kt??s?? Alma
wb <- createWorkbook()
addWorksheet(wb, "Quantile_Regression_Results")
writeData(wb, "Quantile_Regression_Results", qr_summary_df)
saveWorkbook(wb, "East_BlackSea_Quantile_Regression.xlsx", overwrite = TRUE)

# 2. GRAF??K: ??oklu Kantil Trendlerinin G??rselle??tirilmesi (Her il i??in 0.10, 0.50, 0.90 ve 0.99 kantilleri)
p_qr <- ggplot(analiz_veri, aes(x = YEAR, y = Rx1day)) +
  geom_point(alpha = 0.4, color = "gray30") +
  # Farkl?? kantil ??izgilerini ekleme (??rn: 0.10 mavi, 0.50 ye??il, 0.90 turuncu, 0.99 k??rm??z??)
  geom_quantile(aes(color = factor(..quantile..)), quantiles = c(0.10, 0.50, 0.90, 0.99), linewidth = 0.8) +
  scale_color_manual(values = c("0.1" = "blue", "0.5" = "forestgreen", "0.9" = "darkorange", "0.99" = "red"),
                     name = "Quantiles",
                     labels = c("0.10 (Dry/Low)", "0.50 (Median)", "0.90 (High)", "0.99 (Extreme)")) +
  facet_wrap(~province, scales = "free_y") +
  theme_bw() +
  labs(title = "Quantile Regression Trends for Max 1-Day Precipitation (Rx1day)",
       subtitle = "Analyzing shifts across different distribution tails (0.10 to 0.99)",
       x = "Year", y = "Rx1day (mm)") +
  theme(text = element_text(family = "serif", size = 11),
        legend.position = "bottom")

print(p_qr)