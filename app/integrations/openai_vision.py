from __future__ import annotations
import base64
import hashlib
import io
import json
import re
import os
import time
from typing import Dict, Any, List, Optional, Tuple
from fastapi import HTTPException
from sqlalchemy import create_engine, text
from PIL import Image, UnidentifiedImageError
import httpx
import logging

logger = logging.getLogger("openai_vision")
_logged_no_db = False

VISION_PROMPT = (
  'Return JSON only: {"canonical_key":..., "confidence":..., "labels":[...], "notes":...}. '
  'canonical_key=lowercase slug (no "item.", use _). If unsure: canonical_key=null, confidence<=0.3. '
  'labels: max 5, <=20 chars; include singular+plural of main object. No extra text.'
)

DEFAULT_MODEL = os.getenv("OPENAI_VISION_MODEL", "gpt-4o-mini")
MAX_SIDE = int(os.getenv("OPENAI_VISION_MAX_IMAGE_SIDE", "768"))
JPEG_QUALITY = int(os.getenv("OPENAI_VISION_JPEG_QUALITY", "75"))
CACHE_TTL_DAYS = int(os.getenv("VISION_CACHE_TTL_DAYS", "30"))
IMAGE_STORAGE_DIR = os.getenv("IMAGE_STORAGE_DIR", "data/images")


def _clean_base64(image_base64: str) -> str:
  if not isinstance(image_base64, str):
    return ""
  value = image_base64.strip()
  if value.startswith("data:") and "," in value:
    value = value.split(",", 1)[1]
  pad = (-len(value)) % 4
  if pad:
    value += "=" * pad
  return value


def _validate_base64(image_base64: str) -> bytes:
  cleaned = _clean_base64(image_base64)
  try:
    return base64.b64decode(cleaned, validate=True)
  except Exception:
    try:
      return base64.urlsafe_b64decode(cleaned)
    except Exception:
      raise HTTPException(status_code=400, detail="invalid_image_base64")


def _normalize_image(image_bytes: bytes) -> Tuple[bytes, str, int, int]:
  try:
    img = Image.open(io.BytesIO(image_bytes))
  except (UnidentifiedImageError, OSError, ValueError):
    raise HTTPException(status_code=400, detail="invalid_image_base64")
  img = img.convert("RGB")
  w, h = img.size
  scale = min(1.0, float(MAX_SIDE) / float(max(w, h)))
  if scale < 1.0:
    img = img.resize((int(w * scale), int(h * scale)))
    w, h = img.size
  buf = io.BytesIO()
  img.save(buf, format="JPEG", quality=JPEG_QUALITY, optimize=True)
  normalized_bytes = buf.getvalue()
  normalized_b64 = base64.b64encode(normalized_bytes).decode("utf-8")
  return normalized_bytes, normalized_b64, w, h


def _cache_key(image_bytes: bytes, model: str) -> str:
  h = hashlib.sha256(image_bytes).hexdigest()
  return f"{h}:{model}"


def _get_engine():
  db_url = os.getenv("DATABASE_URL")
  if not db_url:
    global _logged_no_db
    if not _logged_no_db:
      logger.warning("vision cache disabled: DATABASE_URL missing")
      print("vision: cache disabled (DATABASE_URL missing)")
      _logged_no_db = True
    return None
  return create_engine(db_url, pool_pre_ping=True)


def _cache_get(cache_key: str) -> Optional[Dict[str, Any]]:
  engine = _get_engine()
  if not engine:
    return None
  with engine.connect() as conn:
    row = conn.execute(
      text(
        """
        SELECT canonical_key, confidence, labels, notes, image_id::text
        FROM core.vision_cache
        WHERE cache_key = :k AND expires_at > now()
        """
      ),
      {"k": cache_key},
    ).fetchone()
    if not row:
      return None
    return {
      "canonical_key": row[0],
      "confidence": float(row[1]),
      "labels": row[2],
      "notes": row[3] or "cache_hit",
      "image_id": row[4],
    }


