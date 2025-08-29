#!/bin/bash

# amd64 -> x86_64
# arm64 -> aarch64
PYTHON_ARCH=$(echo ${TARGETARCH} | sed -e 's/amd64/x86_64/' -e 's/arm64/aarch64/')
PYTHON_PLATFORM="${PYTHON_ARCH}-manylinux_2_34"

uv export --no-dev --no-emit-project --frozen --all-extras > .requirements.lock
uv pip install --python-platform ${PYTHON_PLATFORM} --target package --only-binary :all: -r .requirements.lock
uv pip install --python-platform ${PYTHON_PLATFORM} --target package .