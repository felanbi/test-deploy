FROM python:3.12.7-alpine AS dependencies

WORKDIR /tmp

RUN pip install --upgrade pip && pip install poetry

COPY pyproject.toml poetry.lock ./
RUN poetry export -f requirements.txt --output requirements.txt --without-urls --without-hashes


FROM python:3.12.7-alpine

RUN addgroup -S flask && adduser -S flask -G flask

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh 

USER flask
ENV PATH="$PATH:/home/flask/.local/bin"
WORKDIR /app

COPY --from=dependencies --chown=flask:flask /tmp/requirements.txt . 
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY --chown=flask:flask . .

ENTRYPOINT [ "/entrypoint.sh" ]