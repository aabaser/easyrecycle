from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    APP_ENV: str = "local"
    APP_HOST: str = "0.0.0.0"
    APP_PORT: int = 8000
    LOG_LEVEL: str = "info"

    COGNITO_ENABLED: bool = False
    COGNITO_REGION: str = "eu-central-1"
    COGNITO_USER_POOL_ID: str = ""
    COGNITO_APP_CLIENT_ID: str = ""
    COGNITO_ISSUER: str | None = None

    GUEST_JWT_SECRET: str = "change_me_local_only"
    GUEST_TOKEN_TTL_SECONDS: int = 900

    RATE_LIMIT_ENABLED: bool = True

    model_config = SettingsConfigDict(
        env_file=".env",
        case_sensitive=False,
        extra="ignore",
    )


@lru_cache
def get_settings() -> Settings:
    return Settings()
