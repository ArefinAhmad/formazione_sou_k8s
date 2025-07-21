# Usa un'immagine base di Python
FROM python:3.11-slim

# Imposta la directory di lavoro
WORKDIR /app

# Copia i file nel container
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Espone la porta su cui gira Flask
EXPOSE 5000

# Comando per avviare l'app
CMD ["python", "app.py"]
