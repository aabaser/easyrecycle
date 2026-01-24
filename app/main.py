from typing import Optional
import logging
import os
from dotenv import load_dotenv
import time
from fastapi import FastAPI, Depends, Query, Body, HTTPException, Request
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from app.db import get_db
from app.services.resolve import resolve_item
from app.integrations.openai_vision import recognize_item_from_base64, store_image_from_base64
from pydantic import BaseModel
from sqlalchemy import text

load_dotenv()
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("easy_recycle")
app = FastAPI(title="Easy Recycle API")

# CORS for local file/test UIs (e.g., docs/ui_mock.html opened via file://)
app.add_middleware(
  CORSMiddleware,
  allow_origins=["*"],
  allow_credentials=False,
  allow_methods=["*"],
  allow_headers=["*"],
)


@app.middleware("http")
async def log_requests(request: Request, call_next):
  start = time.perf_counter()
  response = await call_next(request)
  duration_ms = (time.perf_counter() - start) * 1000.0
  logger.info(
    "http: %s %s -> %s %.1fms",
    request.method,
    request.url.path,
    response.status_code,
    duration_ms,
  )
  return response

@app.get("/health")
def health():
  return {"ok": True}

@app.get("/resolve")
def resolve(
  city: str = Query(..., description="city code, e.g. hannover, berlin"),
  item_id: Optional[str] = Query(None, description="UUID of item (required if item_name is empty)"),
  lang: str = Query("de", description="de/en/tr"),
  item_name: Optional[str] = Query(None, description="Free-text item name (required if item_id is empty)"),
  db: Session = Depends(get_db),
):
  logger.info(
    "resolve: start city=%s lang=%s item_id=%s item_name=%s",
    city,
    lang,
    item_id,
    item_name,
  )
  resolved = resolve_item(db, city, item_id, lang, item_name=item_name)
  suggestions_count = len(resolved.get("suggestions") or [])
  logger.info(
    "resolve: done item=%s error=%s suggestions=%s prospect=%s",
    bool(resolved.get("item")),
    resolved.get("error"),
    suggestions_count,
    bool(resolved.get("prospect")),
  )
  return resolved


class AnalyzeRequest(BaseModel):
  city: str
  lang: str
  image_base64: str
  search_text: Optional[str] = None


class AnalyzeResponse(BaseModel):
  item: Optional[dict]
  recycle: dict
  repair: dict
  donate: dict
  warnings: list
  debug: dict
  suggestions: Optional[list] = None
  prospect: Optional[dict] = None
  error: Optional[str] = None


class FeedbackRequest(BaseModel):
  city: str
  item_id: str
  feedback: int
  lang: Optional[str] = None
  source: Optional[str] = None
  session_id: str


class FeedbackResponse(BaseModel):
  ok: bool


class AdminImageUploadRequest(BaseModel):
  image_base64: str
  source: Optional[str] = "admin"


class AdminItemUpdateRequest(BaseModel):
  city: str
  lang: str
  title: Optional[str] = None
  description: Optional[str] = None
  category_codes: Optional[list[str]] = None
  disposal_codes: Optional[list[str]] = None
  warning_codes: Optional[list[str]] = None
  primary_image_id: Optional[str] = None
  is_active: Optional[bool] = None


class AdminItemImageUploadRequest(BaseModel):
  city: str
  image_base64: str
  source: Optional[str] = "admin"


def _find_item_id(db: Session, canonical_key: str) -> Optional[str]:
  row = db.execute(text("SELECT item_id::text FROM core.item WHERE canonical_key = :ck"), {"ck": canonical_key}).fetchone()
  if row:
    return row[0]
  # fallback: if canonical_key lacks prefix, try item.<ck>; if has prefix, try without
  alt = None
  if canonical_key.startswith("item."):
    alt = canonical_key.split("item.", 1)[1]
  else:
    alt = f"item.{canonical_key}"
  row = db.execute(text("SELECT item_id::text FROM core.item WHERE canonical_key = :ck"), {"ck": alt}).fetchone()
  return row[0] if row else None


