FROM python:3.11.2-alpine3.17 as builder

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
  && poetry export -f requirements.txt --output requirements.txt --without-hashes

RUN set -ex \
  && poetry config virtualenvs.options.system-site-packages true \
	&& poetry config virtualenvs.create false \
	&& poetry install --no-root --no-interaction --no-ansi --without=dev

WORKDIR /build/src

COPY ./src /build/src/

# Bjoern
CMD ["python", "wsgi.py"]
