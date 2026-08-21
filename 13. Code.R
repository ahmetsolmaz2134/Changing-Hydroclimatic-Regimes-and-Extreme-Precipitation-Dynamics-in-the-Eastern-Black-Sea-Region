library(tidyverse)
library(openxlsx)
library(cluster)

# 1. ??zellik M??hendisli??i
station_features <- panel_df %>%
  filter(province %in% c("Artvin", "Rize", "Trabzon", "Giresun", "Ordu")) %>%
  group_by(province) %>%
  summarise(
    Mean_Precip = mean(PRECTOTCORR, na.rm = TRUE),
    CV_Precip = sd(PRECTOTCORR, na.rm = TRUE) / mean(PRECTOTCORR, na.rm = TRUE),
    Mean_Temp = mean(T2M, na.rm = TRUE),
    .groups = "drop"
  )

scaled_data <- station_features %>% select(-province) %>% scale()
rownames(scaled_data) <- station_features$province

# 2. K-Means ve PCA (Akademik Grupland??rma)
km_res <- kmeans(scaled_data, centers = 2, nstart = 50)
pca_res <- prcomp(scaled_data)

plot_data <- as.data.frame(pca_res$x) %>%
  mutate(Province = rownames(.), Cluster = as.factor(km_res$cluster))

# 3. Y??ksek Kaliteli Akademik G??rselle??tirme (ggplot2 ile S??f??rdan)
p_academic <- ggplot(plot_data, aes(x = PC1, y = PC2, color = Cluster, label = Province)) +
  geom_point(size = 5, alpha = 0.8) +
  geom_text(vjust = -1.5, size = 4, fontface = "bold") +
  stat_ellipse(aes(fill = Cluster), geom = "polygon", alpha = 0.1, color = "black", linetype = 2) +
  scale_color_manual(values = c("#2c3e50", "#e74c3c")) +
  scale_fill_manual(values = c("#2c3e50", "#e74c3c")) +
  labs(title = "Clustering of Meteorological Stations by Hydroclimatological Attributes",
       subtitle = "Principal Component Analysis (PCA) based on precipitation and temperature regimes",
       x = paste0("PC1 (", round(summary(pca_res)$importance[2,1]*100, 1), "%)"),
       y = paste0("PC2 (", round(summary(pca_res)$importance[2,2]*100, 1), "%)")) +
  theme_classic(base_size = 14) +
  theme(plot.title = element_text(face = "bold", size = 18),
        legend.position = "bottom",
        panel.grid.major = element_line(color = "grey90"))

ggsave("Publication_Quality_Clustering.png", plot = p_academic, width = 10, height = 7, dpi = 600)

# 4. Excel ????kt??s??
write.xlsx(station_features %>% mutate(Cluster = km_res$cluster), "Station_Clustering_Report.xlsx")

print("Grafikler akademik formata y??kseltildi, Excel raporu haz??r abim!")