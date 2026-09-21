FROM nginx:stable-alpine

LABEL org.opencontainers.image.title="IG"
LABEL org.opencontainers.image.description="One nginx image, run three ways: single, replicated, and as five content-only services."

# Only the landing page is baked in. Copying site/ rather than . keeps the rest
# of the repo (compose files, scripts, the five services) out of the web root.
COPY site/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
