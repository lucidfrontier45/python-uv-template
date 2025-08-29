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
It also support AWS Lambda with AWS Lambda Web Adapter as well as multi-platform image with cross build approach.

# Build AWS Lambda Zip Package

Use one of the following scripts.

```sh
bash awslambda/build_package.sh --python-version 3.13 --python-arch aarch64
nu awslambda/build_package.sh --python-version 3.13 --python-arch aarch64
pwsh awslambda/build_package.ps1 -PythonVersion 3.13 -PythonArch aarch64
```

It requires your managed runtime is correctly configured to support AWS Lambda Web Adapter.

See https://github.com/awslabs/aws-lambda-web-adapter?tab=readme-ov-file#lambda-functions-packaged-as-zip-package-for-aws-managed-runtimes

The scripts internally use `lzpb` to make sure `run.sh` and `bootstrap` have exec permission.
You can get the latest `lzpb` binary here.
https://github.com/lucidfrontier45/lzpb/releases