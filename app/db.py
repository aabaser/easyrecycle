import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

def normalize_database_url(value: str) -> str:
  normalized = value.strip()
  if normalized.startswith("postgres://"):
    normalized = "postgresql://" + normalized[len("postgres://"):]
  if normalized.startswith("postgresql://") and "+psycopg" not in normalized.split("://", 1)[0]:
    normalized = "postgresql+psycopg://" + normalized[len("postgresql://"):]
  return normalized


DATABASE_URL = normalize_database_url(
  os.getenv(
    "DATABASE_URL",
    "postgresql+psycopg://postgres:postgres@localhost:5432/easy_recycle",
  ),
)

engine = create_engine(DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)

def get_db():
  db = SessionLocal()
  try:
    yield db
  finally:
    db.close()
