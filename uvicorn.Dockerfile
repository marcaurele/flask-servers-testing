####################
### Build / Wheels #
####################
FROM python:3.11.4-alpine3.17 as requirements

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    # pip
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    # poetry
    POETRY_HOME=/opt/poetry \
    POETRY_NO_INTERACTION=1

RUN set -ex \
    && apk add --no-cache \
        build-base \
        curl \
        libev-dev \
        linux-headers \
    && pip install poetry

WORKDIR /tmp

COPY pyproject.toml poetry.lock /tmp/

RUN set -ex \
  && poetry export -f requirements.txt --output requirements.txt \
  && pip wheel --no-cache-dir \
      --wheel-dir /wheels \
      --requirement requirements.txt

###############
# Development #
###############
FROM requirements as development

RUN set -ex \
  && poetry config virtualenvs.options.system-site-packages true \
	&& poetry config virtualenvs.create false \
	&& poetry install --no-root --no-interaction --no-ansi --without=dev

WORKDIR /build/src

COPY ./src /build/src/

# Uvicorn
CMD ["uvicorn", "--host", "0.0.0.0", "--port", "8000", "--workers", "1", "asgi:asgi_app"]

###########
# Runtime #
###########
FROM python:3.11.4-alpine3.17 as runtime

LABEL "org.opencontainers.image.authors"="Marc-Aurele BRothier"
LABEL "org.opencontainers.image.url"="https://github.com/marcaurele/flask-servers-testing"
LABEL "org.opencontainers.image.source"="https://github.com/marcaurele/flask-servers-testing/blob/main/Dockerfile"
LABEL "org.opencontainers.image.vendor"="Private"
LABEL "org.opencontainers.image.title"="Flask servers testing"
LABEL "org.opencontainers.image.description"="Image to validate performance for different WSGI and ASGI servers."

COPY --from=requirements /wheels/ /wheels/

RUN set -ex \
    && apk add --no-cache \
        libev \
    && python -m pip install --no-cache-dir --no-index /wheels/* \
    && rm -rf /wheels \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY ./src /app

# Uvicorn
CMD ["uvicorn", "--host", "0.0.0.0", "--port", "8000", "--workers", "1", "asgi:asgi_app"]