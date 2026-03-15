import sys
import types

from fastapi import HTTPException
from fastapi.testclient import TestClient
from starlette.requests import Request

if "boto3" not in sys.modules:
    boto3_stub = types.ModuleType("boto3")
    boto3_stub.client = lambda *args, **kwargs: None
    sys.modules["boto3"] = boto3_stub

if "botocore.config" not in sys.modules:
    botocore_stub = types.ModuleType("botocore")
    botocore_config_stub = types.ModuleType("botocore.config")
    botocore_exceptions_stub = types.ModuleType("botocore.exceptions")

    class _DummyConfig:
        def __init__(self, *args, **kwargs):
            pass

    class _DummyBotoError(Exception):
        pass

    botocore_config_stub.Config = _DummyConfig
    botocore_exceptions_stub.BotoCoreError = _DummyBotoError
    botocore_exceptions_stub.ClientError = _DummyBotoError
    sys.modules["botocore"] = botocore_stub
    sys.modules["botocore.config"] = botocore_config_stub
    sys.modules["botocore.exceptions"] = botocore_exceptions_stub

import app.main as main


def _request_with_auth(value: str) -> Request:
    return Request(
        {
            "type": "http",
            "method": "GET",
            "path": "/auth/me",
            "headers": [(b"authorization", value.encode("utf-8"))],
        }
    )


def test_resolve_principal_guest_success(monkeypatch):
    monkeypatch.setattr(
        main,
        "verify_guest_token",
        lambda token, settings: {"sub": "guest:device-123", "scope": "guest basic"},
    )
    principal = main._resolve_principal(_request_with_auth("Bearer guest-token"))
    assert principal["type"] == "guest"
    assert principal["sub"] == "guest:device-123"
    assert principal["scopes"] == ["guest", "basic"]


def test_resolve_principal_invalid_token(monkeypatch):
    def _raise(_token, _settings):
        raise Exception("invalid")

    monkeypatch.setattr(main, "verify_guest_token", _raise)
    try:
        main._resolve_principal(_request_with_auth("Bearer bad-token"))
        assert False, "expected HTTPException"
    except HTTPException as exc:
        assert exc.status_code == 401
        assert exc.detail == "Invalid or expired token"


def test_auth_verify_guest(monkeypatch):
    monkeypatch.setattr(main.settings, "RATE_LIMIT_ENABLED", False, raising=False)
    monkeypatch.setattr(
        main,
        "_resolve_principal",
        lambda request: {
            "type": "guest",
            "sub": "guest:device-verify",
            "scopes": ["guest"],
        },
    )

    client = TestClient(main.app)
    res = client.post("/auth/verify", headers={"Authorization": "Bearer token"})
    assert res.status_code == 200
    body = res.json()
    assert body["type"] == "guest"
    assert body["sub"] == "guest:device-verify"
    assert body["scopes"] == ["guest"]
    assert "user_id" not in body


def test_auth_verify_requires_bearer_header(monkeypatch):
    monkeypatch.setattr(main.settings, "RATE_LIMIT_ENABLED", False, raising=False)
    client = TestClient(main.app)
    res = client.post("/auth/verify")
    assert res.status_code == 401
    assert res.json()["detail"] == "Invalid or expired token"


def test_auth_me_guest(monkeypatch):
    monkeypatch.setattr(main.settings, "RATE_LIMIT_ENABLED", False, raising=False)
    monkeypatch.setattr(
        main,
        "_resolve_principal",
        lambda request: {
            "type": "guest",
            "sub": "guest:device-me",
            "scopes": ["guest", "scan"],
        },
    )
    client = TestClient(main.app)
    res = client.get("/auth/me", headers={"Authorization": "Bearer token"})
    assert res.status_code == 200
    body = res.json()
    assert body == {
        "type": "guest",
        "sub": "guest:device-me",
        "scopes": ["guest", "scan"],
    }
