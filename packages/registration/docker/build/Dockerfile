FROM golang:1.19.2-bullseye

## GO Dependency
RUN go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

## Config
RUN useradd -m dev
RUN usermod -a -G root dev

## Bash
COPY ./.bash_aliases /home/dev/.bash_aliases
