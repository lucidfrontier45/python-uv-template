# python-uv-template
A Project Template of Python with uv

# Install

Please first install the latest uv.
https://docs.astral.sh/uv/getting-started/installation/

Then run the following command to install runtime libraries.

```bash
uv sync --no-dev
```

# Develop

```bash
uv sync
```

This installs the following tools in addition to runtime libraries.

- ruff
- pyright
- pytest-cov
- pytest-xdist
- taskipy

The settings of those linter and formatters are written in `pyproject.toml`

# VSCode Settings

Install/activate all extensions listed in `.vscode/extensions.json`

# Creating Console Script

```toml
[project.scripts]
app = "app.cli:main"
```

# Define Project Command

```toml
[tool.taskipy.tasks]
pyright_lint = "pyright ."
ruff_format = "ruff format ."
ruff_lint = "ruff check ."
ruff_fix = "ruff check --fix ."
test = "pytest tests --cov=app --cov-report=term --cov-report=xml"
format = "task ruff_fix && task ruff_format"
lint = "task ruff_lint && task pyright_lint"
check = "task format && task lint && task test"
```

# Build Docker Image

Please check the `Dockerfile` for how to use multi-stage build with uv.