#!/bin/bash

python -m uvicorn \
    --access-log \
    --host 0.0.0.0 \
    --port 8080 \
    --workers ${N_WORKERS:-1} \
    app.server:webapp