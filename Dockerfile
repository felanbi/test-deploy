FROM python:3.12.7-alpine AS dependencies

WORKDIR /tmp

RUN apk update && \
    pip install --upgrade pip && \
    pip install poetry

COPY pyproject.toml poetry.lock ./
RUN poetry export -f requirements.txt --output requirements.txt --without-urls --without-hashes


FROM python:3.12.7-alpine

RUN apk update &&\
    addgroup -S flask &&\
    adduser -S flask -G flask

COPY --chown=flask:flask entrypoint.sh .
RUN chmod +x entrypoint.sh 

USER flask

COPY --from=dependencies /tmp/requirements.txt . 
RUN pip install --upgrade pip && pip install -r requirements.txt

WORKDIR /app
COPY . .

ENTRYPOINT [ "/entrypoint.sh" ]