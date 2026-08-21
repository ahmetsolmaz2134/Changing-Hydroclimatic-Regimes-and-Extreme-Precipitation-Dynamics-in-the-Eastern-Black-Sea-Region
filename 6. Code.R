library(tidyverse)
library(openxlsx)
library(ggthemes)
library(trend)

# 1. Analiz Edilecek Metrikler ve Mann-Kendall D??ng??s??
analiz_tablosu <- etccdi_indices # ??nceki ad??mda olu??turdu??umuz tablo
metrikler <- c("PRCPTOT", "Rx1day", "Rx5day", "R10mm", "R20mm", "R95p", "R99p", "SDII", "CDD", "CWD")

mk_sonuc_listesi <- list()

for (il in unique(analiz_tablosu$province)) {
  for (metrik in metrikler) {
    veri_serisi <- analiz_tablosu %>% 
      filter(province == il) %>% 
      arrange(YEAR) %>% 
      pull(all_of(metrik))
    
    if (length(na.omit(veri_serisi)) >= 10) {
      ts_obj <- ts(veri_serisi)
      mk_tst <- mk.test(ts_obj)
      sens_tst <- sens.slope(ts_obj)
      
      sonuc_row <- tibble(
        Province = il,
        Indicator = metrik,
        MK_Tau = mk_tst$estimates["Kendall's tau"],
        P_Value = mk_tst$p.value,
        Sens_Slope = sens_tst$estimates["Sen's slope"],
        Significance = case_when(
          mk_tst$p.value < 0.05 ~ "Significant (p < 0.05)",
          mk_tst$p.value < 0.10 ~ "Marginal (p < 0.10)",
          TRUE ~ "Not Significant"
        ),
        Trend_Direction = if_else(sens_tst$estimates["Sen's slope"] > 0, "Increasing", "Decreasing")
      )
      mk_sonuc_listesi[[paste(il, metrik, sep = "_")]] <- sonuc_row
    }
  }
}

trend_summary_df <- bind_rows(mk_sonuc_listesi)

# 2. Excel ????kt??s??
wb <- createWorkbook()
addWorksheet(wb, "MK_Trend_Results")
writeData(wb, "MK_Trend_Results", trend_summary_df)
saveWorkbook(wb, "East_BlackSea_Trend_Analysis_Results.xlsx", overwrite = TRUE)

# 3. GRAF??K 1: Is?? Haritas?? (Heatmap) - ??ller ve G??stergelere G??re Sen's Slope De??erleri
p_heatmap <- ggplot(trend_summary_df, aes(x = Indicator, y = Province, fill = Sens_Slope)) +
  geom_tile(color = "white", linewidth = 0.5) +
  # Anlaml?? olan h??crelerin ??zerine y??ld??z veya ??er??eve ekleyebiliriz
  geom_text(aes(label = ifelse(P_Value < 0.05, "*", "")), color = "black", size = 6, vjust = 0.7) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0, 
                       name = "Sen's Slope\n(Trend Magnitude)") +
  theme_bw() +
  labs(title = "Mann-Kendall Trend Magnitude (Sen's Slope) Heatmap",
       subtitle = "East Black Sea Region (* indicates p < 0.05 significance)",
       x = "Climate Indicators", y = "Province") +
  theme(text = element_text(family = "serif", size = 11),
        axis.text.x = element_text(angle = 45, hjust = 1))

print(p_heatmap)

# 4. GRAF??K 2: Nokta ve Hata ??izgisi Grafi??i (Dot-and-Whisker Plot)
p_dotplot <- ggplot(trend_summary_df, aes(x = Sens_Slope, y = Indicator, color = Significance)) +
  geom_point(size = 3) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray40") +
  facet_wrap(~Province, scales = "free_x") +
  theme_bw() +
  labs(title = "Trend Magnitudes and Significance by Province",
       subtitle = "Mann-Kendall & Sen's Slope Test Results",
       x = "Sen's Slope Value", y = "Indicators", color = "Statistical Significance") +
  theme(text = element_text(family = "serif", size = 10),
        legend.position = "bottom")

print(p_dotplot)