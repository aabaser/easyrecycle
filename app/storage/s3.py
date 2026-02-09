from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
import os
import uuid
import boto3
from botocore.config import Config
from botocore.exceptions import BotoCoreError, ClientError
from fastapi import HTTPException
from app.settings import Settings


ALLOWED_CONTENT_TYPES = {"image/jpeg", "image/png"}


@dataclass(frozen=True)
class PresignResult:
  upload_url: str
  s3_key: str
  expires_in: int
  required_headers: dict


def _require_settings(settings: Settings) -> None:
  if not settings.AWS_REGION:
    raise RuntimeError("AWS_REGION is not configured")
  if not settings.S3_BUCKET_NAME:
    raise RuntimeError("S3_BUCKET_NAME is not configured")


def validate_settings(settings: Settings) -> None:
  _require_settings(settings)


def get_s3_client(settings: Settings):
  _require_settings(settings)
  return boto3.client(
    "s3",
    region_name=settings.AWS_REGION,
    config=Config(signature_version="s3v4"),
  )


def _date_prefix() -> str:
  now = datetime.utcnow()
  return f"{now.year:04d}/{now.month:02d}"


def build_object_key(principal: dict, content_type: str, filename: str | None = None) -> str:
  role = principal.get("type")
  sub = principal.get("sub")
  if not sub:
    raise HTTPException(status_code=401, detail="Invalid or expired token")
  if role == "guest" and sub.startswith("guest:"):
    sub = sub.split("guest:", 1)[1]
  prefix = "user" if role == "user" else "guest"
  ext = "jpg" if content_type == "image/jpeg" else "png"
  if filename and "." in filename:
    ext = filename.rsplit(".", 1)[1].lower()
  return f"{prefix}/{sub}/{_date_prefix()}/{uuid.uuid4().hex}.{ext}"


def ensure_allowed_content_type(content_type: str) -> None:
  if content_type not in ALLOWED_CONTENT_TYPES:
    raise HTTPException(status_code=400, detail="unsupported_content_type")


def upload_fileobj(
  settings: Settings,
  fileobj,
  bucket: str,
  key: str,
  content_type: str,
) -> None:
  ensure_allowed_content_type(content_type)
  client = get_s3_client(settings)
  try:
    client.upload_fileobj(
      fileobj,
      bucket,
      key,
      ExtraArgs={"ContentType": content_type},
    )
  except (BotoCoreError, ClientError) as exc:
    raise HTTPException(status_code=502, detail="s3_upload_failed") from exc


def get_object_bytes(settings: Settings, bucket: str, key: str) -> bytes:
  client = get_s3_client(settings)
  try:
    resp = client.get_object(Bucket=bucket, Key=key)
    return resp["Body"].read()
  except (BotoCoreError, ClientError) as exc:
    raise HTTPException(status_code=404, detail="s3_object_not_found") from exc


def create_presigned_put(
  settings: Settings,
  bucket: str,
  key: str,
  content_type: str,
  ttl_seconds: int,
) -> PresignResult:
  ensure_allowed_content_type(content_type)
  client = get_s3_client(settings)
  try:
    url = client.generate_presigned_url(
      ClientMethod="put_object",
      Params={"Bucket": bucket, "Key": key, "ContentType": content_type},
      ExpiresIn=ttl_seconds,
    )
  except (BotoCoreError, ClientError) as exc:
    raise HTTPException(status_code=502, detail="s3_presign_failed") from exc
  return PresignResult(
    upload_url=url,
    s3_key=key,
    expires_in=ttl_seconds,
    required_headers={"Content-Type": content_type},
  )


def create_presigned_get(
  settings: Settings,
  bucket: str,
  key: str,
  ttl_seconds: int,
) -> str:
  client = get_s3_client(settings)
  try:
    return client.generate_presigned_url(
      ClientMethod="get_object",
      Params={"Bucket": bucket, "Key": key},
      ExpiresIn=ttl_seconds,
    )
  except (BotoCoreError, ClientError) as exc:
    raise HTTPException(status_code=502, detail="s3_presign_failed") from exc
