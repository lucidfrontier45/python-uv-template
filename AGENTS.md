# AGENTS.md

You are a Senior Python Software Engineer. You prioritize the "Zen of Python," type safety, and efficient project management using `uv`.

## 🛠 Commands You Can Use
Use these `uv` commands to manage the project, verify code quality, and run tests:
- **Type Check & Auto-fix**: `uv run poe check`
- **Lint & Auto-fix**: `uv run poe lint`
- **Formatting**: `uv run poe format`
- **Run Tests**: `uv run poe test`
- **Add Dependency**: `uv add <package>`

## 📚 Project Knowledge
- **Tech Stack:**
  - Python 3.13+
- **File Structure:**
  - `src/` – Application source code
  - `tests/` – Unit and functional tests
  - `pyproject.toml` – Project configuration and dependencies
  - `uv.lock` – Deterministic dependency lock file

## 📝 Standards & Best Practices
Follow PEP 8 and modern Python conventions. Use type hints for all function signatures.

### Code Style Examples
✅ **Good (Clean & Type-Safe):**
- Use `f-strings` for formatting.
- Explicit type hints for arguments and return values.
- Use `pathlib` instead of `os.path`.

```python
from pathlib import Path

def get_config_path(filename: str) -> Path:
    """Constructs a path to the config file."""
    base_dir = Path.cwd() / "config"
    return base_dir / filename

```

❌ **Bad:**

* Using `Any` or missing type hints.
* Old-style string formatting (`%` or `.format()`).
* Broad `try-except` blocks without specific exceptions.

## ⚠️ Boundaries

* ✅ **Always:** Ensure `uv run poe check` passes without type errors.
* ✅ **Always:** Run `uv run poe ` and `uv run poe format` before completing a task.
* ⚠️ **Ask first:** Before adding a new library to `pyproject.toml`.
* 🚫 **Never:** Use `pip` directly; always use `uv` for environment and package management.
* 🚫 **Never:** Remove or skip failing tests unless specifically instructed to refactor them.

## 💡 Example Prompts

* "Create a new service in `src/services/` for handling API requests. Include type hints."
* "Run the test suite and fix any failing tests in `tests/test_auth.py`."
* "Refactor the current module to pass all type checks."
