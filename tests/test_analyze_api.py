import base64
from fastapi.testclient import TestClient
from app.main import app


client = TestClient(app)


def test_analyze_stub_works_without_api_key(monkeypatch):
  # monkeypatch recognize_item_from_base64 to avoid base64 validation complexity
  def fake_recognize(img, lang):
    return {"canonical_key": "akkus", "confidence": 0.5, "labels": ["akkus"], "notes": "test_stub"}

  monkeypatch.setattr("app.main.recognize_item_from_base64", fake_recognize)

  # also patch _find_item_id to bypass DB
  monkeypatch.setattr("app.main._find_item_id", lambda db, ck: "fake-id")
  # patch resolve_item to bypass DB
  monkeypatch.setattr(
    "app.main.resolve_item",
    lambda db, city, item_id, lang, item_name=None: {
      "item": {"id": item_id, "canonical_key": "akkus", "title": "Akkus", "description": "desc"},
      "disposals": [],
      "warnings": [],
      "suggestions": [],
      "prospect": {"created": False, "needed": False},
    },
  )

  payload = {
    "city": "hannover",
    "lang": "de",
    "image_base64": base64.b64encode(b"fake").decode(),
  }
  res = client.post("/analyze", json=payload)
  assert res.status_code == 200
  body = res.json()
  assert body["item"]["canonical_key"] == "akkus"
  assert body["recycle"]["disposals"] == []
  assert body["repair"]["available"] is False
  assert body["donate"]["available"] is False


def test_analyze_invalid_base64(monkeypatch):
  res = client.post(
    "/analyze",
    json={"city": "hannover", "lang": "de", "image_base64": "!!!not_base64"},
  )
  assert res.status_code == 400
