import sounddevice as sd
import soundfile as sf
import matplotlib.pyplot as plt
import numpy as np
import psutil



duration = 1  # duración de la grabación en segundos
fs = 44100  # frecuencia de muestreo


umbral = -2  # nivel de sonido para activar la acción
programa_cerrar = "Dolphin.exe"

while True:
    # grabación del audio
    print("Grabando...")
    recording = sd.rec(int(duration * fs), samplerate=fs, channels=1)
    sd.wait()
    print("Grabación finalizada.")

    # guardado del audio
    sf.write("grabacion.wav", recording, fs)

    # cálculo del nivel de sonido
    decibelios = 20 * np.log10(np.max(np.abs(recording)))

    print(f"Nivel de sonido: {decibelios} dB")


    # acción si se detecta un umbral de sonido
    if decibelios > umbral:
        print("¡Se ha detectado un sonido por encima del umbral!")
        # Busca todos los procesos con el nombre "Dolphin.exe"
        for proc in psutil.process_iter(['name']):
            if proc.info['name'] == programa_cerrar:
                # Mata el proceso
                proc.kill()
        # creación de la gráfica
        plt.plot(recording)
        plt.title("Gráfico de audio")
        plt.xlabel("Muestras")
        plt.ylabel("Amplitud")
        plt.show()
        # aquí puedes poner la acción que quieras, como apagar la computadora