def _cache_set(cache_key: str, payload: Dict[str, Any]) -> None:
  engine = _get_engine()
  if not engine:
    logger.info("vision: cache_set skipped (DATABASE_URL missing)")
    print("vision: cache_set skipped (DATABASE_URL missing)")
    return
  expires_at = time.time() + CACHE_TTL_DAYS * 86400
  try:
    with engine.begin() as conn:
      conn.execute(
        text(
          """
          INSERT INTO core.vision_cache (cache_key, image_id, canonical_key, confidence, labels, notes, created_at, expires_at)
          VALUES (:k, :image_id, :ck, :conf, CAST(:labels AS jsonb), :notes, now(), to_timestamp(:exp))
          ON CONFLICT (cache_key) DO UPDATE
          SET image_id = COALESCE(EXCLUDED.image_id, core.vision_cache.image_id),
              canonical_key = EXCLUDED.canonical_key,
              confidence = EXCLUDED.confidence,
              labels = EXCLUDED.labels,
              notes = EXCLUDED.notes,
              expires_at = EXCLUDED.expires_at
          """
        ),
        {
          "k": cache_key,
          "image_id": payload.get("image_id"),
          "ck": payload.get("canonical_key"),
          "conf": float(payload.get("confidence", 0.0)),
          "labels": json.dumps(payload.get("labels", [])),
          "notes": payload.get("notes"),
          "exp": expires_at,
        },
      )
    logger.info("vision: cache_set key=%s", cache_key)
    print(f"vision: cache_set key={cache_key}")
  except Exception as exc:
    logger.warning("vision: cache_set failed: %s", exc)
    print(f"vision: cache_set failed: {exc}")


def _extract_json(text_content: str) -> Dict[str, Any]:
  if not text_content:
    return {"canonical_key": None, "confidence": 0.0, "labels": [], "notes": "parse_error"}
  try:
    return json.loads(text_content)
  except Exception:
    pass
  start = text_content.find("{")
  end = text_content.rfind("}")
  if start >= 0 and end > start:
    try:
      return json.loads(text_content[start : end + 1])
    except Exception:
      pass
  return {"canonical_key": None, "confidence": 0.0, "labels": [], "notes": "parse_error"}


def _extract_text_from_response(data: Dict[str, Any]) -> str:
  output_text = data.get("output_text")
  if isinstance(output_text, str) and output_text.strip():
    return output_text
  for out in data.get("output", []):
    for c in out.get("content", []):
      if c.get("type") == "output_text":
        return c.get("text", "")
  return ""


def _normalize_labels(labels: List[str]) -> List[str]:
  out = []
  for l in labels:
    if not l:
      continue
    val = l.strip().lower()[:20]
    if val and val not in out:
      out.append(val)
    if len(out) >= 5:
      break
  return out


def _call_openai(image_base64: str, lang: str) -> Dict[str, Any]:
  api_key = os.getenv("OPENAI_API_KEY")
  if not api_key:
    logger.info("vision: OPENAI_API_KEY missing, using stub")
    print("vision: OPENAI_API_KEY missing, using stub")
    return {
      "canonical_key": "item.battery",
      "confidence": 0.5,
      "labels": ["battery"],
      "notes": "stub",
    }
  model = DEFAULT_MODEL
  headers = {"Authorization": f"Bearer {api_key}"}
  payload = {
    "model": model,
    "messages": [
      {
        "role": "user",
        "content": [
          {"type": "text", "text": f"{VISION_PROMPT} Language={lang}"},
          {
            "type": "image_url",
            "image_url": {
              "url": f"data:image/jpeg;base64,{image_base64}",
              "detail": "low",
            },
          },
        ],
      }
    ],
    "response_format": {"type": "json_object"},
    "max_tokens": 120,
    "temperature": 0,
  }
  url = "https://api.openai.com/v1/chat/completions"
  timeout = httpx.Timeout(10.0)
  for attempt in range(2):
    try:
      logger.info("vision: calling openai model=%s image_bytes=%s", model, len(image_base64))
      print(f"vision: calling openai model={model} image_bytes={len(image_base64)}")
      with httpx.Client(timeout=timeout) as client:
        resp = client.post(url, headers=headers, json=payload)
      print(f"vision: response status={resp.status_code}")
      if resp.status_code >= 400:
        body_preview = (resp.text or "")[:200]
        msg = f"vision_error: status={resp.status_code} body={body_preview}"
        logger.warning(msg)
        return {"canonical_key": None, "confidence": 0.0, "labels": [], "notes": msg}
      data = resp.json()
      text_content = ""
      try:
        text_content = data.get("choices", [])[0].get("message", {}).get("content", "") or ""
      except Exception:
        text_content = ""
      logger.info("vision raw completion=%s", text_content)
      print(f"vision: completion={text_content[:400]}")
      result = _extract_json(text_content)
      return result
    except Exception as exc:
      print(f"vision: exception={exc}")
      if attempt == 1:
        break
  logger.warning("vision_error: exception_or_timeout")
  return {"canonical_key": None, "confidence": 0.0, "labels": [], "notes": "vision_error: exception_or_timeout"}


