FROM python:3.12.7-alpine AS dependencies
WORKDIR /tmp
COPY pyproject.toml poetry.lock ./
RUN apk update && \
    pip install --upgrade pip && \
    pip install poetry && \
    poetry export -f requirements.txt --output requirements.txt --without-urls --without-hashes

FROM python:3.12.7-slim
WORKDIR /app
COPY --from=dependencies /tmp/requirements.txt .
RUN apt update && \
    pip install --upgrade pip && \
    pip install -r requirements.txt
COPY . .
RUN chmod +x entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]

