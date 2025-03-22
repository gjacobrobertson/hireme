FROM node:22.14.0-bullseye-slim AS dev

WORKDIR /opt/app

CMD ["scripts/server"]

FROM dev AS build

COPY . .

RUN ["scripts/build"]
