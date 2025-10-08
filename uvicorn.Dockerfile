FROM ghcr.io/astral-sh/uv:0.9.0 AS uv-base

###########
# Runtime #
###########
FROM python:3.13.7-alpine as build

ENV UV_SYSTEM_PYTHON=1 \
    UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    PATH="/app/.venv/bin:$PATH"

COPY --from=uv-base /uv /bin/

# Change the working directory to the `app` directory
WORKDIR /app

# Install dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-editable --group=uvicorn

###########
# Runtime #
###########
FROM python:3.13.7-alpine as runtime

LABEL "org.opencontainers.image.authors"="Marc-Aurele Brothier"
LABEL "org.opencontainers.image.url"="https://github.com/marcaurele/flask-servers-testing"
LABEL "org.opencontainers.image.source"="https://github.com/marcaurele/flask-servers-testing/blob/main/Dockerfile"
LABEL "org.opencontainers.image.vendor"="Private"
LABEL "org.opencontainers.image.title"="Flask servers testing"
LABEL "org.opencontainers.image.description"="Image to validate performance for different WSGI and ASGI servers."

ENV UV_SYSTEM_PYTHON=1 \
    UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    PATH="/app/.venv/bin:$PATH"

EXPOSE 8000

COPY --from=uv-base /uv /bin/

# Change the working directory to the `app` directory
WORKDIR /app

# Copy built dependencies
COPY --from=build /app/.venv/ /app/.venv/

ADD src/ /app

# Sync the project
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-editable --group=uvicorn

# Run Uvicorn
CMD ["uvicorn", "--host", "0.0.0.0", "--port", "8000", "--workers", "1", "asgi:asgi_app"]