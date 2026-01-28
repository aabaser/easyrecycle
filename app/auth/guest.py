from __future__ import annotations

import time
from typing import Any

from jose import jwt

from app.settings import Settings


def issue_guest_token(device_id: str, settings: Settings) -> dict[str, Any]:
    if not device_id or len(device_id) < 8:
        raise ValueError("device_id_too_short")
    now = int(time.time())
    exp = now + settings.GUEST_TOKEN_TTL_SECONDS
    payload = {
        "iss": "easy-recycle-guest",
        "sub": f"guest:{device_id}",
        "role": "guest",
        "scope": "basic",
        "iat": now,
        "exp": exp,
    }
    token = jwt.encode(payload, settings.GUEST_JWT_SECRET, algorithm="HS256")
    return {"token": token, "exp": exp, "claims": payload}


def verify_guest_token(token: str, settings: Settings) -> dict[str, Any]:
    return jwt.decode(
        token,
        settings.GUEST_JWT_SECRET,
        algorithms=["HS256"],
        issuer="easy-recycle-guest",
    )