def _city_id_from_code(db: Session, city_code: str) -> Optional[str]:
  row = db.execute(
    text("SELECT city_id::text FROM core.city WHERE code = :code"),
    {"code": city_code},
  ).fetchone()
  return row[0] if row else None


def _find_prospect_id(
  db: Session,
  city_id: Optional[str],
  lang: str,
  item_id: Optional[str],
  search_text: Optional[str],
) -> Optional[str]:
  if not city_id:
    return None
  if item_id:
    row = db.execute(
      text(
        """
        SELECT prospect_id::text
        FROM core.prospect
        WHERE item_id = :item_id AND city_id = :city_id AND lang = :lang
        ORDER BY updated_at DESC
        LIMIT 1
        """
      ),
      {"item_id": item_id, "city_id": city_id, "lang": lang},
    ).fetchone()
    return row[0] if row else None
  if search_text:
    row = db.execute(
      text(
        """
        SELECT prospect_id::text
        FROM core.prospect
        WHERE search_text = :search_text AND city_id = :city_id AND lang = :lang
        ORDER BY updated_at DESC
        LIMIT 1
        """
      ),
      {"search_text": search_text, "city_id": city_id, "lang": lang},
    ).fetchone()
    return row[0] if row else None
  return None


def _insert_scan_event(
  db: Session,
  image_id: Optional[str],
  cache_key: Optional[str],
  city_id: Optional[str],
  item_id: Optional[str],
  prospect_id: Optional[str],
  search_text: Optional[str],
  source: str = "scan",
) -> None:
  if not image_id or not city_id:
    return
  db.execute(
    text(
      """
      INSERT INTO core.scan_event
        (image_id, cache_key, city_id, item_id, prospect_id, search_text, source, created_at)
      VALUES
        (:image_id, :cache_key, :city_id, :item_id, :prospect_id, :search_text, :source, now())
      """
    ),
    {
      "image_id": image_id,
      "cache_key": cache_key,
      "city_id": city_id,
      "item_id": item_id,
      "prospect_id": prospect_id,
      "search_text": search_text,
      "source": source,
    },
  )
  db.commit()


def _image_url(image_id: Optional[str]) -> Optional[str]:
  return f"/images/{image_id}" if image_id else None


def _t(db: Session, key: Optional[str], lang: str) -> Optional[str]:
  if not key:
    return None
  row = db.execute(
    text("SELECT text FROM core.i18n_translation WHERE key = :key AND lang = :lang"),
    {"key": key, "lang": lang},
  ).fetchone()
  return row[0] if row else None


def _upsert_translation(db: Session, key: str, lang: str, text_value: str) -> None:
  db.execute(
    text(
      """
      INSERT INTO core.i18n_translation (key, lang, text, updated_at)
      VALUES (:key, :lang, :text, now())
      ON CONFLICT (key, lang) DO UPDATE
      SET text = EXCLUDED.text, updated_at = now()
      """
    ),
    {"key": key, "lang": lang, "text": text_value},
  )


def _fetch_ids_by_codes(
  db: Session,
  table: str,
  code_col: str,
  id_col: str,
  codes: list[str],
) -> dict[str, str]:
  if not codes:
    return {}
  rows = db.execute(
    text(
      f"SELECT {code_col}, {id_col}::text FROM {table} WHERE {code_col} = ANY(:codes)"
    ),
    {"codes": codes},
  ).fetchall()
  mapping = {r[0]: r[1] for r in rows}
  missing = [c for c in codes if c not in mapping]
  if missing:
    raise HTTPException(status_code=400, detail=f"unknown_codes:{','.join(missing)}")
  return mapping


