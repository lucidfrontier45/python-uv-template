#!/bin/bash

python -m uvicorn \
    --access-log \
    --host 0.0.0.0 \
    --port 8080 \
    app.server:webapp