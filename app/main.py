import logging
import os
from fastapi import FastAPI, Response

LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
logging.basicConfig(level=LOG_LEVEL)
logger = logging.getLogger(__name__)

app = FastAPI(title="DevOps Portfolio API")

REQUEST_COUNT = 0

@app.middleware("http")
async def count_requests(request, call_next):
    global REQUEST_COUNT
    REQUEST_COUNT += 1
    response = await call_next(request)
    return response

items = [
    {"id": 1, "name": "Terraform"},
    {"id": 2, "name": "Kubernetes"},
]

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/metrics")
def metrics():
    content = f"# HELP http_requests_total Total HTTP requests\n# TYPE http_requests_total counter\nhttp_requests_total {REQUEST_COUNT}\n"
    return Response(content=content, media_type="text/plain")

@app.get("/items")
def get_items():
    logger.info("GET /items appelé")
    return items

@app.post("/items")
def add_item(item: dict):
    items.append(item)
    logger.info(f"Item ajouté : {item}")
    return item