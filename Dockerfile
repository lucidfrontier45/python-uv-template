#---------builder------------
FROM python:3.13-slim-bookworm AS builder
WORKDIR /project

# install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# install dependencies (no lockfile)
# COPY pyproject.toml src /project/
# RUN uv sync --no-dev --all-extras --no-install-project

# install dependencies (with lockfile)
COPY pyproject.toml uv.lock /project/
RUN uv sync --no-dev --all-extras --no-install-project --frozen

#---------runner------------
FROM python:3.13-slim-bookworm AS runner
WORKDIR /project

# add AWS Lambda Web Adapter settings
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.1 /lambda-adapter /opt/extensions/lambda-adapter
ENV AWS_LAMBDA_EXEC_WRAPPER=/opt/bootstrap
ENV PORT=8080

COPY --from=builder /project/.venv /project/.venv
ENV PATH=/project/.venv/bin:$PATH

COPY src/app /project/app

ENV N_WORKERS=1

SHELL ["/bin/bash", "-c"]
CMD python -m uvicorn \
    --access-log \
    --host 0.0.0.0 \
    --port ${PORT} \
    --workers ${N_WORKERS} \
    app.server:webapp