def _update_item_city_list(
  db: Session,
  table: str,
  city_id: str,
  item_id: str,
  ref_table: str,
  ref_code_col: str,
  ref_id_col: str,
  codes: Optional[list[str]],
  has_priority: bool = False,
) -> None:
  if codes is None:
    return
  seen = set()
  codes = [c for c in codes if c and not (c in seen or seen.add(c))]
  db.execute(
    text(f"DELETE FROM {table} WHERE city_id = :city_id AND item_id::uuid = :item_id"),
    {"city_id": city_id, "item_id": item_id},
  )
  if not codes:
    return
  mapping = _fetch_ids_by_codes(db, ref_table, ref_code_col, ref_id_col, codes)
  for idx, code in enumerate(codes, start=1):
    values = {
      "city_id": city_id,
      "item_id": item_id,
      "ref_id": mapping[code],
      "priority": idx,
    }
    if has_priority:
      db.execute(
        text(
          f"""
          INSERT INTO {table} (city_id, item_id, {ref_id_col}, priority)
          VALUES (:city_id, :item_id, :ref_id, :priority)
          """
        ),
        values,
      )
    else:
      db.execute(
        text(
          f"""
          INSERT INTO {table} (city_id, item_id, {ref_id_col})
          VALUES (:city_id, :item_id, :ref_id)
          """
        ),
        values,
      )


def _admin_item_detail(db: Session, item_id: str, city_id: str, lang: str) -> dict:
  row = db.execute(
    text(
      """
      SELECT item_id::text, canonical_key, title_key, desc_key, is_active, primary_image_id::text
      FROM core.item
      WHERE item_id::uuid = :item_id
      """
    ),
    {"item_id": item_id},
  ).fetchone()
  if not row:
    raise HTTPException(status_code=404, detail="item_not_found")
  title = _t(db, row[2], lang)
  desc = _t(db, row[3], lang)
  image_id = row[5]

  categories = db.execute(
    text(
      """
      SELECT c.code, c.name_key
      FROM core.item_city_category icc
      JOIN core.category c ON c.category_id = icc.category_id
      WHERE icc.city_id = :city_id AND icc.item_id::uuid = :item_id
      ORDER BY icc.priority ASC
      """
    ),
    {"city_id": city_id, "item_id": item_id},
  ).fetchall()
  disposals = db.execute(
    text(
      """
      SELECT d.code, d.name_key
      FROM core.item_city_disposal icd
      JOIN core.disposal_method d ON d.disposal_id = icd.disposal_id
      WHERE icd.city_id = :city_id AND icd.item_id::uuid = :item_id
      ORDER BY icd.priority ASC
      """
    ),
    {"city_id": city_id, "item_id": item_id},
  ).fetchall()
  warnings = db.execute(
    text(
      """
      SELECT w.code, w.title_key, w.severity
      FROM core.item_city_warning icw
      JOIN core.warning w ON w.warning_id = icw.warning_id
      WHERE icw.city_id = :city_id AND icw.item_id::uuid = :item_id
      ORDER BY w.code ASC
      """
    ),
    {"city_id": city_id, "item_id": item_id},
  ).fetchall()

  return {
    "item": {
      "id": row[0],
      "canonical_key": row[1],
      "title": title,
      "description": desc,
      "is_active": row[4],
      "primary_image_id": image_id,
      "image_url": _image_url(image_id),
    },
    "categories": [{"code": r[0], "label": _t(db, r[1], lang)} for r in categories],
    "disposals": [{"code": r[0], "label": _t(db, r[1], lang)} for r in disposals],
    "warnings": [
      {"code": r[0], "label": _t(db, r[1], lang), "severity": int(r[2])}
      for r in warnings
    ],
  }

