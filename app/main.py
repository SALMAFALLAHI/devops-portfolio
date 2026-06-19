import logging
import os
from fastapi import FastAPI, Response

LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
logging.basicConfig(level=LOG_LEVEL)
logger = logging.getLogger(__name__)

app = FastAPI(title="DevOps Portfolio API")

# Données fictives en mémoire (pas de vraie base de données pour l'instant)
items = [
    {"id": 1, "name": "Terraform"},
    {"id": 2, "name": "Kubernetes"},
]

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/items")
def get_items():
    logger.info("GET /items appelé")
    return items

@app.post("/items")
def add_item(item: dict):
    items.append(item)
    logger.info(f"Item ajouté : {item}")
    return item