FROM ruby:3.1.2-bullseye

## Prepare
RUN mkdir /app
WORKDIR /app
COPY entrypoint.sh /entrypoint.sh

## Dependency
RUN apt update && apt install postgresql-client -y

## Config
RUN useradd -m dev
RUN usermod -a -G root dev
