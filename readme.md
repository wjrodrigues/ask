# ASK

Project developed based on the material available in the course [Becoming a Modern Software Engineer](https://www.ituring.com.br/modern-software-engineer/) from [Ituring](https://www.ituring.com.br)

Purpose is to register questions and their answers in a collaborative way.

## Stack

- [Docker](https://www.docker.com/) and [Docker compose](https://docs.docker.com/compose/)
- [PostgreSQL](https://www.postgresql.org/)
- [Keycloack](https://www.keycloak.org/)

## Services

- [Access management](https://github.com/wjrodrigues/ask/tree/main/packages/access_management)
- [Registration](https://github.com/wjrodrigues/ask/tree/main/packages/registration)
- [Frontend](https://github.com/wjrodrigues/ask/tree/main/packages/frontend)

## Start

Copy file with environment variables

```bash
cp docker/.env-example .env
```

Run container

```bash
docker-compose up -d
```