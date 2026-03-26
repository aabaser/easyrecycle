from __future__ import annotations

import secrets
import time
from typing import Any

from jose import jwt

from app.settings import Settings


def _jwt_secret(settings: Settings) -> str:
    if settings.ADMIN_SESSION_JWT_SECRET and settings.ADMIN_SESSION_JWT_SECRET.strip():
        return settings.ADMIN_SESSION_JWT_SECRET.strip()
    return settings.GUEST_JWT_SECRET


def issue_admin_token(api_key: str, settings: Settings) -> dict[str, Any]:
    if not settings.ADMIN_API_KEY:
        raise ValueError("admin_api_key_not_configured")
    if not api_key or not secrets.compare_digest(api_key, settings.ADMIN_API_KEY):
        raise ValueError("invalid_admin_api_key")
    now = int(time.time())
    exp = now + settings.ADMIN_SESSION_TTL_SECONDS
    payload = {
        "iss": "easy-recycle-admin",
        "sub": "admin:session",
        "role": "admin",
        "scope": "admin",
        "iat": now,
        "exp": exp,
    }
    token = jwt.encode(payload, _jwt_secret(settings), algorithm="HS256")
    return {"token": token, "exp": exp, "claims": payload}


def verify_admin_token(token: str, settings: Settings) -> dict[str, Any]:
    return jwt.decode(
        token,
        _jwt_secret(settings),
        algorithms=["HS256"],
        issuer="easy-recycle-admin",
    )
