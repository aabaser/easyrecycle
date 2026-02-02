from __future__ import annotations

import logging
import time
from typing import Any

import httpx
from jose import jwt

from app.settings import Settings

logger = logging.getLogger("easy_recycle.auth")

_JWKS_TTL_SECONDS = 6 * 60 * 60
_jwks_cache: dict[str, Any] = {"expires_at": 0.0, "jwks": None}


def _issuer(settings: Settings) -> str:
    if settings.COGNITO_ISSUER:
        return settings.COGNITO_ISSUER
    return f"https://cognito-idp.{settings.COGNITO_REGION}.amazonaws.com/{settings.COGNITO_USER_POOL_ID}"


def _get_jwks(settings: Settings) -> dict[str, Any]:
    now = time.time()
    if _jwks_cache["jwks"] and _jwks_cache["expires_at"] > now:
        return _jwks_cache["jwks"]
    url = f"{_issuer(settings)}/.well-known/jwks.json"
    resp = httpx.get(url, timeout=10.0)
    resp.raise_for_status()
    jwks = resp.json()
    _jwks_cache["jwks"] = jwks
    _jwks_cache["expires_at"] = now + _JWKS_TTL_SECONDS
    logger.info("cognito: jwks refreshed")
    return jwks


def _select_key(jwks: dict[str, Any], kid: str | None) -> dict[str, Any] | None:
    if not kid:
        return None
    for key in jwks.get("keys", []):
        if key.get("kid") == kid:
            return key
    return None


def verify_cognito_jwt(token: str, settings: Settings) -> dict[str, Any]:
    jwks = _get_jwks(settings)
    headers = jwt.get_unverified_header(token)
    key = _select_key(jwks, headers.get("kid"))
    if not key:
        raise ValueError("jwks_key_not_found")

    claims = jwt.decode(
        token,
        key,
        algorithms=["RS256"],
        issuer=_issuer(settings),
        options={"verify_aud": False},
    )

    token_use = claims.get("token_use")
    if token_use == "id":
        if claims.get("aud") != settings.COGNITO_APP_CLIENT_ID:
            raise ValueError("invalid_audience")
    elif token_use == "access":
        if claims.get("client_id") != settings.COGNITO_APP_CLIENT_ID:
            raise ValueError("invalid_client_id")
    else:
        raise ValueError("invalid_token_use")

    if not claims.get("sub"):
        raise ValueError("missing_sub")

    scope = claims.get("scope") or ""
    scopes = scope.split() if isinstance(scope, str) else list(scope or [])
    groups = claims.get("cognito:groups") or claims.get("groups") or []

    return {
        "sub": claims.get("sub"),
        "token_use": token_use,
        "scopes": scopes,
        "groups": groups,
        "claims": claims,
    }
