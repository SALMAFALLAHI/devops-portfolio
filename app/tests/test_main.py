from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


def test_health_returns_ok():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_get_items_returns_list():
    response = client.get("/items")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
    assert len(response.json()) >= 2


def test_post_item_adds_to_list():
    new_item = {"id": 99, "name": "Pytest"}
    response = client.post("/items", json=new_item)
    assert response.status_code == 200
    assert response.json() == new_item

    # Vérifie que l'item est bien dans la liste après ajout
    items = client.get("/items").json()
    assert any(item["name"] == "Pytest" for item in items)