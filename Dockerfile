FROM node:20-alpine AS frontend-builder

WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build

FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app
COPY migrations ./migrations
COPY run.py ./
COPY start.sh ./

COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

RUN chmod +x /app/start.sh

EXPOSE 10000

CMD ["./start.sh"]