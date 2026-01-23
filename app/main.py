from typing import Optional
import logging
from dotenv import load_dotenv
import time
from fastapi import FastAPI, Depends, Query, Body, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from app.db import get_db
from app.services.resolve import resolve_item
from app.integrations.openai_vision import recognize_item_from_base64
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