def _upsert_image_asset(
  normalized_bytes: bytes,
  sha256_hash: str,
  width: int,
  height: int,
  source: str = "scan",
) -> Optional[str]:
  engine = _get_engine()
  if not engine:
    return None
  os.makedirs(IMAGE_STORAGE_DIR, exist_ok=True)
  filename = f"{sha256_hash}.jpg"
  storage_key = os.path.join(IMAGE_STORAGE_DIR, filename)
  if not os.path.exists(storage_key):
    with open(storage_key, "wb") as f:
      f.write(normalized_bytes)
  try:
    with engine.begin() as conn:
      row = conn.execute(
        text(
          """
          INSERT INTO core.image_asset
            (storage_key, normalized_sha256, content_type, byte_size, width, height, source)
          VALUES
            (:storage_key, :sha256, :content_type, :byte_size, :width, :height, :source)
          ON CONFLICT (normalized_sha256) DO UPDATE
          SET storage_key = EXCLUDED.storage_key
          RETURNING image_id::text
          """
        ),
        {
          "storage_key": storage_key.replace("\\", "/"),
          "sha256": sha256_hash,
          "content_type": "image/jpeg",
          "byte_size": len(normalized_bytes),
          "width": width,
          "height": height,
          "source": source,
        },
      ).fetchone()
      return row[0] if row else None
  except Exception as exc:
    logger.warning("vision: image_asset upsert failed: %s", exc)
    print(f"vision: image_asset upsert failed: {exc}")
    return None


def recognize_item_from_base64(image_base64: str, lang: str) -> Dict[str, Any]:
  raw_bytes = _validate_base64(image_base64)
  normalized_bytes, normalized_b64, width, height = _normalize_image(raw_bytes)
  model = DEFAULT_MODEL
  cache_key = _cache_key(normalized_bytes, model)
  sha256_hash = cache_key.split(":", 1)[0]
  image_id = _upsert_image_asset(normalized_bytes, sha256_hash, width, height, source="scan")
  logger.info("vision: cache_lookup key=%s", cache_key)
  print(f"vision: cache_lookup key={cache_key}")

  cached = _cache_get(cache_key)
  if cached:
    logger.info("vision: cache_hit key=%s", cache_key)
    print(f"vision: cache_hit key={cache_key}")
    if not isinstance(cached.get("labels"), list):
      try:
        cached["labels"] = json.loads(cached.get("labels"))
      except Exception:
        cached["labels"] = []
    cached["cache_key"] = cache_key
    if image_id:
      cached["image_id"] = image_id
    return cached

  logger.info("vision: cache_miss key=%s", cache_key)
  print(f"vision: cache_miss key={cache_key}")
  result = _call_openai(normalized_b64, lang)
  labels = _normalize_labels(result.get("labels", []))
  canonical_key = result.get("canonical_key")
  confidence = float(result.get("confidence", 0.0))
  if canonical_key is not None and not isinstance(canonical_key, str):
    logger.warning("vision: canonical_key invalid type=%s", type(canonical_key))
    canonical_key = None
  if isinstance(canonical_key, str):
    canonical_key = canonical_key.strip().lower()
  if canonical_key and not re.match(r"^[a-z0-9_]+$", canonical_key):
    logger.warning("vision: canonical_key rejected value=%s", canonical_key)
    canonical_key = None
  if canonical_key is None:
    confidence = min(confidence, 0.3)
  out = {
    "canonical_key": canonical_key,
    "confidence": max(0.0, min(1.0, confidence)),
    "labels": labels,
    "notes": result.get("notes"),
    "image_id": image_id,
    "cache_key": cache_key,
  }
  _cache_set(cache_key, out)
  return out


def store_image_from_base64(image_base64: str, source: str = "admin") -> Dict[str, Any]:
  raw_bytes = _validate_base64(image_base64)
  normalized_bytes, _, width, height = _normalize_image(raw_bytes)
  sha256_hash = hashlib.sha256(normalized_bytes).hexdigest()
  image_id = _upsert_image_asset(normalized_bytes, sha256_hash, width, height, source=source)
  if not image_id:
    raise HTTPException(status_code=500, detail="image_store_failed")
  return {
    "image_id": image_id,
    "sha256": sha256_hash,
    "width": width,
    "height": height,
  }
