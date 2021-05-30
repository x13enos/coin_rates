# ./Dockerfile

# Extend from the official Elixir image
FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client

RUN mix local.hex --force \
  && mix archive.install --force hex phx_new 1.5.9 \
  && apt-get update \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash \
  && apt-get install -y apt-utils \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential \
  && apt-get install -y inotify-tools \
  && mix local.rebar --force

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.hex --force

RUN cd ./assets && npm rebuild node-sass

# Compile the project
RUN mix do compile

RUN chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]