@app.post("/analyze", response_model=AnalyzeResponse)
def analyze(payload: AnalyzeRequest = Body(...), db: Session = Depends(get_db)):
  logger.info(
    "analyze: start city=%s lang=%s has_image=%s image_len=%s has_search_text=%s",
    payload.city,
    payload.lang,
    bool(payload.image_base64),
    len(payload.image_base64 or ""),
    bool(payload.search_text),
  )
  # validate base64 inside recognize_item_from_base64
  vision = recognize_item_from_base64(payload.image_base64, payload.lang)
  canonical_key = vision.get("canonical_key")
  item_id = _find_item_id(db, canonical_key) if canonical_key else None
  image_id = vision.get("image_id")
  cache_key = vision.get("cache_key")
  city_id = _city_id_from_code(db, payload.city)
  logger.info(
    "analyze: vision canonical_key=%s confidence=%s labels=%s notes=%s item_id=%s",
    canonical_key,
    vision.get("confidence"),
    len(vision.get("labels") or []),
    vision.get("notes"),
    item_id,
  )

  # If no canonical_key or item_id not found, fall back to suggestion/prospect flow using labels/search_text.
  if not item_id:
    search_text = payload.search_text
    if not search_text and vision.get("labels"):
      search_text = vision["labels"][0]
    if not search_text:
      _insert_scan_event(
        db,
        image_id=image_id,
        cache_key=cache_key,
        city_id=city_id,
        item_id=None,
        prospect_id=None,
        search_text=None,
        source="scan",
      )
      logger.info("analyze: no item_id and no search_text -> item_not_found")
      return AnalyzeResponse(
        item=None,
        recycle={"disposals": []},
        repair={"available": False},
        donate={"available": False},
        warnings=[],
        suggestions=None,
        prospect=None,
        error="item_not_found",
        debug={"city_chain": [payload.city], "vision": vision},
      )
    resolved = resolve_item(db, payload.city, None, payload.lang, item_name=search_text)
    resolved_item = resolved.get("item") or {}
    resolved_item_id = resolved_item.get("id")
    prospect_id = None
    if resolved.get("prospect"):
      prospect_id = _find_prospect_id(
        db,
        city_id=city_id,
        lang=payload.lang,
        item_id=resolved_item_id,
        search_text=search_text,
      )
    _insert_scan_event(
      db,
      image_id=image_id,
      cache_key=cache_key,
      city_id=city_id,
      item_id=resolved_item_id,
      prospect_id=prospect_id,
      search_text=search_text,
      source="scan",
    )
    logger.info(
      "analyze: resolve fallback item=%s error=%s suggestions=%s prospect=%s",
      bool(resolved.get("item")),
      resolved.get("error"),
      len(resolved.get("suggestions") or []),
      bool(resolved.get("prospect")),
    )
    return AnalyzeResponse(
      item=resolved.get("item"),
      recycle={"disposals": resolved.get("disposals", [])},
      repair={"available": False},
      donate={"available": False},
      warnings=resolved.get("warnings", []),
      suggestions=resolved.get("suggestions"),
      prospect=resolved.get("prospect"),
      error=resolved.get("error") or ("item_not_found" if resolved.get("not_found") else None),
      debug={"city_chain": [payload.city], "vision": vision},
    )

  resolved = resolve_item(db, payload.city, item_id, payload.lang, item_name=payload.search_text)
  prospect_id = None
  if resolved.get("prospect"):
    prospect_id = _find_prospect_id(
      db,
      city_id=city_id,
      lang=payload.lang,
      item_id=item_id,
      search_text=payload.search_text,
    )
  _insert_scan_event(
    db,
    image_id=image_id,
    cache_key=cache_key,
    city_id=city_id,
    item_id=item_id,
    prospect_id=prospect_id,
    search_text=payload.search_text,
    source="scan",
  )
  logger.info(
    "analyze: resolve item_id=%s item=%s error=%s suggestions=%s prospect=%s",
    item_id,
    bool(resolved.get("item")),
    resolved.get("error"),
    len(resolved.get("suggestions") or []),
    bool(resolved.get("prospect")),
  )
  recycle = {"disposals": resolved.get("disposals", [])}
  return AnalyzeResponse(
    item=resolved.get("item"),
    recycle=recycle,
    repair={"available": False},
    donate={"available": False},
    warnings=resolved.get("warnings", []),
    suggestions=resolved.get("suggestions"),
    prospect=resolved.get("prospect"),
    error=resolved.get("error"),
    debug={"city_chain": [payload.city], "vision": vision},
  )


