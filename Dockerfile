<<<<<<< HEAD
# Usa un'immagine base di Python
FROM python:3.11-slim

# Imposta la directory di lavoro
WORKDIR /app

# Copia i file nel container
=======
# Usa una base Python ufficiale
FROM python:3.11-slim

# Crea la directory dell'app
WORKDIR /app

# Copia i file
>>>>>>> 6fbfe5937991fbe8483d952d11c80d567a601510
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

<<<<<<< HEAD
# Espone la porta su cui gira Flask
EXPOSE 5000

# Comando per avviare l'app
=======
# Espone la porta 5000
EXPOSE 5000

# Comando di avvio
>>>>>>> 6fbfe5937991fbe8483d952d11c80d567a601510
CMD ["python", "app.py"]
