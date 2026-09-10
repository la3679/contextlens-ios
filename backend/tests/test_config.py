import pytest
from pydantic import SecretStr

from app.config import DEFAULT_OPENAI_MODEL, Settings


@pytest.mark.parametrize("value", [None, "", "   "])
def test_missing_or_blank_environment_model_uses_default(monkeypatch, value):
    if value is not None:
        monkeypatch.setenv("OPENAI_MODEL", value)
    assert Settings().openai_model == DEFAULT_OPENAI_MODEL


def test_explicit_model_override_is_preserved(monkeypatch):
    monkeypatch.setenv("OPENAI_MODEL", " custom-test-model ")
    assert Settings().openai_model == "custom-test-model"


def test_blank_dotenv_model_uses_default_and_key_is_private(tmp_path):
    env = tmp_path / ".env"
    env.write_text("OPENAI_API_KEY=synthetic-test-only\nOPENAI_MODEL=\nAPP_ENV=test\n")
    settings = Settings(_env_file=env)
    assert settings.openai_model == DEFAULT_OPENAI_MODEL
    assert isinstance(settings.openai_api_key, SecretStr)
    assert "synthetic-test-only" not in repr(settings)
    assert "openai_api_key" not in settings.model_dump()
    assert "synthetic-test-only" not in settings.model_dump_json()


@pytest.mark.parametrize("value", ["", "   "])
def test_empty_key_is_unconfigured(value):
    assert Settings(openai_api_key=value).openai_api_key is None


def test_settings_do_not_implicitly_read_dotenv(tmp_path, monkeypatch):
    (tmp_path / ".env").write_text("OPENAI_API_KEY=synthetic-test-only\n")
    monkeypatch.chdir(tmp_path)
    assert Settings().openai_api_key is None
