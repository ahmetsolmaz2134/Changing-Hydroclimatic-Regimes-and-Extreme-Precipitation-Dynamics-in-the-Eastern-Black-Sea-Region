library(tidyverse)
library(openxlsx)
library(ggthemes)
library(trend)

analiz_tablosu <- etccdi_indices # ??nceki ad??mda olu??turdu??umuz tablo
metrikler <- c("PRCPTOT", "Rx1day", "Rx5day", "SDII", "R95p")

pettitt_sonuc_listesi <- list()
degisim_detay_listesi <- list()

for (il in unique(analiz_tablosu$province)) {
  for (metrik in metrikler) {
    
    veri_serisi <- analiz_tablosu %>% 
      filter(province == il) %>% 
      arrange(YEAR) %>% 
      pull(all_of(metrik))
    
    yillar <- analiz_tablosu %>% 
      filter(province == il) %>% 
      arrange(YEAR) %>% 
      pull(YEAR)
    
    if (length(na.omit(veri_serisi)) >= 10) {
      ts_obj <- ts(veri_serisi)
      
      # Pettitt Testi
      pt_tst <- pettitt.test(ts_obj)
      
      kirilma_indeksi <- pt_tst$estimate
      kirilma_yili <- yillar[kirilma_indeksi]
      
      # ??zet sonu?? tablosu
      sonuc_row <- tibble(
        Province = il,
        Indicator = metrik,
        Change_Point_Year = kirilma_yili,
        P_Value = pt_tst$p.value,
        Significance = case_when(
          pt_tst$p.value < 0.01 ~ "Highly Significant***",
          pt_tst$p.value < 0.05 ~ "Significant**",
          pt_tst$p.value < 0.10 ~ "Marginal*",
          TRUE ~ "Not Significant"
        )
      )
      
      pettitt_sonuc_listesi[[paste(il, metrik, sep = "_")]] <- sonuc_row
      
      # Temiz detay tablosu (Boyut ??ak????mas?? yaratmaz)
      detay_df <- tibble(
        Province = il,
        Indicator = metrik,
        Year = yillar,
        Value = veri_serisi
      )
      degisim_detay_listesi[[paste(il, metrik, sep = "_")]] <- detay_df
    }
  }
}

pettitt_summary_df <- bind_rows(pettitt_sonuc_listesi)
pettitt_detail_df <- bind_rows(degisim_detay_listesi)

# K??r??lma y??llar??n?? detay grafikle birle??tirmek i??in join kullan??yoruz
pettitt_plot_df <- pettitt_detail_df %>%
  left_join(pettitt_summary_df %>% select(Province, Indicator, Change_Point_Year), 
            by = c("Province", "Indicator"))

# Konsolda ??zet tabloyu g??rme
print(pettitt_summary_df)

# 1. Excel ????kt??s?? Alma
wb <- createWorkbook()
addWorksheet(wb, "Pettitt_Change_Point_Summary")
writeData(wb, "Pettitt_Change_Point_Summary", pettitt_summary_df)
saveWorkbook(wb, "East_BlackSea_Pettitt_Test_Results.xlsx", overwrite = TRUE)

# 2. GRAF??K: Rejim De??i??ikli??i ve K??r??lma Y??llar??n??n G??rselle??tirilmesi
p_pettitt <- ggplot(pettitt_plot_df %>% filter(Indicator == "Rx1day"), 
                    aes(x = Year, y = Value, color = Province)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 1.5) +
  geom_vline(aes(xintercept = Change_Point_Year), linetype = "dashed", color = "red", linewidth = 0.8) +
  facet_wrap(~Province, scales = "free_y") +
  theme_bw() +
  labs(title = "Pettitt Test: Change-Point Detection in Max 1-Day Precipitation (Rx1day)",
       subtitle = "Red dashed line indicates the abrupt regime shift year",
       x = "Year", y = "Rx1day (mm)", color = "Province") +
  theme(text = element_text(family = "serif", size = 11),
        legend.position = "bottom")

print(p_pettitt)