@app.post("/feedback", response_model=FeedbackResponse)
def feedback(payload: FeedbackRequest = Body(...), db: Session = Depends(get_db)):
  if payload.feedback not in (-1, 1):
    raise HTTPException(status_code=400, detail="invalid_feedback")
  city_row = db.execute(
    text("SELECT city_id FROM core.city WHERE code = :code AND is_active = true"),
    {"code": payload.city},
  ).fetchone()
  if not city_row:
    raise HTTPException(status_code=400, detail="invalid_city")
  db.execute(
    text(
      """
      INSERT INTO core.item_feedback (item_id, city_id, lang, feedback, source, session_id, created_at, updated_at)
      VALUES (:item_id, :city_id, :lang, :feedback, :source, :session_id, now(), now())
      ON CONFLICT (item_id, city_id, session_id) DO UPDATE
      SET feedback = EXCLUDED.feedback,
          lang = EXCLUDED.lang,
          source = EXCLUDED.source,
          updated_at = now()
      """
    ),
    {
      "item_id": payload.item_id,
      "city_id": city_row[0],
      "lang": payload.lang,
      "feedback": payload.feedback,
      "source": payload.source,
      "session_id": payload.session_id,
    },
  )
  db.commit()
  logger.info(
    "feedback: city=%s item_id=%s feedback=%s source=%s session_id=%s",
    payload.city,
    payload.item_id,
    payload.feedback,
    payload.source,
    payload.session_id,
  )
  return FeedbackResponse(ok=True)


@app.get("/images/{image_id}")
def get_image(image_id: str, db: Session = Depends(get_db)):
  row = db.execute(
    text(
      """
      SELECT storage_key, content_type
      FROM core.image_asset
      WHERE image_id::uuid = :image_id
      """
    ),
    {"image_id": image_id},
  ).fetchone()
  if not row:
    raise HTTPException(status_code=404, detail="image_not_found")
  path = row[0].replace("/", os.sep)
  return FileResponse(path, media_type=row[1] or "image/jpeg")


@app.get("/admin/images")
def admin_list_images(
  limit: int = Query(50, ge=1, le=200),
  offset: int = Query(0, ge=0),
  db: Session = Depends(get_db),
):
  rows = db.execute(
    text(
      """
      SELECT image_id::text, width, height, source, created_at
      FROM core.image_asset
      ORDER BY created_at DESC
      LIMIT :limit OFFSET :offset
      """
    ),
    {"limit": limit, "offset": offset},
  ).fetchall()
  return {
    "images": [
      {
        "image_id": r[0],
        "image_url": _image_url(r[0]),
        "width": r[1],
        "height": r[2],
        "source": r[3],
        "created_at": r[4].isoformat() if r[4] else None,
      }
      for r in rows
    ]
  }


@app.post("/admin/images")
def admin_upload_image(payload: AdminImageUploadRequest = Body(...)):
  stored = store_image_from_base64(payload.image_base64, source=payload.source or "admin")
  image_id = stored["image_id"]
  return {"image_id": image_id, "image_url": _image_url(image_id)}


