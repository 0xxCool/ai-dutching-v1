#!/usr/bin/env bash
# -------------------------------------------------------------
# ai-dutching-v1  |  Schritt 1.3  |  Stack: TimescaleDB + NATS + Redis
# -------------------------------------------------------------
set -euo pipefail

R='\e[31m';G='\e[32m';Y='\e[33m';B='\e[34m';N='\e[0m'

STACK_DIR=infrastructure/stack
mkdir -p $STACK_DIR

echo -e "${B}==> 1.3.1  docker-compose.yml erzeugen${N}"
cat > $STACK_DIR/docker-compose.yml <<'EOC'
version: "3.9"
services:
  timescaledb:
    image: timescale/timescaledb:latest-pg15
    container_name: tsdb
    restart: unless-stopped
    environment:
      POSTGRES_USER: ai
      POSTGRES_PASSWORD: aipass
      POSTGRES_DB: aidb
    ports: ["5432:5432"]
    volumes:
      - tsdb_data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql

  nats:
    image: nats:2.10
    container_name: nats
    restart: unless-stopped
    ports: ["4222:4222","8222:8222"]
    command: ["--http_port","8222"]

  redis:
    image: redis:7-alpine
    container_name: redis
    restart: unless-stopped
    ports: ["6379:6379"]
    volumes: ["redis_data:/data"]

volumes:
  tsdb_data:
  redis_data:
EOC

echo -e "${B}==> 1.3.2  init.sql (leer für spätere Schema-Scripts)${N}"
touch $STACK_DIR/init.sql

echo -e "${B}==> 1.3.3  Stack hochfahren${N}"
cd $STACK_DIR
docker-compose up -d

echo -e "${B}==> 1.3.4  Health-Checks${N}"
until docker exec tsdb pg_isready -U ai; do sleep 1; done
until curl -s http://localhost:8222/healthz >/dev/null; do sleep 1; done
until docker exec redis redis-cli ping | grep -q PONG; do sleep 1; done

echo -e "${B}==> 1.3.5  Git-Snapshot${N}"
cd ~/ai-dutching-v1
git add .
git commit -m "chore: stack TimescaleDB+NATS+Redis Schritt 1.3"
git push origin main

echo -e "${G}✅ Stack läuft – Ports:${N}"
echo "  TimescaleDB 5432  (user=ai  pass=aipass  db=aidb)"
echo "  NATS          4222 (Text)  8222 (HTTP-Monitor)"
echo "  Redis         6379"
