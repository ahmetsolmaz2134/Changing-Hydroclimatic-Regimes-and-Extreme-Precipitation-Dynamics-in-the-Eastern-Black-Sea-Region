library(tidyverse)
library(openxlsx)
library(ggthemes)

# 1. Ya?????? ??ndekslerini Hesaplama
precip_indices <- panel_df %>%
  group_by(province, YEAR = year(date)) %>%
  summarise(
    Annual_Total = sum(PRECTOTCORR, na.rm = TRUE),
    Rainy_Days = sum(PRECTOTCORR >= 1.0, na.rm = TRUE),
    Max_1Day = max(PRECTOTCORR, na.rm = TRUE),
    Max_5Day = max(zoo::rollsum(PRECTOTCORR, k = 5, fill = NA, align = "right"), na.rm = TRUE),
    Intensity = Annual_Total / Rainy_Days,
    .groups = "drop"
  )

# 2. Mevsimsel Ya?????? Hesaplama
seasonal_precip <- panel_df %>%
  mutate(
    Ay = month(date),
    Season = case_when(
      Ay %in% c(12, 1, 2) ~ "Winter",
      Ay %in% c(3, 4, 5) ~ "Spring",
      Ay %in% c(6, 7, 8) ~ "Summer",
      Ay %in% c(9, 10, 11) ~ "Autumn"
    ),
    YEAR = year(date)
  ) %>%
  group_by(province, YEAR, Season) %>%
  summarise(Seasonal_Total = sum(PRECTOTCORR, na.rm = TRUE), .groups = "drop")

# 3. Excel ????kt??s?? Alma
wb <- createWorkbook()
addWorksheet(wb, "Annual_Indices")
writeData(wb, "Annual_Indices", precip_indices)
addWorksheet(wb, "Seasonal_Precip")
writeData(wb, "Seasonal_Precip", seasonal_precip)
saveWorkbook(wb, "East_BlackSea_Precipitation_Indices.xlsx", overwrite = TRUE)

# 4. T??M GRAF??KLER?? TEK TEK ????ZME VE KAYDETME

# Grafik 1: Y??ll??k Toplam Ya?????? (Annual Total Precipitation)
p1 <- ggplot(precip_indices, aes(x = YEAR, y = Annual_Total, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "Annual Total Precipitation", x = "Year", y = "mm", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p1)

# Grafik 2: Ya??????l?? G??n Say??s?? (Rainy Days)
p2 <- ggplot(precip_indices, aes(x = YEAR, y = Rainy_Days, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "Number of Rainy Days (>= 1mm)", x = "Year", y = "Days", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p2)

# Grafik 3: Maksimum 1 G??nl??k Ya?????? (Max 1-Day Precipitation)
p3 <- ggplot(precip_indices, aes(x = YEAR, y = Max_1Day, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "Maximum 1-Day Precipitation (Rx1day)", x = "Year", y = "mm/day", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p3)

# Grafik 4: Maksimum 5 G??nl??k Ya?????? (Max 5-Day Precipitation)
p4 <- ggplot(precip_indices, aes(x = YEAR, y = Max_5Day, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "Maximum 5-Day Consecutive Precipitation", x = "Year", y = "mm", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p4)

# Grafik 5: Ya?????? Yo??unlu??u (Precipitation Intensity - SDII)
p5 <- ggplot(precip_indices, aes(x = YEAR, y = Intensity, color = province)) +
  geom_line(linewidth = 0.8) + geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +
  theme_bw() + labs(title = "Precipitation Intensity (SDII)", x = "Year", y = "mm/day", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p5)

# Grafik 6: Mevsimsel Ya?????? Da????l??m?? (Seasonal Precipitation Facet)
p6 <- ggplot(seasonal_precip, aes(x = YEAR, y = Seasonal_Total, color = province)) +
  geom_line(linewidth = 0.8) +
  facet_wrap(~Season, scales = "free_y") +
  theme_bw() + labs(title = "Seasonal Precipitation Trends", x = "Year", y = "Total Precipitation (mm)", color = "Province") +
  theme(text = element_text(family = "serif", size = 11))
print(p6)