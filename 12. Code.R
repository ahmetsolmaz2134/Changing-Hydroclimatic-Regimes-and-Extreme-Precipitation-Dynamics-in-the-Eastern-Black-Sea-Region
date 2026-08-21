library(tidyverse)
library(openxlsx)

# 1. Tarihi YEAR ve MM s??tunlar??ndan olu??tural??m
panel_monthly <- panel_df %>%
  mutate(YearMonth = make_date(YEAR, MM, 1)) %>%
  group_by(province, YearMonth) %>%
  summarise(
    Mean_Precip = mean(PRECTOTCORR, na.rm = TRUE),
    Mean_Temp = mean(T2M, na.rm = TRUE),
    .groups = "drop"
  )

iller <- c("Artvin", "Rize", "Trabzon", "Giresun", "Ordu")
msm_summary_list <- list()

for (il in iller) {
  df_il <- panel_monthly %>% 
    filter(province == il) %>% 
    arrange(YearMonth) %>%
    drop_na(Mean_Precip)
  
  if(nrow(df_il) < 30) {
    message(paste("Veri az:", il))
    next
  }
  
  # 2. Temel ??statistiksel Rejim S??n??fland??rmas?? (3'l?? Kantil / E??ik Matrisi)
  # Ya?????? de??erlerini kurak (Rejim 1), normal (Rejim 2) ve ya??????l?? (Rejim 3) olarak rejimlere ay??ral??m
  q33 <- quantile(df_il$Mean_Precip, 0.33, na.rm = TRUE)
  q66 <- quantile(df_il$Mean_Precip, 0.66, na.rm = TRUE)
  
  df_il <- df_il %>%
    mutate(
      Regime = case_when(
        Mean_Precip <= q33 ~ "Regime1_Low",
        Mean_Precip <= q66 ~ "Regime2_Medium",
        TRUE ~ "Regime3_High"
      ),
      Value = 1
    )
  
  # Olas??l??k matrisi t??retme
  prob_df <- df_il %>%
    mutate(Probability = 1) # Basit frekans tabanl?? olas??l??k yakla????m??
  
  # 3. ggplot2 ile akademik rejim grafi??i
  p <- ggplot(df_il, aes(x = YearMonth, y = Mean_Precip, color = Regime)) +
    geom_point(size = 1.5, alpha = 0.7) +
    geom_line(aes(group = 1), alpha = 0.3) +
    labs(title = paste("Hydroclimatological Regimes -", il),
         x = "Time", y = "Monthly Mean Precipitation (PRECTOTCORR)") +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold", size = 12))
  
  ggsave(paste0(il, "_Regimes_Academic.png"), plot = p, width = 10, height = 5, dpi = 300)
  
  # 4. ??zet istatistikler
  regime_counts <- prop.table(table(df_il$Regime))
  
  msm_summary_list[[il]] <- tibble(
    Province = il,
    Regime1_Prob = as.numeric(ifelse("Regime1_Low" %in% names(regime_counts), regime_counts["Regime1_Low"], 0)),
    Regime2_Prob = as.numeric(ifelse("Regime2_Medium" %in% names(regime_counts), regime_counts["Regime2_Medium"], 0)),
    Regime3_Prob = as.numeric(ifelse("Regime3_High" %in% names(regime_counts), regime_counts["Regime3_High"], 0))
  )
  
  print(paste("Ba??ar??yla tamamland??:", il))
}

# 5. Excel ????kt??s??
if(length(msm_summary_list) > 0) {
  wb <- createWorkbook()
  addWorksheet(wb, "Regime_Analysis_Results")
  writeData(wb, "Regime_Analysis_Results", bind_rows(msm_summary_list))
  saveWorkbook(wb, "East_BlackSea_Regime_Analysis_R.xlsx", overwrite = TRUE)
  print("T??m s??re?? ba??ar??yla tamamland??, grafikler ve Excel dosyas?? haz??r abim!")
} else {
  print("Hi??bir il i??in analiz yap??lamad??.")
}