@app.get("/admin/items")
def admin_list_items(
  lang: str = Query("de"),
  q: Optional[str] = Query(None),
  limit: int = Query(50, ge=1, le=200),
  offset: int = Query(0, ge=0),
  db: Session = Depends(get_db),
):
  query = f"%{q}%" if q else ""
  rows = db.execute(
    text(
      """
      SELECT i.item_id::text, i.canonical_key, t1.text, t2.text, i.primary_image_id::text, i.is_active
      FROM core.item i
      LEFT JOIN core.i18n_translation t1 ON t1.key = i.title_key AND t1.lang = :lang
      LEFT JOIN core.i18n_translation t2 ON t2.key = i.desc_key AND t2.lang = :lang
      WHERE (
        :q = ''
        OR t1.text ILIKE :q
        OR i.canonical_key ILIKE :q
      )
      ORDER BY t1.text NULLS LAST, i.canonical_key ASC
      LIMIT :limit OFFSET :offset
      """
    ),
    {"lang": lang, "q": query, "limit": limit, "offset": offset},
  ).fetchall()
  return {
    "items": [
      {
        "id": r[0],
        "canonical_key": r[1],
        "title": r[2],
        "description": r[3],
        "primary_image_id": r[4],
        "image_url": _image_url(r[4]),
        "is_active": bool(r[5]),
      }
      for r in rows
    ]
  }


@app.get("/admin/items/{item_id}")
def admin_get_item(
  item_id: str,
  city: str = Query(...),
  lang: str = Query("de"),
  db: Session = Depends(get_db),
):
  city_id = _city_id_from_code(db, city)
  if not city_id:
    raise HTTPException(status_code=400, detail="invalid_city")
  return _admin_item_detail(db, item_id, city_id, lang)


@app.get("/admin/items/{item_id}/images")
def admin_item_images(
  item_id: str,
  db: Session = Depends(get_db),
):
  primary_row = db.execute(
    text("SELECT primary_image_id::text FROM core.item WHERE item_id::uuid = :item_id"),
    {"item_id": item_id},
  ).fetchone()
  primary_image_id = primary_row[0] if primary_row else None
  rows = db.execute(
    text(
      """
      SELECT ia.image_id::text, ia.width, ia.height, ia.source, ia.created_at
      FROM core.image_asset ia
      JOIN (
        SELECT DISTINCT image_id
        FROM core.scan_event
        WHERE item_id::uuid = :item_id
        UNION
        SELECT primary_image_id AS image_id
        FROM core.item
        WHERE item_id::uuid = :item_id AND primary_image_id IS NOT NULL
      ) s ON s.image_id = ia.image_id
      ORDER BY ia.created_at DESC
      """
    ),
    {"item_id": item_id},
  ).fetchall()
  return {
    "images": [
      {
        "image_id": r[0],
        "image_url": _image_url(r[0]),
        "width": r[1],
        "height": r[2],
        "source": r[3],
        "created_at": r[4].isoformat() if r[4] else None,
        "is_primary": r[0] == primary_image_id,
      }
      for r in rows
    ]
  }


@app.post("/admin/items/{item_id}/images")
def admin_upload_item_image(
  item_id: str,
  payload: AdminItemImageUploadRequest = Body(...),
  db: Session = Depends(get_db),
):
  city_id = _city_id_from_code(db, payload.city)
  if not city_id:
    raise HTTPException(status_code=400, detail="invalid_city")
  stored = store_image_from_base64(payload.image_base64, source=payload.source or "admin")
  image_id = stored["image_id"]
  db.execute(
    text(
      """
      INSERT INTO core.scan_event (image_id, city_id, item_id, source, created_at)
      VALUES (:image_id, :city_id, :item_id, :source, now())
      """
    ),
    {
      "image_id": image_id,
      "city_id": city_id,
      "item_id": item_id,
      "source": payload.source or "admin",
    },
  )
  db.commit()
  return {"image_id": image_id, "image_url": _image_url(image_id)}


