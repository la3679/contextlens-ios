"""Reject tracked local artifacts and unsafe environment examples without reading secrets."""

from pathlib import Path
import subprocess
import sys


REQUIRED_IGNORES = (
    "backend/.env", "backend/.env.production", ".env", ".env.test",
    ".local-ai/CHECKPOINT.md", ".codex/state", ".claude/state", ".agents/state",
    "Agents/state", "codex/state", "claude/state", "plans/test", "scratch/test",
    "graphify-out/graph.json", ".graphify/cache", "DerivedData/test", ".build/test",
    "artifacts/test", "logs/test.log", "secrets/key.pem",
)


def git(root: Path, *args: str, input: bytes | None = None) -> subprocess.CompletedProcess:
    return subprocess.run(
        ["git", "-C", str(root), *args], input=input, capture_output=True, check=False,
    )


def check(root: Path) -> list[str]:
    tracked = git(root, "ls-files", "-z")
    if tracked.returncode:
        return ["Cannot enumerate Git index."]
    ignored = git(root, "check-ignore", "--no-index", "-z", "--stdin", input=tracked.stdout)
    if ignored.returncode not in (0, 1):
        return ["Cannot verify Git ignore policy."]
    errors = [
        f"Tracked file violates ignore policy: {path.decode('utf-8')}"
        for path in ignored.stdout.split(b"\0") if path
    ]
    for path in REQUIRED_IGNORES:
        if git(root, "check-ignore", "--no-index", "-q", "--", path).returncode != 0:
            errors.append(f"Required local path is not ignored: {path}")
    # Read only the safe template from the index, never the local environment file.
    example = git(root, "show", ":backend/.env.example")
    if example.returncode:
        errors.append("Missing tracked backend environment template.")
    else:
        assignments = dict(
            line.split("=", 1) for line in example.stdout.decode().splitlines()
            if line and not line.startswith("#") and "=" in line
        )
        if assignments.get("OPENAI_API_KEY", "missing").strip():
            errors.append("Environment template must declare an empty OPENAI_API_KEY.")
        if not {"OPENAI_MODEL", "APP_ENV"}.issubset(assignments):
            errors.append("Environment template is missing required configuration names.")
    return errors


if __name__ == "__main__":
    issues = check(Path(__file__).resolve().parents[1])
    for issue in issues:
        print(issue, file=sys.stderr)
    print("Repository hygiene: " + ("FAIL" if issues else "PASS"))
    raise SystemExit(bool(issues))
