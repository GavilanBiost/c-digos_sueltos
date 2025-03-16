# Codigo para exportar la imagen en la calidad y formato deseado:
png(filename = "imagen_1.png", width = 800, height = 600, units = "px",  
    pointsize = 12, bg = "white", res = 96) 

# Representación gráfica de bits ASCII con modulación FSK
# Configuración inicial
par(mar = c(5, 4, 4, 2) + 0.1)
plot(0, 0, type = "n", xlim = c(0, 7), ylim = c(-2, 2), 
     xlab = "Tiempo", ylab = "Amplitud", 
     main = "Representación de '010011' (primeros 6 bits de 'G') con modulación FSK",
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

