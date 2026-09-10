from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from check_repository import check  # noqa: E402


class RepositoryHygieneTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        subprocess.run(["git", "init", "-q", str(self.root)], check=True)
        source = Path(__file__).resolve().parents[2]
        (self.root / ".gitignore").write_bytes((source / ".gitignore").read_bytes())
        (self.root / "backend").mkdir()
        (self.root / "backend/.env.example").write_text(
            "OPENAI_API_KEY=\nOPENAI_MODEL=\nAPP_ENV=development\n"
        )
        self.stage(".gitignore", "backend/.env.example")

    def stage(self, *paths):
        subprocess.run(["git", "-C", str(self.root), "add", "-f", "--", *paths], check=True)

    def test_safe_repository_and_untracked_secret_are_allowed(self):
        (self.root / "backend/.env").write_text("OPENAI_API_KEY=synthetic-test-only\n")
        self.assertEqual(check(self.root), [])

    def test_force_added_environment_is_rejected_without_content(self):
        (self.root / "backend/.env").write_text("sensitive-test-marker")
        self.stage("backend/.env")
        issues = check(self.root)
        self.assertTrue(any("backend/.env" in issue for issue in issues))
        self.assertNotIn("sensitive-test-marker", str(issues))

    def test_weakened_ignore_rule_is_rejected(self):
        with (self.root / ".gitignore").open("a") as stream:
            stream.write("\n!backend/.env\n")
        self.assertTrue(any("not ignored: backend/.env" in issue for issue in check(self.root)))

    def test_nonempty_example_key_is_rejected_without_content(self):
        (self.root / "backend/.env.example").write_text(
            "OPENAI_API_KEY=sensitive-test-marker\nOPENAI_MODEL=\nAPP_ENV=development\n"
        )
        self.stage("backend/.env.example")
        issues = check(self.root)
        self.assertTrue(issues)
        self.assertNotIn("sensitive-test-marker", str(issues))


if __name__ == "__main__":
    unittest.main()
