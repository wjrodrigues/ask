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
- [Message broker](https://github.com/wjrodrigues/ask/tree/main/packages/message_broker)

## Start

Run containers

Start service all

```bash
make start
```

Start individual service

```bash
make infra
make access_management
make message_broker
make registration
make frontend
```
