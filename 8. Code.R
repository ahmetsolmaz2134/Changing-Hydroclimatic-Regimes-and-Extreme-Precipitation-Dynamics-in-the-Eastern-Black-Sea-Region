library(tidyverse)
library(openxlsx)
library(ggthemes)
library(changepoint)

# Analiz edilecek veriler ve metrikler
analiz_tablosu <- etccdi_indices # Daha ??nce olu??turdu??umuz ekstrem ya?????? tablosu
metrikler <- c("PRCPTOT", "Rx1day", "Rx5day", "SDII")

pelt_sonuc_listesi <- list()
pelt_detay_listesi <- list()

for (il in unique(analiz_tablosu$province)) {
  for (metrik in metrikler) {
    
    sub_df <- analiz_tablosu %>% 
      filter(province == il) %>% 
      arrange(YEAR)
    
    veri_serisi <- sub_df %>% pull(all_of(metrik))
    yillar <- sub_df %>% pull(YEAR)
    
    if (length(na.omit(veri_serisi)) >= 10) {
      
      # PELT Algoritmas?? ile ??oklu De??i??im Noktas?? Tespiti (Ortalama ve Varyans de??i??imi i??in "meanvar")
      cpt_pelt <- cpt.meanvar(veri_serisi, method = "PELT", penalty = "AIC")
      
      # Bulunan k??r??lma noktalar??n??n indeksleri ve y??llar??
      cpt_indices <- cpts(cpt_pelt)
      
      if (length(cpt_indices) > 0) {
        kirilma_yillari <- yillar[cpt_indices]
        kirilma_yillari_str <- paste(kirilma_yillari, collapse = ", ")
      } else {
        kirilma_yillari_str <- "No Change Point"
      }
      
      # ??zet Tablo Kayd??
      sonuc_row <- tibble(
        Province = il,
        Indicator = metrik,
        Method = "PELT",
        Number_of_Change_Points = length(cpt_indices),
        Change_Point_Years = kirilma_yillari_str
      )
      
      pelt_sonuc_listesi[[paste(il, metrik, sep = "_")]] <- sonuc_row
      
      # Grafik i??in detay verisi
      detay_df <- sub_df %>% select(province, YEAR, all_of(metrik))
      colnames(detay_df)[3] <- "Value"
      detay_df$Indicator <- metrik
      detay_df$Change_Years_Str <- kirilma_yillari_str
      
      pelt_detay_listesi[[paste(il, metrik, sep = "_")]] <- detay_df
    }
  }
}

pelt_summary_df <- bind_rows(pelt_sonuc_listesi)
pelt_detail_df <- bind_rows(pelt_detay_listesi)

# Konsolda ??oklu k??r??lma ??zetini g??rmek i??in:
print(pelt_summary_df)

# 1. Excel ????kt??s?? Alma
wb <- createWorkbook()
addWorksheet(wb, "PELT_Multiple_Change_Points")
writeData(wb, "PELT_Multiple_Change_Points", pelt_summary_df)
saveWorkbook(wb, "East_BlackSea_PELT_Change_Points.xlsx", overwrite = TRUE)

# 2. GRAF??K: ??oklu Rejim De??i??ikliklerinin (PELT) G??rselle??tirilmesi (??rn: Rx1day i??in)
# Her ilin kendi k??r??lma y??llar??n?? dikey ??izgilerle ekleyebilece??imiz ????k bir grafik:
p_pelt <- ggplot(pelt_detail_df %>% filter(Indicator == "Rx1day"), 
                 aes(x = YEAR, y = Value, color = province)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 1.5) +
  facet_wrap(~province, scales = "free_y") +
  theme_bw() +
  labs(title = "Multiple Change-Point Analysis (PELT Method) in Rx1day",
       subtitle = "Detecting multiple regime shifts in East Black Sea extreme precipitation",
       x = "Year", y = "Rx1day (mm)", color = "Province") +
  theme(text = element_text(family = "serif", size = 11),
        legend.position = "bottom")

print(p_pelt)