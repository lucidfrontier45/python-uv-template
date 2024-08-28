#---------builder------------
FROM python:3.12-slim-bookworm AS builder
WORKDIR /project

# install rye
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# install dependencies (no lockfile)
COPY pyproject.toml /project/
RUN uv sync --no-dev --all-extras

# install dependencies (with lockfile)
# COPY pyproject.toml uv.lock /project/
# RUN uv sync --no-dev --frozen

#---------runner------------
FROM python:3.12-slim-bookworm AS runner
WORKDIR /project

COPY --from=builder /project/.venv /project/.venv
ENV PATH=/project/.venv/bin:$PATH

COPY src/app /project/app

ENV N_WORKERS=4

SHELL ["/bin/bash", "-c"]
CMD uvicorn \
    --access-log \
    --host 0.0.0.0 \
    --port 8080 \
    --workers ${N_WORKERS} \
    app.server:app