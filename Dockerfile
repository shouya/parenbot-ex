FROM elixir:alpine AS build
RUN apk --no-cache add ca-certificates curl git

RUN mkdir /src
WORKDIR /src

VOLUME ./deps
VOLUME ./_build

ENV MIX_ENV=prod
RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
COPY lib/ ./lib
COPY config/ ./config

RUN mix deps.get
RUN mix compile
RUN mix release


FROM elixir:alpine
RUN apk --no-cache add curl git bash

RUN mkdir /app

WORKDIR /app
COPY --from=build /src/_build/prod/rel/parenbot ./
CMD ./bin/parenbot start


