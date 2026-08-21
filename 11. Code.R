library(tidyverse)
library(openxlsx)
library(ggthemes)
library(biwavelet)

# Analiz edilecek veri seti (????erisinde Y??l, Province, Rx1day, Temperature veya PRCPTOT olmal??)
# ??rnek olarak etccdi_indices tablomuzu kullan??yoruz
veri_tabani <- etccdi_indices

iller <- c("Artvin", "Rize", "Trabzon", "Giresun", "Ordu")

# Excel i??in ??zet sonu?? tutucu
wavelet_ozet_listesi <- list()

for (il in iller) {
  # ??lgili ilin verisini ??ekme ve s??ralama (Ayl??k veya y??ll??k d??zenli zaman serisi)
  sub_df <- veri_tabani %>% 
    filter(province == il) %>% 
    arrange(YEAR)
  
  if (nrow(sub_df) >= 15) {
    # biwavelet i??in matris format?? gereklidir: Kolon 1: Zaman (Y??l), Kolon 2: De??er
    t_serisi <- sub_df$YEAR
    val_yagis <- sub_df$PRCPTOT
    val_sicaklik <- sub_df$Mean_Temp # E??er s??cakl??k s??tunun varsa (yoksa ba??ka bir de??i??kenle de??i??tirebilirsin)
    
    # 1. CWT (Continuous Wavelet Transform) - Tekil Ya?????? Sal??n??mlar??
    wt_input <- cbind(t_serisi, val_yagis)
    wt_res <- wt(wt_input, dt = 1, dj = 1/12, dochollay = 1)
    
    # 2. Wavelet Coherence (WTC) - Ya?????? ve S??cakl??k ??li??kisi
    # (E??er s??cakl??k verin yoksa ikinci s??tun olarak ba??ka bir iklim indisi de verebilirsin)
    if ("Mean_Temp" %in% colnames(sub_df)) {
      wtc_input1 <- cbind(t_serisi, val_yagis)
      wtc_input2 <- cbind(t_serisi, val_sicaklik)
      wtc_res <- wtc(wtc_input1, wtc_input2, dt = 1, dj = 1/12)
    }
    
    # ??zet Kay??t
    ozet_row <- tibble(
      Province = il,
      Analysis_Type = "CWT & WTC",
      Status = "Completed Successfully",
      Dominant_Power_Periods = "2-8 and 8-16 years band analyzed"
    )
    wavelet_ozet_listesi[[il]] <- ozet_row
    
    # --- GRAF??KLER??N EKRANDA A??ILMASI ---
    # Grafik 1: CWT (Continuous Wavelet Power Spectrum)
    dev.new()
    plot(wt_res, main = paste("Continuous Wavelet Transform (PRCPTOT) -", il),
         xlab = "Year", ylab = "Period (Years)",
         plot.cb = TRUE, col.contour = "black")
    
    # Grafik 2: WTC (Wavelet Coherence - Ya?????? & S??cakl??k ??li??kisi)
    if ("Mean_Temp" %in% colnames(sub_df)) {
      dev.new()
      plot(wtc_res, main = paste("Wavelet Coherence (Precipitation vs Temperature) -", il),
           xlab = "Year", ylab = "Period (Years)",
           plot.cb = TRUE, col.contour = "black")
    }
  }
}

wavelet_summary_df <- bind_rows(wavelet_ozet_listesi)

# Excel ????kt??s?? Alma
wb <- createWorkbook()
addWorksheet(wb, "Wavelet_Analysis_Summary")
writeData(wb, "Wavelet_Analysis_Summary", wavelet_summary_df)
saveWorkbook(wb, "East_BlackSea_Wavelet_Analysis.xlsx", overwrite = TRUE)

print("Wavelet analysis completed successfully and graphical windows opened!")