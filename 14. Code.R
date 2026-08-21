library(tidyverse)
library(openxlsx)
library(corrplot)

# 1. Veriyi temizle: Ayn?? il ve ayn?? tarih i??in ortalama alarak tekil hale getir
mat_data <- panel_df %>%
  filter(province %in% c("Artvin", "Rize", "Trabzon", "Giresun", "Ordu")) %>%
  mutate(date = make_date(YEAR, MM, 1)) %>%
  group_by(province, date) %>%
  summarise(Mean_Prec = mean(PRECTOTCORR, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = province, values_from = Mean_Prec) %>%
  select(-date) %>%
  drop_na() # NA de??erlerini de temizle

# 2. Korelasyon Matrisini Hesapla
cor_pearson <- cor(mat_data, method = "pearson")

# 3. ggplot2 ile Akademik Heatmap
cor_df <- as.data.frame(as.table(cor_pearson))
colnames(cor_df) <- c("Station1", "Station2", "Correlation")

p_heatmap <- ggplot(cor_df, aes(x = Station1, y = Station2, fill = Correlation)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(Correlation, 2)), size = 4) +
  scale_fill_gradient2(low = "#e74c3c", mid = "white", high = "#2c3e50", 
                       midpoint = 0, limit = c(-1, 1)) +
  labs(title = "Hydroclimatological Correlation Matrix",
       x = "", y = "") +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(face = "bold", size = 16))

ggsave("Academic_Correlation_Heatmap.png", plot = p_heatmap, width = 9, height = 7, dpi = 600)

# 4. Korelasyon Tablolar?? (Pearson, Spearman, Kendall)
cor_spearman <- cor(mat_data, method = "spearman")
cor_kendall <- cor(mat_data, method = "kendall")

wb <- createWorkbook()
addWorksheet(wb, "Pearson")
addWorksheet(wb, "Spearman")
addWorksheet(wb, "Kendall")
writeData(wb, "Pearson", as.data.frame(cor_pearson), rowNames = TRUE)
writeData(wb, "Spearman", as.data.frame(cor_spearman), rowNames = TRUE)
writeData(wb, "Kendall", as.data.frame(cor_kendall), rowNames = TRUE)
saveWorkbook(wb, "Station_Correlation_Analysis.xlsx", overwrite = TRUE)

print("Veri tekille??tirildi, korelasyon analizleri yap??ld?? ve grafik haz??r abim!")