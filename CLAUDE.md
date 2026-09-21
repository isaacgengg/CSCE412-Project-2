Project 2 — build the container project files

You are working in the repo root. scripts/setup.sh already exists — do not modify it. Create everything else described below.

Context

This is a university cloud-computing assignment. A single nginx image is built once, then run three ways: one container, five identical replicas, and five unique services.

The five unique services differ by CONTENT ONLY — same image, content arrives via read-only volume mounts at runtime. Do not write per-service Dockerfiles.

The finished repo gets cloned onto an Ubuntu EC2 instance and run with Docker Compose v2.

Target structure
.
├── Dockerfile
├── .dockerignore
├── docker-compose.yml            # 1 container  -> 8080
├── docker-compose.scale.yml      # 5 identical  -> 8081-8085
├── docker-compose.unique.yml     # 5 unique     -> 8091-8095
├── README.md
├── site/index.html               # baked into the image
├── services/
│   ├── recipe/index.html
│   ├── board/index.html
│   ├── sky/index.html
│   ├── split/index.html
│   └── typing/index.html
└── scripts/
    ├── setup.sh                  # EXISTS — leave alone
    ├── build.sh
    └── verify.sh
Hard constraints
Every HTML file is fully self-contained: inline <style> and <script>, no external CSS/JS/fonts/images, no CDN, no build step, no npm, no fetch calls to anything.
All data (recipes, flights, constellations, typing passages) is hardcoded in a JS object at the top of the file.
No absolute asset paths.
Works at 1280px desktop and on a 390px phone.
Plain ES5/ES6 that runs in any current browser. No frameworks.
Shared identity across all six pages

Invent a short product name and a simple SVG mark, then use both consistently:

Same fixed header bar on every page: mark + wordmark on the left, page name on the right.
Same type scale, spacing rhythm, and neutral base palette across all pages.
One distinct accent color per service so they're individually recognisable but obviously a family.
Footer on every page giving the service name and the port it runs on.

Aim for something that looks deliberately designed, not a default template. Avoid generic AI-design tells: no cream-and-terracotta palette, no tracked-out all-caps eyebrow labels, no identical rounded cards with the same soft grey shadow everywhere, no arrow glyphs glued onto button text.

The five services
services/recipe/index.html — Recipe scaler, port 8091

Four or five built-in recipes. Pick one, drag a servings slider, all ingredient quantities rescale live. Render fractions properly (3/4 cup x 1.5 becomes 1 1/8, not 1.125). Tickable checkboxes on each ingredient and each step.

services/board/index.html — Flight departure board, port 8092

Airport split-flap departures display. Rows of invented flights: airline, destination, gate, time, status. Characters flip through an alphabet when a row changes. Statuses cycle on a timer so the board is visibly alive. This one should look striking — it's the screenshot that sells the project.

services/sky/index.html — Constellation viewer, port 8093

Canvas star field with roughly 12 real constellations plotted. Hover highlights a constellation's lines and name; click shows a short blurb on its mythology and brightest star. Slider for time of night rotates the sky.

services/split/index.html — Bill splitter, port 8094

Simple mode: total, tip percentage, number of people, big readable per-person figure. Itemized mode: add line items, assign each to one or more people, compute who owes what with tax and tip distributed proportionally.

services/typing/index.html — Typing speed test, port 8095

60-second timed test over rotating passages. Live WPM and accuracy. Correct characters green, errors red as typed. Results screen with WPM, accuracy, and most-missed characters. Personal best in localStorage, with access wrapped in try/catch.

site/index.html

A branded landing page for the base image — what the project is, the three run modes, and a table of the five services with their ports. This is what the single container and the five identical replicas serve.

Dockerfile
FROM nginx:stable-alpine
LABEL org.opencontainers.image.title="<product name>"
COPY site/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

Copy site/ only, not . — the rest of the repo must not end up in the web root. Write .dockerignore to match.

Compose files

All three use image my-nginx-container:1.0. Compose v2 syntax, no version: key.

docker-compose.yml — one service, 8080:80.
docker-compose.scale.yml — one service named web, ports "8081-8085:80" (a RANGE, so --scale web=5 gives each replica its own host port), bridge network, healthcheck.
docker-compose.unique.yml — five services (recipe, board, sky, split, typing) on 8091-8095, each mounting ./services/<name>:/usr/share/nginx/html:ro. Use a YAML anchor for the shared config. Container names p2-<name>. Healthcheck: ["CMD", "wget", "-qO-", "http://localhost/"].

Comment the compose files properly — explaining what each block does and why. Half the assignment's documentation grade rests on these two files being legible.

scripts/build.sh

Builds my-nginx-container tagged both :1.0 and :latest, then lists the image. Start with cd "$(dirname "$0")/.." so it works from anywhere.

scripts/verify.sh

Prints docker and compose versions, the image list, running containers, then loops 8091-8095 checking each returns HTTP 200. Readable output — this gets screenshotted.

README.md

Short. What it is, prerequisites, and the three run commands.

Before you finish

Validate every compose file with docker compose -f <file> config -q. Open each HTML file and confirm there are zero external references. Report anything you could not verify without a running Docker daemon.
