import base64
import io
from PIL import Image
import app.integrations.openai_vision as ov


def _make_image_bytes(size=(2000, 2000), color=(255, 0, 0)):
  img = Image.new("RGB", size, color=color)
  buf = io.BytesIO()
  img.save(buf, format="PNG")
  return buf.getvalue()


def test_resize_reduces_image_size():
  raw = _make_image_bytes()
  normalized_bytes, _ = ov._normalize_image(raw)
  assert len(normalized_bytes) < len(raw)
  img = Image.open(io.BytesIO(normalized_bytes))
  assert max(img.size) <= ov.MAX_SIDE


def test_cache_hit_avoids_network(monkeypatch):
  raw = _make_image_bytes(size=(512, 512))
  b64 = base64.b64encode(raw).decode("utf-8")

  def fake_cache_get(_):
    return {
      "canonical_key": "item.battery",
      "confidence": 0.9,
      "labels": ["battery"],
      "notes": "cache_hit",
    }

  def fake_call_openai(*args, **kwargs):
    raise AssertionError("network call should not happen on cache hit")

  monkeypatch.setattr(ov, "_cache_get", fake_cache_get)
  monkeypatch.setattr(ov, "_call_openai", fake_call_openai)
  monkeypatch.setattr(ov, "_cache_set", lambda *args, **kwargs: None)
  monkeypatch.setattr(ov, "_normalize_image", lambda _: (b"fake", base64.b64encode(b"fake").decode("utf-8")))

  res = ov.recognize_item_from_base64(b64, "de")
  assert res["canonical_key"] == "item.battery"
  assert res["notes"] == "cache_hit"
