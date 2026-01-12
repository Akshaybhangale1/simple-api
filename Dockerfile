# -------- Stage 1: Build --------
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# -------- Stage 2: Runtime --------
FROM python:3.11-slim
WORKDIR /app

RUN useradd -m appuser
COPY --from=builder /usr/local /usr/local
COPY app.py .

USER appuser
EXPOSE 8080

HEALTHCHECK CMD curl --fail http://localhost:8080/health || exit 1

CMD ["python", "app.py"]
