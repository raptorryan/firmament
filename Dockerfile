ARG ELIXIR="1.14.3"
ARG OTP="25.2.3"
ARG DEBIAN="bullseye-20230202-slim"

ARG BUILD="hexpm/elixir:${ELIXIR}-erlang-${OTP}-debian-${DEBIAN}"
ARG APP="debian:${DEBIAN}"

FROM ${BUILD} as build

RUN apt-get update -y
RUN apt-get install -y build-essential git
RUN apt-get clean
RUN rm -f /var/lib/apt/lists/*_*

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

ENV MIX_ENV="prod"

COPY . .

RUN mix deps.get --only ${MIX_ENV}
RUN mix deps.compile
RUN mix compile
RUN mix asset.setup
RUN mix asset.deploy
RUN mix release

FROM ${APP}

RUN apt-get update -y
RUN apt-get install -y libstdc++6 openssl libncurses5 locales
RUN apt-get clean
RUN rm -f /var/lib/apt/lists/*_*
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
RUN locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

ENV MIX_ENV="prod"

COPY --from=build --chown=nobody:root /app/_build/${MIX_ENV}/rel/firmament ./

RUN chmod +x /app/bin/server

USER nobody

CMD ["/app/bin/server"]

ENV ERL_AFLAGS "-proto_dist inet6_tcp"
