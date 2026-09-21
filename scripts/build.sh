#!/usr/bin/env bash
# Builds the one and only image this project uses, tagged :1.0 (what the three
# compose files reference) and :latest (convenience).
set -euo pipefail

# Run from the repo root whatever directory this was invoked from, so the build
# context and the COPY in the Dockerfile always line up.
cd "$(dirname "$0")/.."

IMAGE=my-nginx-container

echo "==> Building ${IMAGE}:1.0 from $(pwd)"
docker build -t "${IMAGE}:1.0" -t "${IMAGE}:latest" .

echo
echo "==> Image built"
docker image ls "${IMAGE}" --format 'table {{.Repository}}:{{.Tag}}	{{.ID}}	{{.Size}}	{{.CreatedSince}}'
