library(tidyverse)
library(openxlsx)
library(ggthemes)
library(trend)

# ??rnek olarak elimizdeki 'etccdi_indices' veya 'annual_indices' verilerini birle??tirelim ya da
# analiz etmek istedi??imiz metrikleri tek bir panel tabloda toplayal??m.
# Burada t??m y??ll??k ekstrem ve hidroklimatik g??stergeleri kapsayan kapsaml?? bir Mann-Kendall d??ng??s?? kuruyoruz:

# Analiz edilecek metriklerin listesi (??stedi??in t??m g??stergeleri ekleyebiliriz)
# Veri ??er??evemizde ortak olan iller ve y??llar ??zerinden ilerliyoruz:

# 1. Y??ll??k g??stergeleri bir araya getiren ana tabloyu olu??tural??m (??rn: etccdi_indices ??zerinden)
# E??er ayr?? ayr?? tablolar??n varsa onlar?? join ile birle??tirebilirsin.
analiz_tablosu <- etccdi_indices # ????inde Rx1day, Rx5day, PRCPTOT, SDII vb. var

# 2. Mann-Kendall ve Sen's Slope Otomasyon D??ng??s??
mk_sonuc_listesi <- list()

# Hangi s??tunlar??n trendini hesaplayaca????z? (Say??sal olan ve y??l/il d??????ndaki s??tunlar)
metrikler <- c("PRCPTOT", "Rx1day", "Rx5day", "R10mm", "R20mm", "R95p", "R99p", "SDII", "CDD", "CWD")

for (il in unique(analiz_tablosu$province)) {
  for (metrik in metrikler) {
    
    # ??lgili ilin ve metri??in zaman serisini al
    veri_serisi <- analiz_tablosu %>% 
      filter(province == il) %>% 
      arrange(YEAR) %>% 
      pull(all_of(metrik))
    
    # En az 10 y??ll??k kesintisiz veri varsa test uygula
    if (length(na.omit(veri_serisi)) >= 10) {
      ts_obj <- ts(veri_serisi)
      
      # Mann-Kendall Testi
      mk_tst <- mk.test(ts_obj)
      # Sen's Slope (E??im ve Trend B??y??kl??????)
      sens_tst <- sens.slope(ts_obj)
      
      # Sonu??lar?? kaydetme
      sonuc_row <- tibble(
        Province = il,
        Indicator = metrik,
        MK_Tau = mk_tst$estimates["Kendall's tau"],
        P_Value = mk_tst$p.value,
        Sens_Slope = sens_tst$estimates["Sen's slope"],
        Trend_Significance = case_when(
          mk_tst$p.value < 0.01 ~ "Highly Significant***",
          mk_tst$p.value < 0.05 ~ "Significant**",
          mk_tst$p.value < 0.10 ~ "Weakly Significant*",
          TRUE ~ "Not Significant"
        ),
        Trend_Direction = if_else(sens_tst$estimates["Sen's slope"] > 0, "Increasing (+)", "Decreasing (-)")
      )
      
      mk_sonuc_listesi[[paste(il, metrik, sep = "_")]] <- sonuc_row
    }
  }
}

# T??m sonu??lar?? tek bir tabloya d??n????t??rme
trend_summary_df <- bind_rows(mk_sonuc_listesi)

# Konsolda sonu??lar?? g??r??nt??leme
print(trend_summary_df)

# 3. Excel ????kt??s?? Alma
wb <- createWorkbook()
addWorksheet(wb, "Mann_Kendall_Sens_Slope")
writeData(wb, "Mann_Kendall_Sens_Slope", trend_summary_df)
saveWorkbook(wb, "East_BlackSea_Trend_Analysis_Results.xlsx", overwrite = TRUE)

# 4. Akademik G??rselle??tirme: Trend Anlaml??l??k ve Y??n ??zet Grafi??i
p_trend <- ggplot(trend_summary_df, aes(x = Indicator, y = Sens_Slope, fill = Trend_Direction)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  facet_wrap(~Province, scales = "free_y") +
  theme_bw() +
  labs(title = "Sen's Slope Magnitude and Trend Directions for East Black Sea",
       subtitle = "Mann-Kendall Trend Test Results (1991-2025)",
       x = "Climate/Precipitation Indicators", 
       y = "Sen's Slope (Change per Year)", 
       fill = "Trend Direction") +
  theme(text = element_text(family = "serif", size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1))

print(p_trend)