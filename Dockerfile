# Usa una base Python ufficiale
FROM python:3.11-slim

# Crea la directory dell'app
WORKDIR /app

# Copia i file
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
# Espone la porta 5000
EXPOSE 5000
# Comando di avvio
CMD ["python", "app.py"]
