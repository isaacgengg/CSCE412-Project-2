# Isaac Geng — Project 2

One nginx image, built once, run three ways: as a single container, as five
identical replicas, and as five unique services that differ only by the content
mounted into them at runtime.

The five services are ordinary self-contained HTML pages — a recipe scaler, a
split-flap departure board, a constellation viewer, a bill splitter and a typing
test. No Dockerfile is written per service; content arrives as read-only volume
mounts.

## Prerequisites

- Ubuntu host (an EC2 instance is fine) with Docker Engine and the Compose v2
  plugin. On a fresh host, `scripts/setup.sh` installs both.
- Inbound TCP open on 8080–8095 in the instance's security group.

## Build

```bash
./scripts/build.sh
```

Tags `my-nginx-container:1.0` and `:latest`. All three compose files use `:1.0`.

## Run

```bash
# 1 — single container                                 -> :8080
docker compose up -d

# 2 — five identical replicas                          -> :8081-8085
docker compose -f docker-compose.scale.yml up -d --scale web=5

# 3 — five unique services                             -> :8091-8095
docker compose -f docker-compose.unique.yml up -d
```

| Port | Service | Content |
|------|---------|---------|
| 8080 | landing page | baked into the image |
| 8081–8085 | landing page ×5 | baked into the image |
| 8091 | Recipe Scaler | `./services/recipe` |
| 8092 | Departure Board | `./services/board` |
| 8093 | Constellations | `./services/sky` |
| 8094 | Bill Splitter | `./services/split` |
| 8095 | Typing Test | `./services/typing` |

Stop a mode with `down`, using the same `-f` flag you started it with.

## Verify

```bash
./scripts/verify.sh
```

Prints tool versions, the image, running containers, and an HTTP check of
8091–8095. Exits non-zero if any service is not returning 200. Set `HOST=` to
check a remote instance.