@app.delete("/admin/items/{item_id}/images/{image_id}")
def admin_delete_item_image(
  item_id: str,
  image_id: str,
  db: Session = Depends(get_db),
):
  db.execute(
    text(
      """
      DELETE FROM core.scan_event
      WHERE item_id::uuid = :item_id AND image_id::uuid = :image_id
      """
    ),
    {"item_id": item_id, "image_id": image_id},
  )
  db.execute(
    text(
      """
      UPDATE core.item
      SET primary_image_id = NULL, updated_at = now()
      WHERE item_id::uuid = :item_id AND primary_image_id::uuid = :image_id
      """
    ),
    {"item_id": item_id, "image_id": image_id},
  )
  has_scan = db.execute(
    text("SELECT 1 FROM core.scan_event WHERE image_id::uuid = :image_id LIMIT 1"),
    {"image_id": image_id},
  ).fetchone()
  has_primary = db.execute(
    text("SELECT 1 FROM core.item WHERE primary_image_id::uuid = :image_id LIMIT 1"),
    {"image_id": image_id},
  ).fetchone()
  if not has_scan and not has_primary:
    db.execute(
      text("UPDATE core.vision_cache SET image_id = NULL WHERE image_id::uuid = :image_id"),
      {"image_id": image_id},
    )
    db.execute(
      text("DELETE FROM core.image_asset WHERE image_id::uuid = :image_id"),
      {"image_id": image_id},
    )
  db.commit()
  return {"ok": True}


@app.put("/admin/items/{item_id}")
def admin_update_item(
  item_id: str,
  payload: AdminItemUpdateRequest = Body(...),
  db: Session = Depends(get_db),
):
  city_id = _city_id_from_code(db, payload.city)
  if not city_id:
    raise HTTPException(status_code=400, detail="invalid_city")
  row = db.execute(
    text(
      """
      SELECT canonical_key, title_key, desc_key
      FROM core.item
      WHERE item_id::uuid = :item_id
      """
    ),
    {"item_id": item_id},
  ).fetchone()
  if not row:
    raise HTTPException(status_code=404, detail="item_not_found")
  canonical_key, title_key, desc_key = row
  if payload.title is not None and title_key:
    _upsert_translation(db, title_key, payload.lang, payload.title)
  if payload.description is not None:
    if not desc_key:
      base = canonical_key if canonical_key.startswith("item.") else f"item.{canonical_key}"
      desc_key = f"{base}.desc"
      db.execute(
        text("UPDATE core.item SET desc_key = :desc_key, updated_at = now() WHERE item_id::uuid = :item_id"),
        {"desc_key": desc_key, "item_id": item_id},
      )
    _upsert_translation(db, desc_key, payload.lang, payload.description)

  if payload.is_active is not None:
    db.execute(
      text("UPDATE core.item SET is_active = :active, updated_at = now() WHERE item_id::uuid = :item_id"),
      {"active": payload.is_active, "item_id": item_id},
    )

  if payload.primary_image_id is not None:
    db.execute(
      text("UPDATE core.item SET primary_image_id = :pid, updated_at = now() WHERE item_id::uuid = :item_id"),
      {"pid": payload.primary_image_id or None, "item_id": item_id},
    )

  _update_item_city_list(
    db,
    table="core.item_city_category",
    city_id=city_id,
    item_id=item_id,
    ref_table="core.category",
    ref_code_col="code",
    ref_id_col="category_id",
    codes=payload.category_codes,
    has_priority=True,
  )
  _update_item_city_list(
    db,
    table="core.item_city_disposal",
    city_id=city_id,
    item_id=item_id,
    ref_table="core.disposal_method",
    ref_code_col="code",
    ref_id_col="disposal_id",
    codes=payload.disposal_codes,
    has_priority=True,
  )
  _update_item_city_list(
    db,
    table="core.item_city_warning",
    city_id=city_id,
    item_id=item_id,
    ref_table="core.warning",
    ref_code_col="code",
    ref_id_col="warning_id",
    codes=payload.warning_codes,
    has_priority=False,
  )
  db.commit()
  return _admin_item_detail(db, item_id, city_id, payload.lang)
