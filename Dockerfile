#---------uv------------------
FROM --platform=$BUILDPLATFORM ghcr.io/astral-sh/uv:latest AS uv_host 

#---------builder------------
FROM --platform=$BUILDPLATFORM python:3.13-slim AS builder
WORKDIR /project
ARG TARGETOS
ARG TARGETARCH
RUN echo "Building for $TARGETOS/$TARGETARCH"

# install uv
COPY --from=uv_host /uv /usr/bin/uv

# build package
WORKDIR /project
COPY pyproject.toml uv.lock build.sh /project/
COPY src /project/src

RUN bash build.sh

#---------runner------------
FROM python:3.13-slim AS runner
WORKDIR /project

# add AWS Lambda Web Adapter settings
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.1 /lambda-adapter /opt/extensions/lambda-adapter

COPY --from=builder /project/package /project
COPY run.sh /project/

ENV N_WORKERS=1

CMD ["/bin/bash", "run.sh"]