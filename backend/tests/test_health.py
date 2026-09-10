import socket

import httpx
import pytest
from pytest_socket import SocketConnectBlockedError

from app.config import Settings
from app.main import create_app


@pytest.mark.parametrize("key", [None, "synthetic-test-only"])
@pytest.mark.anyio
async def test_health_is_key_independent_and_reveals_no_configuration(key):
    transport = httpx.ASGITransport(app=create_app(Settings(openai_api_key=key, app_env="test")))
    async with httpx.AsyncClient(transport=transport, base_url="http://test") as client:
        response = await client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok", "service": "contextlens-gateway"}
    assert "synthetic-test-only" not in response.text


@pytest.mark.anyio
async def test_production_disables_schema_and_interactive_docs():
    transport = httpx.ASGITransport(app=create_app(Settings(app_env="production")))
    async with httpx.AsyncClient(transport=transport, base_url="http://test") as client:
        for path in ("/docs", "/redoc", "/openapi.json"):
            assert (await client.get(path)).status_code == 404


def test_external_network_connections_are_blocked():
    with (
        socket.socket() as connection,
        pytest.warns(UserWarning, match="A test tried to use"),
        pytest.raises(SocketConnectBlockedError),
    ):
        connection.connect(("192.0.2.1", 443))
