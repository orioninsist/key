FROM ghcr.io/astral-sh/uv:0.9.5 AS uv
FROM python:3.11-slim-bookworm

COPY --from=uv /uv /uvx /bin/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates curl fontconfig fonts-linuxlibertine xz-utils \
    && rm -rf /var/lib/apt/lists/*

ARG TYPST_VERSION=0.15.0
RUN curl -fsSL \
      "https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz" \
      -o /tmp/typst.tar.xz \
    && tar -xJf /tmp/typst.tar.xz -C /tmp \
    && install -m 755 \
      /tmp/typst-x86_64-unknown-linux-musl/typst \
      /usr/local/bin/typst \
    && rm -rf /tmp/typst*

WORKDIR /app

COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev

COPY render.py ./
COPY config/ ./config/
COPY content/ ./content/
COPY schemas/ ./schemas/
COPY templates/ ./templates/
COPY assets/ ./assets/

ENV PATH="/app/.venv/bin:${PATH}"

ENTRYPOINT ["uv", "run", "--no-sync", "render.py"]
