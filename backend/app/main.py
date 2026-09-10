"""Application factory; the foundation exposes liveness only, with no upstream calls."""

from typing import Literal

from fastapi import FastAPI
from pydantic import BaseModel

from app.config import Settings, load_settings


class HealthResponse(BaseModel):
    status: Literal["ok"] = "ok"
    service: Literal["contextlens-gateway"] = "contextlens-gateway"


def create_app(settings: Settings | None = None) -> FastAPI:
    configuration = settings if settings is not None else load_settings()
    app = FastAPI(
        title="ContextLens Gateway",
        version="0.1.0",
        docs_url="/docs" if configuration.app_env != "production" else None,
        redoc_url=None,
        openapi_url="/openapi.json" if configuration.app_env != "production" else None,
    )

    @app.get("/health", response_model=HealthResponse)
    async def health() -> HealthResponse:
        # Liveness is deliberately independent of provider credentials and availability.
        return HealthResponse()

    return app
