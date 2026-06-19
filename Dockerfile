# --- Stage 1 : build des dépendances ---
FROM python:3.12-slim AS builder

WORKDIR /app
COPY app/requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir --user -r requirements.txt

# --- Stage 2 : image finale, légère ---
FROM python:3.12-slim

RUN useradd -m appuser
WORKDIR /app

# On copie les packages dans le HOME de appuser, pas celui de root
COPY --from=builder /root/.local /home/appuser/.local
COPY app/ .

RUN chown -R appuser:appuser /app

ENV PATH=/home/appuser/.local/bin:$PATH
ENV PORT=8000

USER appuser

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]