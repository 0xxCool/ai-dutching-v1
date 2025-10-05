#!/usr/bin/env bash
# -------------------------------------------------------------
# ai-dutching-v1  |  Schritt 1.4  |  .env + req + CLI
# -------------------------------------------------------------
set -euo pipefail

R='\e[31m';G='\e[32m';Y='\e[33m';B='\e[34m';N='\e[0m'

echo -e "${B}==> 1.4.1  .env erzeugen${N}"
cat > .env <<'EOE'
# === Core ====================================================
AI_ENV=dev
AI_ROOT=/home/$(whoami)/ai-dutching-v1

# === Datenbank ===============================================
POSTGRES_USER=ai
POSTGRES_PASSWORD=aipass
POSTGRES_DB=aidb
POSTGRES_HOST=localhost
POSTGRES_PORT=5432

# === Messaging ===============================================
NATS_URL=nats://localhost:4222

# === Cache ===================================================
REDIS_URL=redis://localhost:6379

# === API-Keys (hier eintragen) ===============================
PINNACLE_API_KEY=
PINNACLE_CLIENT_ID=
BETFAIR_USERNAME=
BETFAIR_PASSWORD=
BETFAIR_APP_KEY=
EOE

echo -e "${B}==> 1.4.2  requirements.txt${N}"
cat > requirements.txt <<'EOR'
# --- core ---------------
numpy==1.24.3
pandas==2.2.0
scipy==1.12.0
scikit-learn==1.4.2

# --- db & cache ---------
psycopg[binary]==3.1.18
redis==5.0.4
sqlalchemy==2.0.30
asyncpg==0.29.0

# --- messaging ----------
nats-py==2.7.2

# --- http ---------------
aiohttp==3.9.5
httpx==0.27.0

# --- env ----------------
python-dotenv==1.0.1

# --- cli ----------------
click==8.1.7
rich==13.7.1

# --- later --------------
# torch==2.2.0+cu121
# lightning==2.2
# cvxpy==1.4
# evidently==0.4.20
EOR

echo -e "${B}==> 1.4.3  CLI-Grundgerüst${N}"
mkdir -p cli
cat > cli/aicli <<'EOC'
#!/usr/bin/env python3
"""
aicli – ai-dutching-v1 command-line interface
"""
import click, os, dotenv
from rich.console import Console

dotenv.load_dotenv()
console = Console()

@click.group()
def cli():
    """AI Dutching V1 – CLI"""
    pass

@cli.command()
def ping():
    """Test ob Umgebung läuft"""
    console.print("[green]pong[/green] – .env geladen")

if __name__ == "__main__":
    cli()
EOC
chmod +x cli/aicli

echo -e "${B}==> 1.4.4  Install inside venv${N}"
source venv/bin/activate
pip install -r requirements.txt

echo -e "${B}==> 1.4.5  Test-Call${N}"
./cli/aicli ping

echo -e "${B}==> 1.4.6  Git-Snapshot${N}"
git add .
git commit -m "chore: .env + req + CLI Schritt 1.4"
git push origin main

echo -e "${G}✅ 1.4 fertig – nächstes Kommando:${N}"
echo "  ./cli/aicli --help"
