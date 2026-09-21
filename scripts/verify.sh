#!/usr/bin/env bash
# Proof-of-life for the whole project: versions, the image, what is running,
# and an HTTP check against each of the five unique services.
# Intended to be run after:
#   docker compose -f docker-compose.unique.yml up -d
set -uo pipefail

cd "$(dirname "$0")/.."

HOST=${HOST:-localhost}
PORTS=(8091 8092 8093 8094 8095)
NAMES=(recipe board sky split typing)

rule() { printf '%s\n' "------------------------------------------------------------"; }
section() { echo; rule; echo "  $1"; rule; }

section "Tooling"
docker --version
docker compose version

section "Image"
docker image ls my-nginx-container --format 'table {{.Repository}}:{{.Tag}}	{{.ID}}	{{.Size}}	{{.CreatedSince}}'

section "Running containers"
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}'

section "HTTP check — the five unique services on ${HOST}"
fail=0
for i in "${!PORTS[@]}"; do
  port=${PORTS[$i]}
  name=${NAMES[$i]}
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "http://${HOST}:${port}/" || echo 000)
  if [ "$code" = "200" ]; then
    printf '  %-8s port %s   HTTP %s   OK\n' "$name" "$port" "$code"
  else
    printf '  %-8s port %s   HTTP %s   FAILED\n' "$name" "$port" "$code"
    fail=$((fail + 1))
  fi
done

echo
if [ "$fail" -eq 0 ]; then
  echo "  All ${#PORTS[@]} services returned HTTP 200."
else
  echo "  ${fail} of ${#PORTS[@]} services did not return HTTP 200."
fi
rule
exit "$fail"
