"""Backend settings. Never serialize or log credential values."""

from pathlib import Path
from typing import Literal

from pydantic import Field, SecretStr, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

DEFAULT_OPENAI_MODEL = "gpt-5.4-mini-2026-03-17"


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=None,
        extra="ignore",
        hide_input_in_errors=True,
        env_ignore_empty=True,
    )

    openai_api_key: SecretStr | None = Field(default=None, repr=False, exclude=True)
    openai_model: str = DEFAULT_OPENAI_MODEL
    app_env: Literal["development", "test", "production"] = "development"

    @field_validator("openai_model", mode="before")
    @classmethod
    def default_for_blank_model(cls, value: str) -> str:
        return value.strip() or DEFAULT_OPENAI_MODEL

    @field_validator("openai_api_key", mode="before")
    @classmethod
    def normalize_key(cls, value: str | SecretStr | None) -> str | SecretStr | None:
        if isinstance(value, str):
            return value.strip() or None
        return value


def load_settings() -> Settings:
    """Only the backend entry point loads its local environment file."""
    return Settings(_env_file=Path(__file__).resolve().parents[1] / ".env")
