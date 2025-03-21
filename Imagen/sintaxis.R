# Ejercicio 1: Figura 1 ####
# Paquetes:
library(ggplot2)

# Codigo para exportar la imagen en la calidad y formato deseado:
png(filename = "imagen_1.png", width = 800, height = 600, units = "px",  
    pointsize = 12, bg = "white", res = 96) 

# Representación gráfica de bits ASCII con modulación FSK
# Configuración inicial
par(mar = c(5, 4, 4, 2) + 0.1)
plot(0, 0, type = "n", xlim = c(0, 7), ylim = c(-2, 2), 
     xlab = "Tiempo", ylab = "Amplitud", 
     main = "Representación de '010011' (primeros 6 bits de 'G') 
     con modulación FSK",
     xaxt = "n")

# Etiquetas en el eje x para cada bit
axis(1, at = 0:6, labels = c("", "0", "1", "0", "0", "1", "1"))

# Líneas de cuadrícula vertical para separar los bits
for (i in 1:6) {
  abline(v = i, lty = 2, col = "gray")}

# Señal digital (NRZ)
bits = c(0, 1, 0, 0, 1, 1)
digital_signal = c()
for (bit in bits) {
  if (bit == 0) {
    digital_signal = c(digital_signal, rep(-1, 10))
  } else {
    digital_signal = c(digital_signal, rep(1, 10))
  }}

x_digital = seq(0, 6, length.out = length(digital_signal))
lines(x_digital, digital_signal, col = "blue", lwd = 2)

# Modulación FSK
fsk_signal = c()
t = seq(0, 1, length.out = 100)

# Frecuencias para representar 0 y 1
freq_low = 5   
freq_high = 15 

for (bit in bits) {
  if (bit == 0) {
    # Generar una onda sinusoidal de baja frecuencia para el bit 0
    wave = sin(2 * pi * freq_low * t)
  } else {
    # Generar una onda sinusoidal de alta frecuencia para el bit 1
    wave = sin(2 * pi * freq_high * t)
  }
  fsk_signal = c(fsk_signal, wave)
}

# Amplitud de la señal FSK
fsk_signal = 0.7 * fsk_signal  

# Vector x para la señal FSK
x_fsk = seq(0, 6, length.out = length(fsk_signal))

# Señal FSK
lines(x_fsk, fsk_signal, col = "red", lwd = 1.5)

# Línea en y=0
abline(h = 0, lty = 3, col = "gray")

# Leyenda
legend("topright", 
       legend = c("Señal Digital", "Modulación FSK"), 
       col = c("blue", "red"), 
       lwd = c(2, 1.5),
       bg = "white")

text(0.5, -1.5, "Bit 0: Frecuencia baja", col = "darkred", cex = 0.8)
text(0.5, -1.8, "Bit 1: Frecuencia alta", col = "darkred", cex = 0.8)

# Guardar la imagen
dev.off()

# Ejercicio 12: Figura 11 ####
# Datos 
# Tasa de error de bit para PC-Home con cable
BER_PC = 0.0001  
# Tasa de error de bit para Laptop-Home inalámbrico
BER_Laptop = 0.0005  
# Paquete en bits
paquetes = c(100, 1000, 10000)  

# Función para calcular la tasa de error de paquete (PER)
PER = function(BER, L) {
  return(1 - (1 - BER)^L)}

# Calculo del PER para cada caso
PER_PC = sapply(paquetes, function(L) PER(BER_PC, L))
PER_Laptop = sapply(paquetes, function(L) PER(BER_Laptop, L))

df_PER = data.frame(
  paquetes_bits = rep(paquetes, 2),
  PER = c(PER_PC, PER_Laptop),
  conexion = rep(c("PC-Home (Cable)", "Laptop-Home (WiFi)"), 
                        each = length(paquetes)))

# Grafico de la relación entre el tamaño del paquete y PER
png(filename = "imagen_11.png", width = 800, height = 600, units = "px",  
    pointsize = 12, bg = "white", res = 96) 
ggplot(df_PER, aes(x = paquetes_bits, y = PER, color = conexion)) +
  geom_point(size = 3) +
  geom_line() +
  scale_x_log10() +
  labs(title = "Tasa de Error vs. Tamaño", x = "Tamaño Paquete (bits)", 
       y = "Packet Error Rate (PER)") +
  theme_minimal()
dev.off()

# Ejercicio 14: Cálculos y figura 12####

# Datos de RTT para UOC y Rice
uoc = c(27.913, 51.660, 46.325, 44.359, 49.076, 36.844, 52.808, 56.419, 45.466,
        39.420, 56.172, 60.985, 52.362, 43.406, 43.215, 54.476, 51.267, 46.857,
        41.711, 47.454)

rice = c(60.270, 32.489, 64.101, 69.218, 52.942, 81.921, 53.566, 56.587, 31.156,
         69.493, 34.203, 69.328, 36.489, 43.311, 30.825, 57.239, 55.328, 51.496,
         56.811, 53.329)

# Media de RTT
media_uoc = mean(uoc)
media_rice = mean(rice)

# Jitter usando la fórmula dada
jitter_uoc = sqrt(sum((uoc - media_uoc)^2) / length(uoc))
jitter_rice = sqrt(sum((rice - media_rice)^2) / length(rice))

# Mostrar resultados
jitter_results = data.frame(Sitio = c("www.uoc.edu", "www.rice.edu"),
                             Media_RTT = c(media_uoc, media_rice),
                             Jitter = c(jitter_uoc, jitter_rice))

png(filename = "imagen_12.png", width = 800, height = 600, units = "px",  
    pointsize = 12, bg = "white", res = 96) 

# Boxplot de la distribución de RTTs
data_rtt = data.frame(Sitio = rep(c("www.uoc.edu", "www.rice.edu"), each=20),
                       RTT = c(uoc, rice))

ggplot(data_rtt, aes(x = Sitio, y = RTT, fill = Sitio)) +
  geom_boxplot() +
  labs(title = "Distribución de RTTs para UOC y Rice", x = "Sitio Web", y = "RTT (ms)") +
  theme_minimal()

dev.off()
