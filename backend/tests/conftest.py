import pytest


@pytest.fixture
def anyio_backend():
    return "asyncio"


@pytest.fixture(autouse=True)
def isolate_environment(monkeypatch):
    for name in ("OPENAI_API_KEY", "OPENAI_MODEL", "APP_ENV"):
        monkeypatch.delenv(name, raising=False)
