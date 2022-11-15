FROM node:18.12-bullseye

## Prepare
RUN mkdir /app
WORKDIR /app
COPY entrypoint.sh /entrypoint.sh

## Dependency
# RUN 

## Config
RUN useradd -m dev
RUN usermod -a -G root dev
